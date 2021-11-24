-----------------------------
-- Language servers config --
-----------------------------

-- Optional --

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { }
--for _, lsp in ipairs(servers) do
--  nvim_lsp[lsp].setup {
--    on_attach = on_attach,
--    flags = {
--      debounce_text_changes = 150,
--    }
--  }
--end

-- hdl_checker --

if not nvim_lsp.hdl_checker then
  require"lspconfig/configs".hdl_checker = {
    default_config = {
    cmd = {"hdl_checker", "--lsp", };
    filetypes = {"vhdl", "verilog", "systemverilog"};
      root_dir = function(fname)
        -- will look for a parent directory with a .git directory. If none, just
        -- use the current directory
        return nvim_lsp.util.find_git_ancestor(fname) or nvim_lsp.util.path.dirname(fname)
        -- or (not both)
        -- Will look for the .hdl_checker.config file in a parent directory. If
        -- none, will use the current directory
        --return nvim_lsp.util.root_pattern(".hdl_checker.config")(fname) or nvim_lsp.util.path.dirname(fname)
      end;
      settings = {};
    };
  }
end

nvim_lsp.hdl_checker.setup{}
