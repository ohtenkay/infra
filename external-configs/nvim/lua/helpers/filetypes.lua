local M = {}

function M.determine_helm_template_filetype(path)
  local chart_file = vim.fs.find('Chart.yaml', {
    path = vim.fs.dirname(path),
    upward = true,
  })[1]

  if not chart_file then
    return nil
  end

  local chart_root = vim.fs.dirname(chart_file)
  local templates_prefix = chart_root .. '/templates/'

  if path:find('^' .. vim.pesc(templates_prefix)) then
    return 'helm'
  end

  return nil
end

return M
