local wezterm = require("wezterm")

local act = wezterm.action

return {
	-- This will create a new split and run your default program inside it
	{ key = "/", mods = "CTRL", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "'", mods = "CTRL", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "CTRL", action = "TogglePaneZoomState" },
	{ key = "x", mods = "CTRL", action = act({ CloseCurrentPane = { confirm = true } }) },
	-- Pane Sections
	-- Pane Navigates
	-- { key = "h", mods = "CTRL", action = act({ ActivatePaneDirection = "Left" }) },
	-- { key = "l", mods = "CTRL", action = act({ ActivatePaneDirection = "Right" }) },
	-- { key = "k", mods = "CTRL", action = act({ ActivatePaneDirection = "Up" }) },
	-- { key = "j", mods = "CTRL", action = act({ ActivatePaneDirection = "Down" }) },
	-- Pane Cycles
	{ key = "[", mods = "CTRL", action = act({ ActivatePaneDirection = "Next" }) },
	{ key = "]", mods = "CTRL", action = act({ ActivatePaneDirection = "Prev" }) },
	-- Pane Resize
	{ key = "H", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Left", 2 } }) },
	{ key = "J", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Down", 2 } }) },
	{ key = "K", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Up", 2 } }) },
	{ key = "L", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Right", 2 } }) },
	-- TAB section
	{ key = ",", mods = "CTRL", action = act({ ActivateTabRelativeNoWrap = 1 }) },
	{ key = "m", mods = "CTRL", action = act({ ActivateTabRelativeNoWrap = -1 }) },
	-- search for the string "hash" matching regardless of case
	{ key = "F", mods = "CTRL|SHIFT", action = act({ Search = { CaseInSensitiveString = "hash" } }) },
	{ key = "T", mods = "CTRL|SHIFT", action = "ShowTabNavigator" },
	-- { key = "L", mods = "CTRL|SHIFT", action = "ShowLauncher" },
	{ key = "f", mods = "CTRL", action = "ToggleFullScreen" },
	{ key = "N", mods = "CTRL|SHIFT", action = "SpawnWindow" },
	{ key = " ", mods = "CTRL|SHIFT", action = "QuickSelect" },
	-- personal
	{ key = "q", mods = "ALT", action = act.ShowTabNavigator },
	{ key = "n", mods = "SHIFT|CTRL", action = act.ToggleFullScreen },
	{ key = "9", mods = "CTRL", action = act.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }) },
	{ key = "7", mods = "ALT", action = act.ShowLauncher },
	{
		key = ",",
		mods = "CTRL",
		action = act.SpawnCommandInNewTab({
			label = "config",
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			set_environment_variables = { TERM = "screen-256color" },
			args = { "nvim", os.getenv("WEZTERM_CONFIG_FILE") },
		}),
	},
	{
		key = "r",
		mods = "SHIFT|CTRL",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}
