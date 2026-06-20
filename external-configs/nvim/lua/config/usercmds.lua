vim.api.nvim_create_user_command('Gitbrowse', function()
  require('snacks').gitbrowse()
end, { nargs = 0 })

vim.api.nvim_create_user_command('Fr', function()
  vim.cmd 'FlutterRun'
end, {})

vim.api.nvim_create_user_command('Flt', function()
  vim.cmd 'FlutterLogToggle'
end, {})
