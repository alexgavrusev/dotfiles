# Enable Powerlevel10k instant prompt. Should stay close to the top of $ZDOTDIR/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZPLUGINDIR=$HOME/.local/share/zsh/plugins

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

#
# Homebrew completion
#
function setup-homebrew-completion() {
  if [[ -d "${HOMEBREW_PREFIX:=$(brew --prefix)}/share/zsh/site-functions" ]]; then
    fpath[1,0]="$HOMEBREW_PREFIX/share/zsh/site-functions";
  fi
}

#
# Homebrew command not found handler
#
function setup-homebrew-command-not-found-handler() {
  if [[ -s ${hb_cnf_handler::="${HOMEBREW_REPOSITORY:-$commands[brew]:A:h:h}/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"} ]]; then
    source "$hb_cnf_handler"
    unset hb_cnf_handler
  fi
}

#
# Environment inspired by `environment` module in prezto
#
function setup-environment() {
  # Bracketed paste and smart URLs
  # See https://github.com/zsh-users/zsh/blob/7798fd88ac42f55980fb9832f2f7e379392fe6aa/Functions/Zle/bracketed-paste-url-magic
  autoload -Uz bracketed-paste-url-magic
  zle -N bracketed-paste bracketed-paste-url-magic
  
  # General
  setopt COMBINING_CHARS      # Combine zero-length punctuation characters (accents)
                              # with the base character.
  setopt INTERACTIVE_COMMENTS # Enable comments in interactive shell.
  setopt RC_QUOTES            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
  unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.
  
  # Jobs
  setopt LONG_LIST_JOBS     # List jobs in the long format by default.
  setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
  setopt NOTIFY             # Report status of background jobs immediately.
  unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
  unsetopt HUP              # Don't kill jobs on shell exit.
  unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
  
  export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
  export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
  export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
  export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
  export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
  export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
  export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.
}

#
# History inspired by `history` module in prezto
#
function setup-history() {
  setopt BANG_HIST              						   # Treat the '!' character specially during expansion.
  setopt EXTENDED_HISTORY       						   # Write the history file in the ':start:elapsed;command' format.
  setopt SHARE_HISTORY          						   # Share history between all sessions.
  setopt HIST_EXPIRE_DUPS_FIRST 						   # Expire a duplicate event first when trimming history.
  setopt HIST_IGNORE_DUPS       						   # Do not record an event that was just recorded again.
  setopt HIST_IGNORE_ALL_DUPS   						   # Delete an old recorded event if a new event is a duplicate.
  setopt HIST_FIND_NO_DUPS      						   # Do not display a previously found event.
  setopt HIST_IGNORE_SPACE      						   # Do not record an event starting with a space.
  setopt HIST_SAVE_NO_DUPS      						   # Do not write a duplicate event to the history file.
  setopt HIST_VERIFY            						   # Do not execute immediately upon history expansion.
  setopt HIST_BEEP              						   # Beep when accessing non-existent history.
  HISTFILE="${HISTFILE:-${ZDOTDIR:-$HOME}/.zsh_history}" # The path to the history file.
  HISTSIZE=10000                                         # The maximum number of events to save in the internal history.
  SAVEHIST=$HISTSIZE                                     # The maximum number of events to save in the history file.
}

#
# Directory inspired by `directory` module in prezto
#
function setup-directory() {
  setopt AUTO_CD              # Auto changes to a directory without typing cd.
  setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
  setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
  setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
  setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
  setopt CDABLE_VARS          # Change directory to a path stored in a variable.
  setopt MULTIOS              # Write to multiple descriptors.
  setopt EXTENDED_GLOB        # Use extended globbing syntax.
  unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                              # Use >! and >>! to bypass.
  alias -- -='cd -'
  alias d='dirs -v'
}


