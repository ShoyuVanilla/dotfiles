-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

require('catppuccin').setup {
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.15,
  },
  integrations = {
    gitsigns = true,
    harpoon = true,
    indent_blankline = { enabled = true, colored_indent_levels = true, },
    noice = true,
    notify = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'undercurl' },
        warnings = { 'undercurl' },
        hints = { 'underline' },
        information = { 'underline' },
      },
      inlay_hints = {
        background = true,
      },
    },
    vim_sneak = true,
  },
}
vim.cmd('colorscheme catppuccin-macchiato')

local lualine = require('lualine')

require('hydra').setup {
  hint = {
    show_name = true,
    float_opts = {
      border = 'rounded',
    },
  },
  on_enter = lualine.refresh,
  on_exit = function()
    -- `on_exit` is called **before** the hydra is deactivated.
    -- So, add a short delay for lualine refresh to make it happen after it is deactivated
    local timer = vim.uv.new_timer()
    timer:start(10, 0, vim.schedule_wrap(lualine.refresh))
  end,
}

require('shoyu.options')
require('shoyu.keymaps')
require('shoyu.telescope')
require('shoyu.utilities')
require('shoyu.windows')
require('shoyu.buffers')
require('shoyu.vcs')
require('shoyu.lsp')
require('shoyu.dap')
require('shoyu.ui')
require('shoyu.autocmds')
