local wezterm = require("wezterm")

local CLOSE_CROSS = ("  %s  "):format(wezterm.nerdfonts.md_close)
local MAXIMISE_BOX = (" %s "):format(wezterm.nerdfonts.md_window_maximize)
local HIDE_DASH = (" %s "):format(wezterm.nerdfonts.md_window_minimize)

---@param icon string
---@param hover_idx number | nil
local function window_icons(icon, hover_idx)
	if hover_idx ~= nil then
		return wezterm.format({
			{ Background = { Color = wezterm.color.get_default_colors().brights[hover_idx] } },
			{ Text = icon },
		})
	else
		return wezterm.format({ { Text = icon } })
	end
end

return {
	window_close = window_icons(CLOSE_CROSS),
	window_close_hover = window_icons(CLOSE_CROSS, 2),
	window_maximize = window_icons(MAXIMISE_BOX),
	window_maximize_hover = window_icons(MAXIMISE_BOX, 5),
	window_hide = window_icons(HIDE_DASH),
	window_hide_hover = window_icons(HIDE_DASH),
}
