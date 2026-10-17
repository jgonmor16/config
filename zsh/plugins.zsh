# Distro packages: Ubuntu path first, then Arch. Highlighting loads last.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1   # widgets are all defined above
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
# Default fg=8 is Solarized base03, the background; 10 is base01.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

() {
    local p dir
    for p in zsh-autosuggestions zsh-syntax-highlighting; do
        for dir in /usr/share/$p /usr/share/zsh/plugins/$p; do
            [[ -r $dir/$p.zsh ]] && { source $dir/$p.zsh; break }
        done
    done
}

(( ${+ZSH_HIGHLIGHT_STYLES} )) && ZSH_HIGHLIGHT_STYLES[comment]='fg=10'
