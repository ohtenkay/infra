---@type vim.lsp.Config
return {
  -- TODO: temporary fix for infinite hang when opening a file with fsautocomplete, see https://github.com/neovim/neovim/issues/36257
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  settings = {
    FSharp = {
      ExternalAutocomplete = true,
    },
  },
}
