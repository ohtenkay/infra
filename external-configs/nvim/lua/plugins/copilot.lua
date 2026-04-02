return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp',
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
    event = 'InsertEnter',
    cmd = 'Copilot',
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<M-L>',
          accept_word = '<M-l>',
        },
      },
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = '<M-L>',
          accept = false,
          dismiss = '<Esc>',
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
  },
}
