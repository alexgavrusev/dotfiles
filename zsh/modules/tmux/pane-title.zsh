#
# tmux pane titles, inspired by the `terminal` module in prezto.
#
# Sets the active pane's title (#{pane_title}, shown on the pane border) to the
# command being run (preexec) and back to the current directory (precmd).
#

# Emits OSC 2 so tmux records the argument as the pane title.
# (V) makes control characters visible to avoid escape-sequence injection.
function _tmux-set-pane-title {
  printf '\e]2;%s\a' ${(V)1}
}

# Idle: show the current directory (%~ honours ~ and named dirs).
function _tmux-pane-title-precmd {
  _tmux-set-pane-title ${(%):-%~}
}

# Running: show the full command line ($2 has aliases expanded).
function _tmux-pane-title-preexec {
  _tmux-set-pane-title $2
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd  _tmux-pane-title-precmd
add-zsh-hook preexec _tmux-pane-title-preexec
