# robbyrussell style, bold except markers: ➜ [user] repo/sub git:(branch) ✗ + ?
# Outside a repo the path is %~: relative to ~ when under it, else absolute.
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %b%F{yellow}✗'
zstyle ':vcs_info:git:*' stagedstr ' %b%F{green}+'
# Second message: path from the repo root, e.g. config/. or config/zsh.
zstyle ':vcs_info:git:*' formats \
    ' %F{blue}git:(%F{red}%b%F{blue})%u%c%m%f' '%r/%S'
zstyle ':vcs_info:git:*' actionformats \
    ' %F{blue}git:(%F{red}%b%F{blue}|%F{magenta}%a%F{blue})%u%c%m%f' '%r/%S'

# Untracked files, as in `git status -s`. --directory stops at the first
# untracked dir instead of walking it.
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked() {
    [[ -n $(git -C ${hook_com[base]} ls-files --others --exclude-standard \
        --directory --no-empty-directory 2>/dev/null) ]] &&
        hook_com[misc]=' %b%F{yellow}?'
}

# Built in precmd, not via prompt_subst, so branch names are never
# evaluated as code.
_prompt_precmd() {
    vcs_info
    local dir='%~'
    if [[ -n $vcs_info_msg_1_ ]]; then
        dir=${vcs_info_msg_1_%/.}
        dir=${dir//\%/%%}
    fi
    PROMPT="%B%(?.%F{green}.%F{red})➜ %F{magenta}[%n] %F{cyan}$dir%f${vcs_info_msg_0_}%b "
}
add-zsh-hook precmd _prompt_precmd
