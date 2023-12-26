local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { 'pwsh', '-l' }
config.window_decorations = 'RESIZE'
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.window_close_confirmation = 'NeverPrompt'
config.color_scheme = 'Gruvbox Material (Gogh)'
config.window_background_opacity = 0.8

-- Maximize on launch
wezterm.on('gui-attached', function(domain)
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

wezterm.on('split-pane-auto', function(window, pane)
  local dimensions = pane:get_dimensions()
  if dimensions.cols > dimensions.viewport_rows then
    pane:split { direction = 'Right' }
  else
    pane:split { direction = 'Bottom' }
  end
end)

config.keys = {
  {
    key = 'a',
    mods = 'CTRL',
    action = act.Multiple {
      act.ActivateKeyTable {
        name = 'prefix_mode',
        one_shot = false,
        prevent_fallback = true,
      },
    },
  },
}

config.key_tables = {
  prefix_mode = {
    {
      key = 'h',
      action = act.ActivatePaneDirection 'Left',
    },
    {
      key = 'j',
      action = act.ActivatePaneDirection 'Down',
    },
    {
      key = 'k',
      action = act.ActivatePaneDirection 'Up',
    },
    {
      key = 'l',
      action = act.ActivatePaneDirection 'Right',
    },

    {
      key = 'h',
      mods = 'SHIFT',
      action = act.ActivateTabRelative(-1),
    },
    {
      key = 'l',
      mods = 'SHIFT',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'Tab',
      action = act.ActivateLastTab,
    },

    {
      key = 'j',
      mods = 'CTRL',
      action = act.ScrollByLine(1),
    },
    {
      key = 'k',
      mods = 'CTRL',
      action = act.ScrollByLine(-1),
    },
    {
      key = 'f',
      mods = 'CTRL',
      action = act.ScrollByPage(1),
    },
    {
      key = 'b',
      mods = 'CTRL',
      action = act.ScrollByPage(-1),
    },
    {
      key = 'd',
      mods = 'CTRL',
      action = act.ScrollByPage(0.5),
    },
    {
      key = 'u',
      mods = 'CTRL',
      action = act.ScrollByPage(-0.5),
    },
    {
      key = 'g',
      mods = 'SHIFT',
      action = act.ScrollToBottom,
    },

    {
      key = 'h',
      mods = 'ALT',
      action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
      key = 'k',
      mods = 'ALT',
      action = act.AdjustPaneSize { 'Up', 1 },
    },
    {
      key = 'j',
      mods = 'ALT',
      action = act.AdjustPaneSize { 'Down', 1 },
    },
    {
      key = 'l',
      mods = 'ALT',
      action = act.AdjustPaneSize { 'Right', 1 },
    },

    {
      key = 'z',
      mods = 'CTRL',
      action = act.TogglePaneZoomState,
    },

    {
      key = 'n',
      action = act.EmitEvent 'split-pane-auto',
    },
    {
      key = 'n',
      mods = 'SHIFT',
      action = act.SpawnTab 'CurrentPaneDomain',
    },

    {
      key = 'x',
      action = act.CloseCurrentPane { confirm = false },
    },
    {
      key = 'x',
      mods = 'SHIFT',
      action = act.CloseCurrentTab { confirm = false },
    },

    {
      key = 'Escape',
      action = 'PopKeyTable',
    },
    {
      key = ';',
      action = 'ClearKeyTableStack',
    },

    {
      key = 'q',
      mods = 'CTRL',
      action = act.QuitApplication,
    },
  },
}

return config
