-- Hardcoded path to the NixOS flake. All nixd expressions reference this
-- so that completion works regardless of which directory neovim is opened from.
local flake = '/home/ondrej/infra'

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    on_dir(
      vim.fs.root(bufnr, 'devenv.nix')
        or vim.fs.root(bufnr, { 'flake.nix', '.git' })
        or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    )
  end,
  cmd = function(dispatchers, config)
    local cmd = { 'nixd' }
    if vim.uv.fs_stat(config.root_dir .. '/devenv.nix') then
      local result = vim
        .system({ 'devenv', 'lsp', '--print-config' }, { cwd = config.root_dir, text = true })
        :wait(30000)
      assert(result.code == 0, 'devenv LSP configuration failed: ' .. (result.stderr or ''))
      local settings = vim.json.decode(result.stdout)
      settings.nixd.formatting = config.settings.nixd.formatting
      config.settings.nixd = settings.nixd
      cmd = { 'devenv', 'lsp' }
    end
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
  end,
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
