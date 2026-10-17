# robbyrussell layout, terminal palette colors: ➜ dir git:(branch) ✗
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗'
zstyle ':vcs_info:git:*' stagedstr ' %F{green}+'
zstyle ':vcs_info:git:*' formats \
    ' %F{blue}git:(%F{red}%b%F{blue})%u%c%f'
zstyle ':vcs_info:git:*' actionformats \
    ' %F{blue}git:(%F{red}%b%F{blue}|%F{magenta}%a%F{blue})%u%c%f'

# Built in precmd, not via prompt_subst, so branch names are never
# evaluated as code.
_prompt_precmd() {
    vcs_info
    PROMPT="%B%(?.%F{green}.%F{red})➜%f%b %F{cyan}%1~%f${vcs_info_msg_0_} "
}
add-zsh-hook precmd _prompt_precmd
