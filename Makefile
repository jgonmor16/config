MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: nv zsh clean check

nv:
	mkdir -p ~/.config/nvim
	ln -sf $(MAKEFILE_DIR)nvim/init.lua ~/.config/nvim/init.lua
	ln -sfn $(MAKEFILE_DIR)nvim/lua ~/.config/nvim/lua

# ln -sfn would nest the link inside a real directory.
zsh:
	@test ! -e ~/.config/zsh -o -L ~/.config/zsh || \
		{ echo "~/.config/zsh is a real directory; move it first"; exit 1; }
	mkdir -p ~/.config
	ln -sfn $(MAKEFILE_DIR)zsh ~/.config/zsh
	ln -sf $(MAKEFILE_DIR)zsh/.zshenv ~/.zshenv

clean:
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/nvim/lua
	rm -f ~/.config/nvim/plugin
	rm -f ~/.zshenv ~/.config/zsh

check:
	nvim --headless -c 'qa'
	for f in $(MAKEFILE_DIR)zsh/.zsh* $(MAKEFILE_DIR)zsh/*.zsh; do \
		zsh -n $$f || exit 1; \
	done
