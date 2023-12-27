-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 12
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

config.tab_bar_style = require("tabicons")
config.keys = require("mappings")
config.launch_menu = require("launcher")
require("tabline")

-- and finally, return the configuration to wezterm
return config
