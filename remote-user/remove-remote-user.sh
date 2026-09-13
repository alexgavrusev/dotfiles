#!/bin/bash

# Remove a dedicated remote macOS user and the private SSH service created by
# setup-remote-user.sh. Each part is optional so a partial setup can be removed
# without disturbing components that should remain in place.

set -euo pipefail

readonly LOOPBACK_SSH_PORT=2222
readonly TAILNET_SSH_PORT=22
readonly LAUNCHD_LABEL="com.local.tailscale-openssh"
readonly LAUNCHD_PLIST="/Library/LaunchDaemons/$LAUNCHD_LABEL.plist"

usage() {
    cat <<'EOF'
Usage: ./remote-user/remove-remote-user.sh <remote-user>

Example:
  ./remote-user/remove-remote-user.sh remote-user

The script must be run by a non-root user.
It will ask which parts of the remote-user setup to remove and request
administrator privileges with sudo.
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

[[ $# -eq 1 ]] || { usage >&2; exit 2; }
[[ $EUID -ne 0 ]] || fail "run this as your normal local user, not as root"

REMOTE_USER=$1
REMOTE_HOME="/Users/$REMOTE_USER"
REMOTE_GROUP=$REMOTE_USER
AUTHORIZED_KEYS_DIR="/etc/ssh/authorized_keys"
AUTHORIZED_KEYS_FILE="$AUTHORIZED_KEYS_DIR/$REMOTE_USER"
SSHD_CONFIG="/etc/ssh/sshd_config.d/100-tailscale-$REMOTE_USER.conf"
SSH_DIR="$REMOTE_HOME/.ssh"
SSH_KEY="$SSH_DIR/id_ed25519"
DOTFILES_DIR="$REMOTE_HOME/Developer/dotfiles"

printf 'Requesting administrator privileges...\n'
sudo -v

if ask "Remove $REMOTE_USER from macOS SSH access policy (com.apple.access_ssh)?"; then
    if /usr/bin/dscl . -read "/Users/$REMOTE_USER" >/dev/null 2>&1; then
        sudo /usr/sbin/dseditgroup -o edit -d "$REMOTE_USER" -t user com.apple.access_ssh
    else
        printf 'User %s does not exist; skipping access-policy membership removal.\n' "$REMOTE_USER"
    fi
fi

if ask "Stop publishing TCP port $TAILNET_SSH_PORT with Tailscale Serve?"; then
    command -v tailscale >/dev/null 2>&1 || fail "tailscale is not installed or not in PATH"
    sudo tailscale serve --tcp="$TAILNET_SSH_PORT" off
fi

if ask "Stop and remove the private, loopback-only OpenSSH service?"; then
    if sudo /bin/launchctl print "system/$LAUNCHD_LABEL" >/dev/null 2>&1; then
        sudo /bin/launchctl bootout "system/$LAUNCHD_LABEL"
    fi
    sudo /bin/rm -f "$LAUNCHD_PLIST" /var/log/tailscale-openssh.log
fi

if ask "Remove the OpenSSH configuration for $REMOTE_USER?"; then
    sudo /bin/rm -f "$SSHD_CONFIG"
    sudo /usr/sbin/sshd -t
fi

if ask "Remove the inbound SSH key for $REMOTE_USER?"; then
    sudo /bin/rm -f "$AUTHORIZED_KEYS_FILE"
    sudo /bin/rmdir "$AUTHORIZED_KEYS_DIR" 2>/dev/null || true
fi

if ask "Delete the remote user $REMOTE_USER and its home folder $REMOTE_HOME?"; then
    if /usr/bin/dscl . -read "/Users/$REMOTE_USER" >/dev/null 2>&1; then
        sudo /usr/sbin/sysadminctl -deleteUser "$REMOTE_USER"
    else
        printf 'User %s does not exist.\n' "$REMOTE_USER"
        if ask "Delete the leftover home folder $REMOTE_HOME anyway?"; then
            sudo /bin/rm -rf "$REMOTE_HOME"
        fi
    fi
fi

if ask "Delete the private group $REMOTE_GROUP?"; then
    if /usr/bin/dscl . -read "/Groups/$REMOTE_GROUP" >/dev/null 2>&1; then
        sudo /usr/sbin/dseditgroup -o delete "$REMOTE_GROUP"
    else
        printf 'Group %s does not exist; skipping.\n' "$REMOTE_GROUP"
    fi
fi

if ask "Re-enable Apple Remote Login? This exposes the system SSH service on network interfaces."; then
    sudo /usr/sbin/systemsetup -setremotelogin on
fi

cat <<EOF

Selected remote-user removal steps are complete.

If all removal steps were accepted, the following were removed:
  - Tailscale Serve TCP publication on port $TAILNET_SSH_PORT
  - loopback-only OpenSSH service on port $LOOPBACK_SSH_PORT
  - dedicated OpenSSH configuration and inbound key
  - macOS SSH access-policy membership
  - outbound GitHub key and cloned dotfiles
  - remote user $REMOTE_USER, its home folder, and its private group
EOF
