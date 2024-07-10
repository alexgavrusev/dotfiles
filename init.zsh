#! /usr/bin/env zsh

#####################################
# Prelude
#####################################

export ZPREZTODIR=$HOME/Developer/prezto
export ZDOTDIR=$HOME/.zsh

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
    git clone --recursive https://github.com/alexgavrusev/prezto.git $ZPREZTODIR
    git -C $ZPREZTODIR remote add upstream https://github.com/sorin-ionescu/prezto.git

    mkdir -p $ZDOTDIR

    # forward zshenv/etc to ZDOTDIR
    cat <<EOF >> ~/.zshenv
ZPREZTODIR=$ZPREZTODIR
ZDOTDIR=$ZDOTDIR
. $ZDOTDIR/.zshenv
EOF

    $HOMEBREW_PREFIX/bin/zsh $DOTFILES_DIR/init_prezto.zsh

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
# Asdf, required for node
#####################################

ensure_asdf() {
    if ! command -v asdf &> /dev/null; then
       echo "asdf is not installed"
       exit 1
    fi

    # add the shims to the path
    . $(brew --prefix asdf)/libexec/asdf.sh 
}

#####################################
# Node
#####################################

install_node() {
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

    # 2 latest LTSes
    NODE_LTS_VERSIONS=(${(f)"$(asdf list all nodejs | grep lts- | tail -2)"})
    # latest active
    NODE_CURRENT_VERSION="$(asdf list all nodejs | grep -v lts | tail -1)"

    # concat to a single array
    NODE_VERSIONS=($NODE_LTS_VERSIONS $NODE_CURRENT_VERSION)
    
    NODE_GLOBAL_PACKAGES=("vercel")

    for version in "${NODE_VERSIONS[@]}"
    do
        asdf install nodejs $version
    done

    # use latest as global
    asdf global nodejs ${NODE_VERSIONS[-1]}

    npm i -g ${NODE_GLOBAL_PACKAGES[@]}
}

if ask "Install node and global npm packages?" Y; then
    ensure_asdf
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
