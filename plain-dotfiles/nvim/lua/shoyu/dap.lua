local dap = require('dap')
local sign = vim.fn.sign_define

sign('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
sign('DapBreakpointCondition', { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
sign('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
sign('DapStopped', { text = '󰜴', texthl = 'DapStopped', linehl = '', numhl = '' })
sign('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7',
}

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode',
  name = 'lldb'
}

local function trim_whitespaces(str)
  return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

local rust_cached_executable = nil

local function set_codelldb()
  local handle = io.popen('$SHELL -c "realpath `which codelldb`"')
  if not handle then return end

  local result = handle:read('*a')
  handle:close()
  if not result then return end

  local codelldb = trim_whitespaces(result)
  if codelldb == '' then return end

  dap.adapters.codelldb = {
    type = 'server',
    port = 13000,
    executable = {
      command = codelldb,
      args = { '--port', 13000 },
    }
  }

  dap.configurations.rust = {
    {
      name = 'Launch',
      type = 'codelldb',
      request = 'launch',
      program = function()
        local placeholder = rust_cached_executable or vim.fn.getcwd() .. '/target/debug/'
        local executable = vim.fn.input('Path to executable: ', placeholder, 'file')
        if not executable or executable == '' then return end
        rust_cached_executable = executable
        return executable
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      stopAtBeginningOfMainSubprogram = false,
    },
  }
end

set_codelldb()

require('nvim-dap-virtual-text').setup {
  commented = true,
}

require('telescope').load_extension('dap')

local dapui = require('dapui')

dapui.setup {
  controls = { enabled = false },
}

local notify = require('notify')
local notify_options = {
  title = 'Debugger',
}
dap.listeners.after.attach.dapui_config = function()
  notify('A debugging session has been attached to a running process', 'info', notify_options)
  dapui.open()
end
dap.listeners.after.launch.dapui_config = function()
  notify('A debugging session has launched', 'info', notify_options)
  dapui.open()
end
dap.listeners.after.event_terminated.dapui_config = function()
  notify('A debugging session has been terminated', 'info', notify_options)
  dapui.close()
end
dap.listeners.after.event_exited.dapui_config = function()
  notify('A debugging session has exited', 'info', notify_options)
  dapui.close()
end

local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local function set_breakpoint()
  vim.ui.input(
    { prompt = 'Condition: ' },
    function(condition)
      if not condition then return end
      vim.ui.input(
        { prompt = 'Hit condition, `(>|>=|=|<|<=|%)?\\s*([0-9]+)`: ' },
        function(hit_condition)
          if not hit_condition then return end
          vim.ui.input(
            { prompt = 'Log message: ' },
            function(log_message)
              if not log_message then return end
              dap.set_breakpoint(
                trim_whitespaces(condition),
                trim_whitespaces(hit_condition),
                trim_whitespaces(log_message)
              )
            end
          )
        end
      )
    end
  )
end

local hint = [[
Debugger
_d_: continue   _b_: toggle breakpoint  _;_: step over  _r_: restart session  _c_: list commands
_x_: terminate  _B_: set breakpoint     _i_: step into  _R_: run last         _C_: list configs
_u_: toggle ui  _l_: list breakpoints   _o_: step out   _v_: list variables   ^ ^
^ ^             _X_: clear breakpoints  ^ ^             _a_: list frames      ^ ^
^
^ ^             ^ ^                     ^ ^             _<Esc>_               _q_: close
]]

Hydra {
  name = 'Debugger',
  hint = hint,
  config = {
    color = 'pink',
    invoke_on_body = true,
  },
  mode = 'n',
  body = '<Leader>g',
  heads = {
    { 'd',     cmd 'DapContinue' },
    { 'x',     cmd 'DapTerminate',                  { exit = true, nowait = true } },
    { 'u',     dapui.toggle },
    { 'b',     cmd 'DapToggleBreakpoint' },
    { 'B',     set_breakpoint },
    { 'l',     cmd 'Telescope dap list_breakpoints' },
    { 'X',     dap.clear_breakpoints },
    { ';',     cmd 'DapStepOver' },
    { 'i',     cmd 'DapStepInto' },
    { 'o',     cmd 'DapStepOut' },
    { 'r',     dap.restart },
    { 'R',     dap.run_last },

    { 'v',     cmd 'Telescope dap variables' },
    { 'a',     cmd 'Telescope dap frames' },
    { 'c',     cmd 'Telescope dap commands' },
    { 'C',     cmd 'Telescope dap configurations' },
    { 'q',     nil,                                 { exit = true, nowait = true } },
    { '<Esc>', nil,                                 { exit = true, nowait = true } },
  }
}

-- -- Not available on macOS
-- local rr_dap = require("nvim-dap-rr")
-- rr_dap.setup {}
