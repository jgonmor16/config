
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

nv:
	mkdir -p ~/.config/nvim
	ln -sf $(MAKEFILE_DIR)nvim/init.lua ~/.config/nvim/init.lua

clean:
	rm ~/.config/nvim/init.lua
