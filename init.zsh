#! /usr/bin/env zsh

#####################################
# Prelude
#####################################

export ZDOTDIR=$HOME/.config/zsh

DOTFILES_DIR=`pwd -P`
UNAME_MACHINE="$(/usr/bin/uname -m)"

# source: https://djm.me/ask
ask() {
    local prompt default reply

    if [[ ${2:-} = 'Y' ]]; then
        prompt='Y/n'
        default='Y'
    elif [[ ${2:-} = 'N' ]]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -r reply </dev/tty

        # Default?
        if [[ -z $reply ]]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}


#####################################
# Rosetta (required for some casks)
#####################################

if  [ $UNAME_MACHINE = "arm64" ] && ask "Install rosetta?" Y; then
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license  
fi

#####################################
# Homebrew
#####################################

# Make homebrew available after installation
shellenv_brew() {
    echo "Running brew shellenv"

    if [[ "${UNAME_MACHINE}" == "arm64" ]]
    then
        # ARM macOS
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        # Intel macOS
        HOMEBREW_PREFIX="/usr/local"
    fi

    eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"    	
}

install_homebrew() {
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew not found, installing"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        shellenv_brew
    else
        echo "Homebrew installed, upgrading"
        brew update
        brew upgrade
    fi

    echo "Installing bundle"
    cd homebrew && brew bundle
}

if ask "Install homebrew and apps?" Y; then
    install_homebrew
fi

#####################################
# Fonts
#####################################

install_fonts() {
    cd $DOTFILES_DIR/fonts

    for f in *; do
        if [ -d "$f" ]; then
            echo "Installing font $f"
            cp -r $f/* ~/Library/Fonts
        fi
    done
}

if ask "Install fonts?" Y; then
    install_fonts
fi

#####################################
# Shell
#####################################

configure_shell() {
    echo "Linking zsh config"
    ln -sf $DOTFILES_DIR/zsh $ZDOTDIR

    # forward zshenv/etc to ZDOTDIR
    cat <<EOF > ~/.zshenv
ZDOTDIR=$ZDOTDIR
. $ZDOTDIR/.zshenv
EOF

    current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
    sudo dscl . -change $HOME UserShell $current_shell "$HOMEBREW_PREFIX/bin/zsh"
}

if ask "Configure shell?" Y; then
    configure_shell
fi

#####################################
# Terminal
#####################################

configure_terminal() {
    echo "Linking tmux config"
    ln -sf $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf 

    echo "Linking kitty config"
    ln -sf $DOTFILES_DIR/kitty ~/.config/kitty

    echo "Linking nvim config"
    ln -sf $DOTFILES_DIR/nvim ~/.config/nvim
}

if ask "Configure the terminal (tmux, kitty, nvim)?" Y; then
    configure_terminal
fi

#####################################
# fnm, required for node
#####################################

ensure_fnm() {
    if ! command -v fnm &> /dev/null; then
       echo "fnm not found, installing"
       curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
    fi

    eval "$(fnm env)"
}

#####################################
# Node
#####################################

install_node() {
    # concat to a single array
    NODE_VERSIONS=("lts-jod" "lts-iron")
    
    NODE_GLOBAL_PACKAGES=("vercel")

    for version in "${NODE_VERSIONS[@]}"
    do
	    fnm i $version
    done

    npm i -g ${NODE_GLOBAL_PACKAGES[@]}
}

if ask "Install node and global npm packages?" Y; then
    ensure_fnm
    install_node
fi

#####################################
# Defaults
# FDA is required to modify some plists
#####################################

if ask "Set up macOS defaults?" Y && ask "Does the current terminal have Full Disk Access?" N; then
    ./defaults.sh
fi

echo "Finished Init script. Note that some changes require a restart to take effect"
