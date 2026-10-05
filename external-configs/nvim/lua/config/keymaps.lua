local set = vim.keymap.set

-- Clear hlsearch on pressing <Esc> in normal mode
set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Center the cursor when scrolling files
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')

-- Show diagnostic messages in a floating window
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- Go to definition, this is a fallback if Snacks.picker is not working
set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to [D]efinition' })

-- Show hover documentation with a border
set('n', 'K', function()
  vim.lsp.buf.hover { border = 'rounded' }
end, { desc = 'Hover Documentation with rounded border' })

-- Yank the current filename to the system clipboard
vim.keymap.set('n', '<leader>yf', function()
  vim.fn.setreg('+', vim.fn.expand '%')
end, { desc = 'Yank filename' })
