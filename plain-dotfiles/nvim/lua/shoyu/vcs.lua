require('neogit').setup {}

local gitsigns = require('gitsigns')
gitsigns.setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '┃' },
    untracked    = { text = '┆' },
  },
  attach_to_untracked = true,
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map({ 'n', 'x' }, ']g', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map({ 'n', 'x' }, '[g', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Text object
    map({ 'o', 'x' }, 'ig', ':<C-U>Gitsigns select_hunk<CR>')
    map({ 'o', 'x' }, 'ag', ':<C-U>Gitsigns select_hunk<CR>')

    local Hydra = require('hydra')
    local hint = [[
Git
_s_: stage hunk    _r_: reset hunk    _b_: blame line         _d_: toggle deleted
_S_: stage buffer  _R_: reset buffer  _B_: blame show full    _D_: diff this
_u_: undo stage    _p_: preview hunk  _t_: toggle line blame  _/_: show base file
^
^ ^                _<Enter>_: Neogit  _<Esc>_                 _q_: exit
]]

    Hydra {
      name = 'Git',
      hint = hint,
      config = {
        color = 'pink',
        invoke_on_body = true,
      },
      mode = { 'n', 'x' },
      body = '<Leader>v',
      heads = {
        { 's', gitsigns.stage_hunk,      { silent = true } },
        { 'S', gitsigns.stage_buffer,    { silent = true } },
        { 'u', gitsigns.undo_stage_hunk, { silent = true } },
        { 'r', gitsigns.reset_hunk,      { silent = true } },
        { 'R', gitsigns.reset_buffer,    { silent = true } },
        { 'p', gitsigns.preview_hunk,    { slient = true } },
        { 'b', gitsigns.blame_line,      { silent = true } },
        { 'B',
          function()
            gitsigns.blame_line { full = true }
          end,
          { silent = true },
        },
        { 't',       gitsigns.toggle_current_line_blame, { silent = true } },
        { 'd',       gitsigns.toggle_deleted,            { slient = true, nowait = true } },
        { 'D',       gitsigns.diffthis,                  { silent = true } },
        { '/',       gitsigns.show,                      { exit = true, silent = true } },
        { '<Enter>', '<Cmd>Neogit<CR>',                  { exit = true } },
        { 'q',       nil,                                { exit = true, nowait = true } },
        { '<Esc>',   nil,                                { exit = true, nowait = true } },
      }
    }
  end,
}
