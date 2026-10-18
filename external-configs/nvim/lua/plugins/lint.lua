return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    linters_by_ft = {
      -- Use the "*" filetype to run linters on all filetypes, e.g. spellchecker
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured, e.g. strip whitespace
      -- ['_'] = { 'fallback linter' },
      -- lua = { 'luacheck' },
      haskell = { 'hlint' },
      lhaskell = { 'hlint' },
    },
  },
  config = function(_, opts)
    local lint = require 'lint'
    lint.linters_by_ft = opts.linters_by_ft

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set('n', '<leader>ll', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
