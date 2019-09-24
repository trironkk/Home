export GOROOT="$HOME/local/go/golang"
export GOPATH="$HOME/local/go/packages"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# History configuration.
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
zshaddhistory() { print -sr "${(z)1%%$'\n'}"; return 1 }

# FZF configuration.
export FZF_TMUX=1
export FZF_BASE="$USER/.fzf"
export FZF_CTRL_T_COMMAND="ag '' -l --hidden"
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Oh My Zsh configuration.
HIST_STAMPS="mm/dd/yyyy"
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(git fzf)
source $ZSH/oh-my-zsh.sh

bindkey '\eb' vi-backward-word
bindkey '\ef' vi-forward-word

# Prompt setup.
export THEME_COLOR=white
export FG_PROMPT_COLOR=black
export BG_PROMPT_COLOR=$THEME_COLOR
export PS1="%{$fg[$FG_PROMPT_COLOR]$bg[$BG_PROMPT_COLOR]%}%n$reset_color@$fg[$FG_PROMPT_COLOR]$bg[$BG_PROMPT_COLOR]%m$reset_color:$fg[$FG_PROMPT_COLOR]$bg[$BG_PROMPT_COLOR]%~/$reset_color
$ "

# Colorized man prompts.
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# Allow Ctrl-z to toggle between suspend and resume.
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# Save tmux pane.
function SaveTmuxPane {
  if [ "$TERM" != "screen" ] || [ -z "$TMUX" ]; then
    echo "Must run within tmux session to save tmux pane."
    return
  fi

  mkdir -p "$HOME/tmux-panes"
  save_file="$HOME/tmux-panes/$(tmux display-message -p '#W')_$(date +"%Y%m%d-%H%M%S")"
  tmux capture-pane -S -100000
  tmux save-buffer "$save_file"
  echo "Saved buffer to \"$save_file\"."
}
zle -N SaveTmuxPane
bindkey "^P" SaveTmuxPane

# Google-specific configuration.
[[ -f "$HOME/.google.zsh" ]] && source "$HOME/.google.zsh"