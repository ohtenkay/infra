local lombok_helper = require 'helpers.lombok'

local lombok_jar = lombok_helper.get_latest_lombok()
local cmd = { 'jdtls' }

if lombok_jar then
  table.insert(cmd, '--jvm-arg=-javaagent:' .. lombok_jar)
else
  vim.notify('Could not find any Lombok JAR in /nix/store', vim.log.levels.ERROR)
end

---@type vim.lsp.Config
return {
  cmd = cmd,
}
