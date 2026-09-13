#!/bin/bash

# Set up a dedicated remote macOS user with key-only SSH access over Tailscale.
#
# The script creates a hidden, non-admin user without a password, assigns a
# private primary group, and creates a mode-700 home directory. It can also
# generate the user's outbound GitHub key and clone this dotfiles repository.
#
# Instead of enabling Apple Remote Login, a private LaunchDaemon runs OpenSSH on
# 127.0.0.1:2222. Tailscale Serve publishes that loopback service to the tailnet
# on port 22, with no SSH listener or Bonjour advertisement on other interfaces.
#
# Because Apple Remote Login and the private daemon both use
# sshd-keygen-wrapper, the script checks the system TCC database for an existing
# Full Disk Access grant before disabling Remote Login. If a grant exists, it
# must be disabled in System Settings; tccutil cannot safely reset this
# standalone executable by itself.
#
# OpenSSH accepts only the remote user from IPv4 loopback, using a
# root-controlled authorized-key file outside the user's home. The inbound key
# is restricted to loopback connections, matching Tailscale Serve's backend
# traffic (although local processes can also reach the backend). Interactive
# shells and PTYs remain available, while forwarding, tunneling, X11, user
# environment files, and user rc files are disabled. Apple's SSH PAM policy
# still checks com.apple.access_ssh, so the remote user is added to that group.
#
# Tailscale grants must separately restrict which tailnet clients can reach this
# Mac. Tailnet Lock can require trusted nodes to sign newly added nodes.

set -euo pipefail

readonly LOOPBACK_SSH_PORT=2222
readonly TAILNET_SSH_PORT=22
readonly LAUNCHD_LABEL="com.local.tailscale-openssh"
readonly LAUNCHD_PLIST="/Library/LaunchDaemons/$LAUNCHD_LABEL.plist"

