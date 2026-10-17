bindkey -v
KEYTIMEOUT=1    # 10 ms: <Esc> enters normal mode without the default 0.4 s lag

# Insert mode keeps the emacs keys, so normal mode is opt-in while learning.
# vi-backward-* stop at the point where insert started; these don't.
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
setopt no_flow_control  # free ^S from XOFF

# Up/Down and ^P/^N search history by the typed prefix, as oh-my-zsh did.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for _km in viins vicmd; do
    for _seq in '^[[A' '^[OA' ${terminfo[kcuu1]}; do
        bindkey -M $_km $_seq up-line-or-beginning-search
    done
    for _seq in '^[[B' '^[OB' ${terminfo[kcud1]}; do
        bindkey -M $_km $_seq down-line-or-beginning-search
    done
done
bindkey -M viins '^P' up-line-or-beginning-search
bindkey -M viins '^N' down-line-or-beginning-search

# ^X^E: edit the command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

# Text objects: ci" da( yib ...
autoload -Uz select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted
for _km in visual viopp; do
    for _seq in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $_km $_seq select-bracketed
    done
    for _seq in {a,i}{\',\",\`}; do
        bindkey -M $_km $_seq select-quoted
    done
done
unset _km _seq

# Cursor shape shows the mode: beam in insert, block in normal.
# These replace Ubuntu's zle-line-{init,finish}, so keep its keypad mode.
_cursor_for_keymap() {
    [[ $KEYMAP == vicmd ]] && print -n '\e[2 q' || print -n '\e[6 q'
}
zle-line-init() {
    (( ${+terminfo[smkx]} )) && echoti smkx
    zle -K viins
    _cursor_for_keymap
}
zle-line-finish() {
    (( ${+terminfo[rmkx]} )) && echoti rmkx
    print -n '\e[2 q'
}
zle-keymap-select() { _cursor_for_keymap }
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
