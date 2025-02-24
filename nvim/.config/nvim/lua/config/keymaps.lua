-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "gv", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { noremap = true, silent = true, desc = "Open definition in vertical split" })
