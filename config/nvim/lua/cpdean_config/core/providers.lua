-- python host providers, migrated from backup.init.vim (gradual-refactor phase 1).
--
-- setup notes (macos):
--   python3 -m venv ~/.virtualenvs/neovim
--   source ~/.virtualenvs/neovim/bin/activate
--   python -m pip install neovim flake8 black
--
-- paths are kept verbatim, including the literal '$HOME' (vimscript single
-- quotes never expanded it, so this preserves the original behavior). the
-- python2 host is a no-op on modern neovim.
vim.g.python_host_prog = '$HOME/.virtualenvs/neovimpy2/bin/python'
vim.g.python3_host_prog = '$HOME/.virtualenvs/neovim/bin/python'
