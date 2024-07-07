-- Pull in the wezterm API
local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 12
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

local act = wezterm.action

local function windowicons()
  local CLOSE_CROSS = ("  %s  "):format(wezterm.nerdfonts.md_close)
  local MAXIMISE_BOX = (" %s "):format(wezterm.nerdfonts.md_window_maximize)
  local HIDE_DASH = (" %s "):format(wezterm.nerdfonts.md_window_minimize)
  local PLUS = (" %s "):format(wezterm.nerdfonts.md_plus)

  ---@param icon string
  ---@param hover_idx number | nil
  local function window_icons(icon, hover_idx)
    if hover_idx ~= nil then
      return wezterm.format {
        { Background = { Color = wezterm.color.get_default_colors().brights[hover_idx] } },
        { Text = icon },
      }
    else
      return wezterm.format { { Text = icon } }
    end
  end

  return {
    new_tab = window_icons(PLUS),
    new_tab_hover = window_icons(PLUS),
    window_close = window_icons(CLOSE_CROSS),
    window_close_hover = window_icons(CLOSE_CROSS, 2),
    window_maximize = window_icons(MAXIMISE_BOX),
    window_maximize_hover = window_icons(MAXIMISE_BOX, 5),
    window_hide = window_icons(HIDE_DASH),
    window_hide_hover = window_icons(HIDE_DASH),
  }
end

config.tab_bar_style = windowicons()
config.keys = {
  { key = "P", mods = "CTRL",       action = wezterm.action.ActivateCommandPalette },
  -- This will create a new split and run your default program inside it
  { key = "/", mods = "CTRL",       action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
  { key = "'", mods = "CTRL",       action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
  { key = "z", mods = "CTRL",       action = "TogglePaneZoomState" },
  { key = "x", mods = "CTRL",       action = act { CloseCurrentPane = { confirm = true } } },
  -- Pane Navigates
  -- { key = "h", mods = "CTRL", action = act({ ActivatePaneDirection = "Left" }) },
  -- { key = "l", mods = "CTRL", action = act({ ActivatePaneDirection = "Right" }) },
  -- { key = "k", mods = "CTRL", action = act({ ActivatePaneDirection = "Up" }) },
  -- { key = "j", mods = "CTRL", action = act({ ActivatePaneDirection = "Down" }) },
  -- Pane Cycles
  -- { key = "[", mods = "CTRL", action = act({ ActivatePaneDirection = "Next" }) },
  -- { key = "]", mods = "CTRL", action = act({ ActivatePaneDirection = "Prev" }) },
  -- Pane Resize
  -- { key = "H", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Left", 2 } }) },
  -- { key = "J", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Down", 2 } }) },
  -- { key = "K", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Up", 2 } }) },
  -- { key = "L", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Right", 2 } }) },
  -- TAB section
  { key = ",", mods = "CTRL",       action = act { ActivateTabRelativeNoWrap = 1 } },
  { key = "m", mods = "CTRL",       action = act { ActivateTabRelativeNoWrap = -1 } },
  -- search for the string "hash" matching regardless of case
  -- { key = "F", mods = "CTRL|SHIFT", action = act({ Search = { CaseInSensitiveString = "hash" } }) },
  { key = "T", mods = "CTRL|SHIFT", action = act.ShowTabNavigator },
  { key = "L", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs { flags = "LAUNCH_MENU_ITEMS" } },
  { key = "f", mods = "CTRL",       action = act.ToggleFullScreen },
  { key = "N", mods = "CTRL|SHIFT", action = act.SpawnWindow },
  { key = " ", mods = "CTRL|SHIFT", action = act.QuickSelect },
  {
    key = "R",
    mods = "CTRL|SHIFT",
    action = act.PromptInputLine {
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}
config.launch_menu = {
  { args = { "top" } },
  { args = { "nvim", "." } },
}
require "statusbar.right"
require "tabline"

-- and finally, return the configuration to wezterm
return config
