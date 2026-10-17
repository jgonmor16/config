# robbyrussell style, all bold: ➜ [user]~/path git:(branch) ✗ + ?
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗'
zstyle ':vcs_info:git:*' stagedstr ' %F{green}+'
zstyle ':vcs_info:git:*' formats \
    ' %F{blue}git:(%F{red}%b%F{blue})%u%c%m%f'
zstyle ':vcs_info:git:*' actionformats \
    ' %F{blue}git:(%F{red}%b%F{blue}|%F{magenta}%a%F{blue})%u%c%m%f'

# Untracked files, as in `git status -s`. --directory stops at the first
# untracked dir instead of walking it.
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked() {
    [[ -n $(git -C ${hook_com[base]} ls-files --others --exclude-standard \
        --directory --no-empty-directory 2>/dev/null) ]] &&
        hook_com[misc]=' %F{yellow}?'
}

# Built in precmd, not via prompt_subst, so branch names are never
# evaluated as code.
_prompt_precmd() {
    vcs_info
    PROMPT="%B%(?.%F{green}.%F{red})➜ %F{magenta}[%n]%F{cyan}%~%f${vcs_info_msg_0_}%b "
}
add-zsh-hook precmd _prompt_precmd
