zmodload zsh/complist
autoload -Uz compinit

# Full fpath scan and compaudit at most daily; -C reuses the dump.
() {
    local dump=$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
    local -a fresh=($dump(N.mh-24))
    [[ -d ${dump:h} ]] || mkdir -p ${dump:h}
    if (( $#fresh )); then
        compinit -C -d $dump
    else
        compinit -d $dump
    fi
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/compcache
