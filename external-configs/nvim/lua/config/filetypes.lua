local filetype_helpers = require 'helpers.filetypes'

vim.filetype.add {
  pattern = {
    ['.*/templates/.*%.ya?ml'] = filetype_helpers.determine_helm_template_filetype,
    ['.*/templates/.*%.tpl'] = filetype_helpers.determine_helm_template_filetype,
  },
}
