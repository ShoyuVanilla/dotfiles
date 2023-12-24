local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { 'pwsh', '-l' }
config.window_decorations = 'RESIZE'
config.font = wezterm.font 'FiraCode Nerd Font Mono'

return config