#
# gnu-utils module in prezto
#
function setup-gnu-utils() {
  _gnu_utility_cmds=(
    # Coreutils
    '[' 'b2sum' 'base32' 'base64' 'basename' 'basenc' 'cat' 'chcon' 'chgrp'
    'chmod' 'chown' 'chroot' 'cksum' 'comm' 'cp' 'csplit' 'cut'
    'date' 'dd' 'df' 'dir' 'dircolors' 'dirname' 'du' 'echo' 'env' 'expand' 'expr'
    'factor' 'false' 'fmt' 'fold' 'groups' 'head' 'hostid' 'id' 'install' 'join'
    'kill' 'link' 'ln' 'logname' 'ls' 'md5sum' 'mkdir' 'mkfifo'
    'mknod' 'mktemp' 'mv' 'nice' 'nl' 'nohup' 'nproc' 'numfmt' 'od'
    'paste' 'pathchk' 'pinky' 'pr' 'printenv' 'printf' 'ptx' 'pwd'
    'readlink' 'realpath' 'rm' 'rmdir' 'runcon'
    'seq' 'sha1sum' 'sha224sum' 'sha256sum' 'sha384sum' 'sha512sum' 'shred' 'shuf'
    'sleep' 'sort' 'split' 'stat' 'stdbuf' 'stty' 'sum' 'sync' 'tac' 'tail'
    'tee' 'test' 'timeout' 'touch' 'tr' 'true' 'truncate' 'tsort' 'tty'
    'uname' 'unexpand' 'uniq' 'unlink' 'uptime' 'users' 'vdir'
    'wc' 'who' 'whoami' 'yes'
  
    # The following utilities are not part of Coreutils but installed separately.
  
    # Binutils
    'addr2line' 'ar' 'c++filt' 'coffdump' 'dlltool' 'dllwrap' 'elfedit' 'nm'
    'objcopy' 'objdump' 'ranlib' 'readelf'
    'size' 'srconv' 'strings' 'strip' 'sysdump' 'windmc' 'windres'
  
    # Findutils
    'find' 'locate' 'oldfind' 'updatedb' 'xargs'
  
    # Libtool
    'libtool' 'libtoolize'
  
    # Miscellaneous
    'awk' 'getopt' 'grep' 'indent' 'make' 'sed' 'tar' 'time' 'units' 'which'
  )
  
  # Wrap GNU utilities in functions.
  for _gnu_utility_cmd in "${_gnu_utility_cmds[@]}"; do
    _gnu_utility_pcmd="g${_gnu_utility_cmd}"
    if (( $+commands[$_gnu_utility_pcmd] \
          && ! $+builtins[$_gnu_utility_cmd] )); then
      eval "
        function $_gnu_utility_cmd {
          '$commands[$_gnu_utility_pcmd]' \"\$@\"
        }
      "
    fi
  done
  
  unset _gnu_utility_{p,cmds,cmd,pcmd}
}

#
# Utility inspired by `utility` module in prezto
#
function setup-utils() {
  # Disable correction.
  alias ack='nocorrect ack'
  alias cd='nocorrect cd'
  alias cp='nocorrect cp'
  alias grep='nocorrect grep'
  alias ln='nocorrect ln'
  alias man='nocorrect man'
  alias mkdir='nocorrect mkdir'
  alias mv='nocorrect mv'
  alias rm='nocorrect rm'
  
  # Disable globbing.
  alias fc='noglob fc'
  alias find='noglob find'
  alias history='noglob history'
  alias locate='noglob locate'
  alias scp='noglob scp'
  alias sftp='noglob sftp'
  
  alias mkdir="${aliases[mkdir]:-mkdir} -p"
  
  alias cp="${aliases[cp]:-cp} -i"
  alias ln="${aliases[ln]:-ln} -i"
  alias mv="${aliases[mv]:-mv} -i"
  alias rm="${aliases[rm]:-rm} -i"
  
  # Checks if a name is a command, function, or alias.
  function is-callable {
    (( $+commands[$1] || $+functions[$1] || $+aliases[$1] || $+builtins[$1] ))
  }
  
  # Define colors for GNU ls if they're not already defined
  if (( ! $+LS_COLORS )); then
    # Try dircolors when available
    if is-callable 'dircolors'; then
  	# NOTE: this path is taken
      eval "$(dircolors --sh $HOME/.dir_colors(N))"
    else
      export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
    fi
  fi
  
  alias ls="${aliases[ls]:-ls} --color=auto"
  
  alias l='ls -1lhA'
  
  export GREP_COLORS=${GREP_COLORS:-"mt=$GREP_COLOR"} # GNU.
  
  alias grep="${aliases[grep]:-grep} --color=auto"
}

