---@type vim.lsp.Config
return {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        features = 'all',
      },
      check = {
        features = 'all',
        command = 'clippy',
        allTargets = true,
        extraArgs = {
          '--',
          '-W',
          'clippy::pedantic',
        },
      },
      diagnostics = {
        styleLints = { enable = true },
      },
    },
  },
}
