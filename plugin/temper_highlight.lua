local group = vim.api.nvim_create_augroup("TemperHighlight", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
  group = group,
  pattern = { "*.temper", "*.temper.md" },
  callback = function(ev)
    require("temper_highlight").highlight_buffer(ev.buf)
  end,
})
