-- Status line
local lualine = require('lualine')

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local Harpoonline = require('harpoonline')
Harpoonline.setup {
  on_update = function() lualine.refresh() end,
}

local hydra_statusline = require('hydra.statusline')

local hydra_colors = {
  ['red'] = '#ff5733',
  ['blue'] = '#5ebcf6',
  ['amaranth'] = '#ff1757',
  ['teal'] = '#00a1a1',
  ['pink'] = '#ff55de',
}

lualine.setup {
  options = {
    component_separators = '',
    section_separators = '',
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(res)
          local hydra_active = hydra_statusline.is_active()
          local mode = hydra_active
              and '󰖌 ' .. hydra_statusline.get_name()
              or ' ' .. res
          -- lualine mode showing weird behaviour that
          -- being rendered with shorter length by one on hydra names.
          -- I don't know why but simply applying one more length for them
          local len = hydra_active and 14 or 13
          local pad = len - #mode
          return mode .. string.rep('', pad)
        end,
        color = function(_)
          if hydra_statusline.is_active() then
            local color = hydra_statusline.get_color()
            return { bg = hydra_colors[color], gui = 'bold' }
          else
            return { gui = 'bold' }
          end
        end
      }
    },
    lualine_b = {
      { 'b:gitsigns_head', icon = '' },
      {
        'diagnostics',
        sources = { 'nvim_workspace_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      },
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      },
      { 'diff', source = diff_source },
      Harpoonline.format,
    },
    lualine_x = {
      'encoding',
      {
        'fileformat',
        icons_enabled = true,
        symbols = {
          unix = ' LF',
          dos = ' CRLF',
          mac = ' CR',
        },
      },
      'filetype'
    },
  },
  extensions = { 'nvim-dap-ui', 'fugitive', 'oil' }
}

local helpers = require('incline.helpers')
local devicons = require('nvim-web-devicons')

require('incline').setup {
  window = {
    padding = 0,
    margin = { horizontal = 0, vertical = 0 },
  },
  render = function(props)
    local function get_diagnostic_label()
      local order = { 'error', 'warn', 'info', 'hint' }
      local icons = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
      local label = {}

      for i = 1, #order do
        local severity = order[i]
        local n = #vim.diagnostic.get(
          props.buf,
          { severity = vim.diagnostic.severity[string.upper(severity)] }
        )
        if n > 0 then
          table.insert(label, { icons[severity] .. n .. ' ', group = 'DiagnosticSign' .. severity })
        end
      end
      if #label > 0 then
        table.insert(label, { ' ' })
      end
      return label
    end

    local function get_git_diff()
      local order = { 'added', 'changed', 'removed' }
      local icons = { added = '+', changed = '~', removed = '-' }
      local groups = {
        added = 'GitSignsAdd',
        changed = 'GitSignsChange',
        removed = 'GitSignsDelete',
      }
      local signs = vim.b[props.buf].gitsigns_status_dict
      local labels = {}
      if signs == nil then
        return labels
      end
      for i = 1, #order do
        local diff = order[i]
        if tonumber(signs[diff]) and signs[diff] > 0 then
          table.insert(labels, { icons[diff] .. signs[diff] .. ' ', group = groups[diff] })
        end
      end
      if #labels > 0 then
        table.insert(labels, { ' ' })
      end
      return labels
    end

    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
    if filename == '' then
      filename = '[No Name]'
    end
    local ft_icon, ft_color = devicons.get_icon_color(filename)

    local res = {
      ft_icon and {
        ' ',
        ft_icon,
        ' ',
        guibg = ft_color,
        guifg = helpers.contrast_color(ft_color) or '',
      } or '',
      { ' ' .. filename .. '  ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
      { get_diagnostic_label() },
      { get_git_diff() },
      { ' ' .. vim.api.nvim_win_get_number(props.win) .. ' ', group = 'DevIconWindows' },
    }

    return res
  end,
}

-- Status colomn
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  -- virtual_text = {
  --     prefix = '󰏩',
  -- },
  virtual_text = false,
}

local ns = vim.api.nvim_create_namespace('SingleDiagSign')
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diags = vim.diagnostic.get(bufnr)
    local max_severity_per_line = {}
    for _, d in pairs(diags) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    local filtered_diags = vim.tbl_values(max_severity_per_line)
    orig_signs_handler.show(ns, bufnr, filtered_diags, opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end
}

local builtin = require('statuscol.builtin')
require('statuscol').setup {
  relculright = true,
  segments = {
    {
      sign = {
        name = { '.*' },
        text = { '.*' },
        maxwidth = 1,
        colwidth = 1,
        auto = false,
        wrap = false,
        fillchar = ' ',
      },
    },
    { text = { ' ' } },
    {
      sign = {
        namespace = { 'SingleDiagSign' },
        text = { '.*' },
        maxwidth = 1,
        colwidth = 1,
        auto = false,
        wrap = false,
        fillchar = ' ',
      },
    },
    { text = { ' ' } },
    { text = { builtin.lnumfunc } },
    {
      sign = {
        namespace = { 'gitsign' },
        maxwidth = 1,
        colwidth = 1,
        auto = false,
        wrap = true,
        fillchar = ' ',
        fillcharhl = 'StatusColumnSeparator',
      },
    },
  },
}

-- Indentations guides
require('ibl').setup()
local indentscope = require('mini.indentscope')
indentscope.setup {
  draw = { delay = 0, animation = indentscope.gen_animation.none() },
}

-- Noice
require('notify').setup {
  stages = 'static',
}

require('noice').setup {
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
      ["vim.lsp.util.stylize_markdown"] = false,
      ["cmp.entry.get_documentation"] = false,
    },
  },
}