usage() {
    cat <<'EOF'
Usage: ./remote-user/setup-remote-user.sh <remote-user> <public-key-file>

Example:
  ./remote-user/setup-remote-user.sh remote-user ~/.ssh/id_ed25519.pub

The script must be run by a non-root user.
It will ask for administrator privileges with sudo.

Prerequisites:
  - macOS
  - Tailscale installed, running, and connected to your tailnet
  - Tailscale Serve enabled for the tailnet
  - a new remote username whose account and home directory do not exist
  - the dedicated, single-line SSH public key that user will connect with
  - Full Disk Access for the terminal, as required by `systemsetup` on some
    macOS versions
EOF
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

ask() {
    local reply

    while true; do
        printf '%s [y/n] ' "$1"
        read -r reply </dev/tty

        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
    usage
    exit 0
fi

[[ $# -eq 2 ]] || { usage >&2; exit 2; }
[[ $EUID -ne 0 ]] || fail "run this as your normal local user, not as root"

REMOTE_USER=$1
PUBLIC_KEY_FILE=$2
PUBLIC_KEY=$(<"$PUBLIC_KEY_FILE")

AUTHORIZED_KEYS_TMP=$(mktemp)
SSHD_CONFIG_TMP=$(mktemp)
LAUNCHD_PLIST_TMP=$(mktemp)
cleanup() {
    rm -f "$AUTHORIZED_KEYS_TMP" "$SSHD_CONFIG_TMP" "$LAUNCHD_PLIST_TMP"
}
trap cleanup EXIT

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null | head -n 1 || true)
[[ $TAILSCALE_IP == 100.* ]] || fail "Tailscale is not connected (no Tailscale IPv4 address found)"
printf 'Tailscale is connected as %s.\n' "$TAILSCALE_IP"

printf 'Requesting administrator privileges...\n'
sudo -v

if ask "Prepare macOS for the private SSH service by checking Full Disk Access and disabling Apple Remote Login?"; then
    readonly TCC_DB="/Library/Application Support/com.apple.TCC/TCC.db"
    if ! SSHD_HAS_FDA=$(sudo /usr/bin/sqlite3 -readonly "$TCC_DB" \
        "SELECT EXISTS(
            SELECT 1 FROM access
            WHERE service = 'kTCCServiceSystemPolicyAllFiles'
              AND auth_value = 2
              AND client IN (
                  'com.apple.sshd-keygen-wrapper',
                  '/usr/libexec/sshd-keygen-wrapper'
              )
        );"); then
        fail "could not inspect sshd Full Disk Access in $TCC_DB"
    fi

    if [[ $SSHD_HAS_FDA == 1 ]]; then
        fail "sshd-keygen-wrapper has Full Disk Access. Turn off 'Allow full disk access for remote users' under System Settings > General > Sharing > Remote Login, then rerun this script"
    fi

    printf 'sshd-keygen-wrapper does not have Full Disk Access.\n'
    sudo /usr/sbin/systemsetup -setremotelogin off
fi

REMOTE_HOME="/Users/$REMOTE_USER"
AUTHORIZED_KEYS_DIR="/etc/ssh/authorized_keys"
AUTHORIZED_KEYS_FILE="$AUTHORIZED_KEYS_DIR/$REMOTE_USER"
SSHD_CONFIG="/etc/ssh/sshd_config.d/100-tailscale-$REMOTE_USER.conf"

if ask "Create the dedicated remote user $REMOTE_USER with password login disabled?"; then
    sudo /usr/sbin/sysadminctl -addUser "$REMOTE_USER" \
        -fullName "Remote User" \
        -home "$REMOTE_HOME" \
        -shell /bin/zsh
    sudo /usr/bin/pwpolicy -u "$REMOTE_USER" \
        -setpolicy "canModifyPasswordforSelf=0"
    printf 'Created remote user %s with password login disabled.\n' "$REMOTE_USER"
fi

REMOTE_GROUP=$REMOTE_USER
if ask "Give $REMOTE_USER a private primary group, hide the account, and secure its home directory?"; then
    sudo /usr/sbin/dseditgroup -o create "$REMOTE_GROUP"
    REMOTE_GID=$(/usr/bin/dscl . -read "/Groups/$REMOTE_GROUP" PrimaryGroupID | awk '{print $2}')
    sudo /usr/bin/dscl . -create "/Users/$REMOTE_USER" PrimaryGroupID "$REMOTE_GID"
    sudo /usr/bin/dscl . -create "/Users/$REMOTE_USER" IsHidden 1
    sudo /usr/bin/install -d -m 700 -o "$REMOTE_USER" -g "$REMOTE_GROUP" "$REMOTE_HOME"
fi

if ask "Install the restricted inbound SSH key for $REMOTE_USER?"; then
    AUTHORIZED_KEY="restrict,pty,from=\"127.0.0.1\" $PUBLIC_KEY"
    printf '%s\n' "$AUTHORIZED_KEY" > "$AUTHORIZED_KEYS_TMP"
    sudo /usr/bin/install -d -m 755 -o root -g wheel "$AUTHORIZED_KEYS_DIR"
    sudo /usr/bin/install -m 644 -o root -g wheel "$AUTHORIZED_KEYS_TMP" "$AUTHORIZED_KEYS_FILE"
fi

if ask "Configure and validate key-only OpenSSH access for $REMOTE_USER?"; then
    cat > "$SSHD_CONFIG_TMP" <<EOF
PermitRootLogin no
PermitUserEnvironment no
AllowUsers $REMOTE_USER@127.0.0.1

Match User $REMOTE_USER
    PubkeyAuthentication yes
    AuthenticationMethods publickey
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    AuthorizedKeysFile $AUTHORIZED_KEYS_FILE
    AuthorizedKeysCommand none
    AuthorizedPrincipalsFile none
    TrustedUserCAKeys none
    AllowAgentForwarding no
    AllowTcpForwarding no
    AllowStreamLocalForwarding no
    GatewayPorts no
    PermitTunnel no
    X11Forwarding no
    PermitUserRC no
    MaxAuthTries 3
    MaxSessions 2

Match all
EOF

sudo /usr/bin/install -m 644 -o root -g wheel "$SSHD_CONFIG_TMP" "$SSHD_CONFIG"
sudo /usr/bin/ssh-keygen -A
sudo /usr/sbin/sshd -t
fi

if ask "Install and start the private, loopback-only OpenSSH service?"; then
    cat > "$LAUNCHD_PLIST_TMP" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LAUNCHD_LABEL</string>
    <key>Program</key>
    <string>/usr/libexec/sshd-keygen-wrapper</string>
    <key>ProgramArguments</key>
    <array>
        <string>sshd-keygen-wrapper</string>
    </array>
    <key>Sockets</key>
    <dict>
        <key>Listeners</key>
        <dict>
            <key>SockNodeName</key>
            <string>127.0.0.1</string>
            <key>SockServiceName</key>
            <integer>$LOOPBACK_SSH_PORT</integer>
            <key>SockFamily</key>
            <string>IPv4</string>
            <key>SockProtocol</key>
            <string>TCP</string>
        </dict>
    </dict>
    <key>inetdCompatibility</key>
    <dict>
        <key>Wait</key>
        <false/>
        <key>Instances</key>
        <integer>8</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>/var/log/tailscale-openssh.log</string>
</dict>
</plist>
EOF

sudo /usr/bin/install -m 644 -o root -g wheel "$LAUNCHD_PLIST_TMP" "$LAUNCHD_PLIST"
sudo /bin/launchctl bootstrap system "$LAUNCHD_PLIST"
fi

if ask "Publish the private SSH service to the tailnet with Tailscale Serve?"; then
    sudo tailscale serve --bg --tcp="$TAILNET_SSH_PORT" \
    "tcp://127.0.0.1:$LOOPBACK_SSH_PORT"
fi

if ask "Allow $REMOTE_USER through macOS SSH access policy (com.apple.access_ssh)?"; then
    sudo /usr/sbin/dseditgroup -o edit -a "$REMOTE_USER" -t user com.apple.access_ssh
fi

SSH_DIR="$REMOTE_HOME/.ssh"
SSH_KEY="$SSH_DIR/id_ed25519"
if ask "Generate an outbound GitHub SSH key for $REMOTE_USER in $SSH_DIR?"; then
    sudo /usr/bin/install -d -m 700 -o "$REMOTE_USER" -g "$REMOTE_GROUP" "$SSH_DIR"

    sudo -u "$REMOTE_USER" env HOME="$REMOTE_HOME" /usr/bin/ssh-keygen -q \
        -t ed25519 -f "$SSH_KEY" -N "" -C "$REMOTE_USER"
    sudo /bin/cat "$SSH_KEY.pub" | /usr/bin/pbcopy
    printf 'The remote user GitHub public key is on your clipboard. Add it at https://github.com/settings/ssh/new before cloning the dotfiles.\n'
fi

DOTFILES_DIR="$REMOTE_HOME/Developer/dotfiles"
if ask "Clone alexgavrusev/dotfiles into $DOTFILES_DIR?"; then
    sudo -u "$REMOTE_USER" /bin/mkdir -p "$REMOTE_HOME/Developer"
    sudo -H -u "$REMOTE_USER" /usr/bin/git -C "$REMOTE_HOME" \
        clone git@github.com:alexgavrusev/dotfiles.git "$DOTFILES_DIR"
fi

cat <<EOF

Selected remote-user setup steps are complete.

If you accepted all SSH setup steps, connect from an authorized tailnet device:
  ssh $REMOTE_USER@$TAILSCALE_IP

Connection path:
  $TAILSCALE_IP:$TAILNET_SSH_PORT -> Tailscale Serve -> 127.0.0.1:$LOOPBACK_SSH_PORT -> OpenSSH

The complete setup provides:
  - Apple Remote Login disabled
  - no SSH listener on LAN or public interfaces
  - no Bonjour SSH advertisement
  - loopback-only OpenSSH backend on port $LOOPBACK_SSH_PORT
  - tailnet-only Tailscale Serve frontend on port $TAILNET_SSH_PORT
  - a dedicated hidden, non-admin remote user with no password
  - key-only authentication from authorized tailnet devices
  - forwarding, tunneling, agent forwarding, X11, and user rc disabled

Configure a narrow tailnet grant and remove broader allow-all rules:

  {
    "tagOwners": {
      "tag:ssh-client": ["your-email@example.com"],
      "tag:ssh-server": ["your-email@example.com"]
    },
    "grants": [
      {
        "src": ["tag:ssh-client"],
        "dst": ["tag:ssh-server"],
        "ip": ["tcp:$TAILNET_SSH_PORT"]
      }
    ]
  }

Also consider enabling Tailnet Lock:
  https://tailscale.com/docs/features/tailnet-lock
EOF
