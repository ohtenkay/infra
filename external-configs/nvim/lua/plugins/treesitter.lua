return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      vim.cmd [[hi TreesitterContext guibg=NONE ctermbg=NONE]]
      vim.cmd [[hi TreesitterContextLineNumberBottom gui=underline guisp=Grey]]
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'master', -- TODO: switch to main after treesitter 1.0
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'query',
        'html',
        'latex',
        'yaml',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      if vim.fn.has 'nvim-0.12' == 1 then
        local query = vim.treesitter.query
        local info_string_aliases = {
          ex = 'elixir',
          pl = 'perl',
          sh = 'bash',
          ts = 'typescript',
          uxn = 'uxntal',
        }
        local script_mime_languages = {
          importmap = 'json',
          module = 'javascript',
          ['application/ecmascript'] = 'javascript',
          ['text/ecmascript'] = 'javascript',
        }

        local function capture_node(match, id)
          local node = match[id]
          if type(node) == 'table' then
            return node[#node]
          end
          return node
        end

        query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
          local node = capture_node(match, pred[2])
          if not node then
            return
          end
          local value = vim.treesitter.get_node_text(node, bufnr)
          local configured = script_mime_languages[value]
          if configured then
            metadata['injection.language'] = configured
            return
          end
          local parts = vim.split(value, '/', {})
          metadata['injection.language'] = parts[#parts]
        end, { force = true })

        query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
          local node = capture_node(match, pred[2])
          if not node then
            return
          end
          local alias = vim.treesitter.get_node_text(node, bufnr):lower()
          local detected = vim.filetype.match { filename = 'a.' .. alias }
          metadata['injection.language'] = detected or info_string_aliases[alias] or alias
        end, { force = true })

        query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
          local id = pred[2]
          local node = capture_node(match, id)
          if not node then
            return
          end
          local node_meta = metadata[id] or {}
          local text = vim.treesitter.get_node_text(node, bufnr, { metadata = node_meta }) or ''
          node_meta.text = string.lower(text)
          metadata[id] = node_meta
        end, { force = true })
      end

      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
