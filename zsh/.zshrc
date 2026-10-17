# Interactive setup. Order matters: plugins.zsh, once added, goes last.
for _mod in options completion keybinds prompt aliases plugins; do
    source $ZDOTDIR/$_mod.zsh
done
unset _mod