#
# Directory dot expansion, taken from `editor` prezto module
#
function setup-directory-dot-expansion() {
  function expand-dot-to-parent-directory-path {
    if [[ $LBUFFER = *.. ]]; then
      LBUFFER+='/..'
    else
      LBUFFER+='.'
    fi
  }
  zle -N expand-dot-to-parent-directory-path
  
  bindkey -M viins "." expand-dot-to-parent-directory-path
}

#
# Vi mode
#
function setup-vi-mode() {
  bindkey -v
  
  # Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second), see https://www.johnhawthorn.com/2012/09/vi-escape-delays
  export KEYTIMEOUT=1
  
  # Get codes with `cat -v`
  
  # To fix delete after insert mode -> command mode -> insert mode. See https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
  bindkey -M viins "^?" backward-delete-char
  
  # Bind Shift + Tab to go to the previous menu item
  bindkey -M viins "^[[Z" reverse-menu-complete
  
  # Bind UP and DOWN key to history substring search, in vim insert mode
  bindkey -M viins '^[[A' history-substring-search-up
  bindkey -M viins '^[[B' history-substring-search-down
  # Bind k and j to history substring search, in vim cmd mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

#
# Git
#
function setup-git() {
  alias g='git'
  
  alias gs='git status'
  
  alias ga='git add'
  alias gaa='git add --all'
  
  alias gb='git branch --verbose'
  alias gba='git branch --all --verbose'
  
  alias gco='git checkout'
  alias gcob='git checkout -b'
  
  alias gc='git commit --verbose'
  alias gca='git commit --verbose --all'
  
  alias gf='git fetch'
  
  alias gpr='git pull --rebase'
  alias gpra='git pull --rebase --autostash'
  
  alias gm="git merge"
  
  alias grb='git rebase'
  alias grbi='git rebase --interactive'
  
  alias glog="git log --oneline --decorate --graph"	
  alias gloga="git log --oneline --decorate --graph --all"
}

#
# Completion inspired by `completion` module in prezto
#
function setup-completion() {
  setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
  setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
  setopt PATH_DIRS            # Perform path search even on command names with slashes.
  setopt AUTO_MENU            # Show completion menu on a successive tab press.
  setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
  setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
  setopt EXTENDED_GLOB        # Needed for file modification glob modifiers with compinit.
  unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
  unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.
  
  # Enable the "new" completion system (compsys).
  local dumpfile=$HOME/.local/share/zsh/.zcompdump
  autoload -Uz compinit && compinit -d $dumpfile
  [[ $dumpfile.zwc -nt $dumpfile ]] || zcompile-many $dumpfile
  
  # User _approximate to allow completions to undergo corrections
  zstyle ':completion:*' completer _complete _approximate
  
  # Increase the number of errors
  zstyle ':completion:*:approximate:*' max-errors 4 numeric
  
  # Start menu selection unconditionally
  zstyle ':completion:*' menu select
  
  # Colors for files and directories
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  
  # Include dotfiles
  _comp_options+=(globdots)
  
  # Case-insensitive
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
  
  # Styles for descriptions of types of matches
  zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
  # Styles for description of completion corrections
  zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}-- %d (errors: %e) --%f'
  zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
  zstyle ':completion:*' format ' %F{green}-- %d --%f'
}

