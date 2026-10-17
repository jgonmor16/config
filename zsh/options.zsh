HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=50000
SAVEHIST=50000
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

setopt extended_history       # timestamps; same format as oh-my-zsh
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify

# oh-my-zsh set this; ls and completion colors read it.
[[ -z $LS_COLORS ]] && (( $+commands[dircolors] )) && eval "$(dircolors -b)"

setopt auto_cd
setopt auto_pushd pushd_ignore_dups pushd_silent
setopt interactive_comments
setopt no_beep
