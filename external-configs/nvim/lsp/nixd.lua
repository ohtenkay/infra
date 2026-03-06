---@type vim.lsp.Config

-- Hardcoded path to the NixOS flake. All nixd expressions reference this
-- so that completion works regardless of which directory neovim is opened from.
local flake = '/home/ondrej/infra'

return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = ('import (builtins.getFlake "%s").inputs.nixpkgs {}'):format(flake),
      },
      formatting = {
        command = { 'nixfmt' },
      },
      options = {
        nixos = {
          expr = ('(builtins.getFlake "%s").nixosConfigurations.nixblade.options'):format(flake),
        },
        home_manager = {
          expr = ('(builtins.getFlake "%s").nixosConfigurations.nixblade.options.home-manager.users.type.getSubOptions []'):format(
            flake
          ),
        },
      },
    },
  },
}
