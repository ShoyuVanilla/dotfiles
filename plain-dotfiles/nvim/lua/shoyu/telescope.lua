local telescope = require('telescope')
local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

telescope.setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor {
      }
    },
    undo = {
      use_delta = true,
    },
  }
}

telescope.load_extension('ui-select')

require('todo-comments').setup {}

local hint = [[
Quick Search

_f_: files           _g_: git files
_h_: old files       ^ ^
^
_b_: buffers         _u_: undo
_U_: undotree
_m_: marks           _j_: jumplists
_r_: registers       _t_: todos
^
_/_: live grep       _?_: current buffer fuzzy
^
_c_: commands        _C_: command history
_o_: options         _k_: keymaps
^
_n_: notice          ^ ^
^
_<Enter>_: Telescope ^ ^
^
_<Esc>_              _q_: Exit
]]

Hydra {
  name = 'Telescope',
  hint = hint,
  config = {
    color = 'teal',
    invoke_on_body = true,
    hint = {
      position = 'middle',
    },
  },
  mode = 'n',
  body = '<Leader>f',
  heads = {
    { 'f',       cmd 'Telescope find_files' },
    { 'g',       cmd 'Telescope git_files',                { silent = true } },
    { 'h',       cmd 'Telescope oldfiles' },

    { 'b',       cmd 'Telescope buffers' },
    { 'u',       cmd 'Telescope undo' },
    { 'U',       cmd 'silent! %foldopen! | UndotreeToggle' },
    { 'm',       cmd 'Telescope marks' },
    { 'j',       cmd 'Telescope jumplists' },
    { 'r',       cmd 'Telescope registers' },
    { 't',       cmd 'TodoTelescope' },

    { 'c',       cmd 'Telescope commands' },
    { 'C',       cmd 'Telescope command_history' },
    { 'o',       cmd 'Telescope vim_options' },
    { 'k',       cmd 'Telescope keymaps' },

    { '/',       cmd 'Telescope live_grep' },
    { '?',       cmd 'Telescope current_buffer_fuzzy_find' },

    { 'n',       cmd 'NoiceTelescope' },

    { '<Enter>', cmd 'Telescope',                          { exit = true } },
    { '<Esc>',   nil,                                      { exit = true, nowait = true } },
    { 'q',       nil,                                      { exit = true, nowait = true } },
  }
}
