-- iceberg.vim has no setup(); strip its backgrounds when it is activated.
local function transparent()
  for _, g in ipairs({
    "Normal", "NormalNC", "NormalFloat", "FloatBorder",
    "SignColumn", "EndOfBuffer", "LineNr", "FoldColumn",
    "CursorLineNr", "VertSplit", "WinSeparator",
  }) do
    vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "none" })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "iceberg",
  callback = transparent,
})
