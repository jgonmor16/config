# Linked as ~/.zshenv and read by every zsh, so environment only.

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Kept when preset, so the repo copy can be tried in place.
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# Ubuntu's /etc/zsh/zshrc runs its own compinit unless this is set.
skip_global_compinit=1

export EDITOR=nvim VISUAL=nvim

typeset -U path
path=(
    $HOME/.local/bin
    $HOME/.local/opt/vhdl_ls/bin
    $path
    /usr/local/go/bin
    $HOME/go/bin
)
