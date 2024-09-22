local get_hex = require('cokeline.hlgroups').get_hl_attr

local cokeline_default_sort = 'next'

require('cokeline').setup {
  buffers = {
    focus_on_delete = 'prev',
    new_buffers_position = cokeline_default_sort,
    delete_on_right_click = false,
  },

  default_hl = {
    fg = function(buffer)
      return (buffer.is_focused and get_hex('Normal', 'fg'))
          or get_hex('Comment', 'fg')
    end,
    bg = function(buffer)
      return buffer.is_focused and get_hex('Cursorline', 'bg') or nil
    end,
  },

  components = {
    {
      text = ' ',
    },
    {
      text = function(buffer) return buffer.index .. '.' end,
      bold = function(buffer) return buffer.is_focused end,
    },
    {
      text = function(buffer) return ' ' .. buffer.devicon.icon end,
      fg = function(buffer) return buffer.devicon.color end,
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      fg = get_hex('Comment', 'fg'),
      italic = true,
      truncation = {
        priority = 1,
        direction = 'left',
      }
    },
    {
      text = function(buffer) return buffer.filename end,
      fg = function(buffer)
        return (buffer.diagnostics.errors ~= 0 and get_hex('DiagnosticError', 'fg'))
            or (buffer.diagnostics.warnings ~= 0 and get_hex('DiagnosticWarn', 'fg'))
            or nil
      end,
      undercurl = function(buffer)
        return buffer.diagnostics.errors ~= 0 or buffer.diagnostics.warnings ~= 0
      end,
      bold = function(buffer) return buffer.is_focused end,
      truncation = {
        priority = 2,
      }
    },
    {
      text = function(buffer)
        if buffer.is_readonly then
          return ' 󰌾'
        elseif buffer.is_modified then
          return ' ●'
        else
          local status = vim.b[buffer.number].gitsigns_status
          if status == nil or status == '' then
            return '  '
          else
            return ' '
          end
        end
      end,
      fg = function(buffer) return not buffer.is_readonly and get_hex('diffAdded', 'fg') end,
    },
    {
      text = ' '
    },
  },
}

local map = vim.keymap.set
local bufdelete = require('bufdelete')
local coke_buffers = require('cokeline.buffers')
local coke_history = require('cokeline.history')
local coke_config = require('cokeline.config')
local coke_mappings = require('cokeline.mappings')

local function focus_buffer_at(index)
  local bufs = coke_buffers.get_visible()
  if bufs then bufs[math.min(index, #bufs)]:focus() end
end

local function focus_history_prev_buffer()
  local buf = coke_history:last()
  if buf then buf:focus() end
end

local function bd(bufnr, force)
  bufdelete.bufdelete(bufnr, force)
end

local function bd_direction(right, force)
  local curr = coke_buffers.get_current()
  if not curr or not curr:is_valid() then return end

  local bufs = coke_buffers.get_visible()
  if not bufs or #bufs == 0 then return end

  local curr_met = false

  for _, buf in ipairs(bufs) do
    if buf.number == curr.number then
      curr_met = true
    elseif curr_met == right then
      bd(buf.number, force)
    end
  end
end

local function buffer_only(force)
  local curr = coke_buffers.get_current()
  if not curr then return end

  local bufs = coke_buffers.get_visible()
  if not bufs or #bufs == 0 then return end

  for _, buf in ipairs(bufs) do
    if buf.number ~= curr.number then
      bd(buf.number, force)
    end
  end
end

local function diff_count(bufnr)
  local status_dict = vim.b[bufnr].gitsigns_status_dict
  if not status_dict then return 0 end
  return status_dict.added + status_dict.changed + status_dict.removed
end

local function buffer_prune()
  local bufs = coke_buffers.get_visible()
  if not bufs or #bufs == 0 then return end

  for _, buf in ipairs(bufs) do
    if not buf.is_modified then
      if diff_count(buf.number) == 0 then
        bd(buf.number, false)
      end
    end
  end
end

local function sort_by_changes(a, b)
  if a.is_modified ~= b.is_modified then
    return a.is_modified
  elseif not a.is_modified then
    local diff_a = diff_count(a.number)
    local diff_b = diff_count(b.number)
    if diff_a ~= diff_b then return diff_a > diff_b end
  end
  return a.number < b.number
end

local function invoke_sort_by_changes()
  coke_config.buffers.new_buffers_position = sort_by_changes
  vim.cmd.redrawtabline()
  coke_config.buffers.new_buffers_position = cokeline_default_sort
end

-- -- If no cokeline...
-- map(
--   'n',
--   '<S-h>',
--   function() return '<Cmd>bprevious ' .. vim.v.count1 .. '<CR>' end,
--   { expr = true, silent = true }
-- )
-- map(
--   'n',
--   '<S-l>',
--   function() return '<Cmd>bnext ' .. vim.v.count1 .. '<CR>' end,
--   { expr = true, silent = true }
-- )

map(
  'n',
  '<S-h>',
  function() coke_mappings.by_step('focus', -vim.v.count1) end
)
map(
  'n',
  '<S-l>',
  function() coke_mappings.by_step('focus', vim.v.count1) end
)

map(
  'n',
  '<Tab>',
  function()
    if vim.v.count > 0 then
      focus_buffer_at(vim.v.count)
    else
      focus_history_prev_buffer()
    end
  end
)

local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
_d_: buffer delete                 _D_: buffer delete!
_xh_: buffer delete left          _Xh_: buffer delete left!
_xl_: buffer delete right         _Xl_: buffer delete right!
_o_: buffer only                  _O_: buffer only!
_p_: delete buffers without diff  ^ ^
^
_s_: sort buffers by changes      ^ ^
_f_: list buffers                 ^ ^
^
_<Esc>_                           _q_: Exit
]]

Hydra {
  name = 'Buffer',
  hint = hint,
  config = {
    color = 'teal',
    invoke_on_body = true,
  },
  mode = 'n',
  body = '<Leader>b',
  heads = {
    { 'd',     function() bd(0, false) end },
    { 'D',     function() bd(0, true) end },
    { 'o',     function() buffer_only(false) end },
    { 'O',     function() buffer_only(true) end },
    { 'xh',    function() bd_direction(false, false) end },
    { 'Xh',    function() bd_direction(false, true) end },
    { 'xl',    function() bd_direction(true, false) end },
    { 'Xl',    function() bd_direction(true, true) end },
    { 'p',     buffer_prune },

    { 's',     invoke_sort_by_changes },

    { 'f',     cmd 'Telescope buffers' },

    { '<Esc>', nil,                                      { exit = true, nowait = true } },
    { 'q',     nil,                                      { exit = true, nowait = true } },
  },
}
