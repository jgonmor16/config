
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: nv clean check

nv:
	mkdir -p ~/.config/nvim
	ln -sf $(MAKEFILE_DIR)nvim/init.lua ~/.config/nvim/init.lua
	ln -sfn $(MAKEFILE_DIR)nvim/lua ~/.config/nvim/lua

clean:
	rm ~/.config/nvim/init.lua
	rm -f ~/.config/nvim/lua
	rm -f ~/.config/nvim/plugin

check:
	nvim --headless -c 'qa'