#
# Autosuggestions
#
function ensure-installed-zsh-autosuggestions() {
  if [[ ! -e $ZPLUGINDIR/zsh-autosuggestions ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZPLUGINDIR/zsh-autosuggestions
    zcompile-many $ZPLUGINDIR/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
  fi
}

function setup-zsh-autosuggestions() {
  source $ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
  # https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#disabling-automatic-widget-re-binding
  ZSH_AUTOSUGGEST_MANUAL_REBIND=1
}

#
# Syntax highlighting
#
function ensure-instaled-zsh-syntax-highlighting() {
  if [[ ! -e $ZPLUGINDIR/zsh-syntax-highlighting ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZPLUGINDIR/zsh-syntax-highlighting
    zcompile-many $ZPLUGINDIR/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
  fi
}

function setup-zsh-syntax-highlighting() {
  source $ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
}

#
# History substring search
#
function ensure-instaled-zsh-history-substring-search() {
  if [[ ! -e $ZPLUGINDIR/zsh-history-substring-search ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git $ZPLUGINDIR/zsh-history-substring-search
    zcompile-many $ZPLUGINDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
  fi
}

function setup-history-substring-search() {
  source $ZPLUGINDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
  HISTORY_SUBSTRING_SEARCH_PREFIXED=''
}

#
# Nvm inspired by `nvm` omz plugin
#
function _nvm_setup_completion {
  local _nvm_completion="$NVM_DIR/bash_completion"
  
  # Load nvm bash completion
  if [[ -f "$_nvm_completion" ]]; then
    # Load bashcompinit
    autoload -U +X bashcompinit && bashcompinit
    # Bypass compinit call in nvm bash completion script. See:
    # https://github.com/nvm-sh/nvm/blob/4436638/bash_completion#L86-L93
    ZSH_VERSION= source "$_nvm_completion"
  fi

  unfunction _nvm_setup_completion
}

function setup-nvm() {
  export NVM_DIR="$HOME/.nvm"

  if [[ -z "$NVM_DIR" ]] || [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
    return
  fi

  nvm_lazy_cmd=(_omz_nvm_load nvm node npm npx pnpm pnpx yarn corepack $nvm_lazy_cmd) # default values
  eval "
    function $nvm_lazy_cmd {
      for func in $nvm_lazy_cmd; do
        if (( \$+functions[\$func] )); then
          unfunction \$func
        fi
      done
      # Load nvm if it exists in \$NVM_DIR
      [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
      _nvm_setup_completion
      if [[ \"\$0\" != _omz_nvm_load ]]; then
        \"\$0\" \"\$@\"
      fi
    }
  "
  unset nvm_lazy_cmd
}

#
# Podman
#
function setup-podman() {
  if [[ ! -e "/opt/podman/bin" ]]; then
	return
  fi

  export PATH="/opt/podman/bin:$PATH"

  podman completion -f "${fpath[1]}/_podman" zsh
}

#
# P10k
#
function ensure-installed-p10k() {
	if [[ ! -e $ZPLUGINDIR/powerlevel10k ]]; then
	  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZPLUGINDIR/powerlevel10k
	fi
}

function setup-p10k() {
  source $ZPLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme
  
  # To customize prompt, run `p10k configure` or edit $ZDOTDIR/.p10k.zsh.
  source $ZDOTDIR/.p10k.zsh
}

setup-homebrew-completion

setup-homebrew-command-not-found-handler

setup-environment

setup-history

setup-directory

setup-gnu-utils

setup-utils

setup-directory-dot-expansion

setup-vi-mode

setup-git

setup-completion

ensure-installed-zsh-autosuggestions
setup-zsh-autosuggestions

ensure-instaled-zsh-syntax-highlighting
setup-zsh-syntax-highlighting

ensure-instaled-zsh-history-substring-search
setup-history-substring-search

setup-nvm

setup-podman

ensure-installed-p10k
setup-p10k

