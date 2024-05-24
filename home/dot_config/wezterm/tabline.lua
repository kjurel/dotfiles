local wezterm = require "wezterm"

local process_icons = {
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["kuberlr"] = wezterm.nerdfonts.linux_docker,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["stern"] = wezterm.nerdfonts.linux_docker,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["lazydocker"] = wezterm.nerdfonts.linux_docker,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
}

-- wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
--   -- just log the default action and allow wezterm to perform it
--   wezterm.log_info("new-tab", window, pane, button, default_action)
-- end)
--
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- -- Otherwise, use the title from the active pane
  -- -- in that tab
  return tab_info.active_pane.title
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir.path or ""
  local HOME_DIR = string.format("file://%s", os.getenv "HOME")

  return current_dir == HOME_DIR and "." or string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
end

local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
    return tab.active_pane.foreground_process_name
  end

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
  if string.find(process_name, "kubectl") then
    process_name = "kubectl"
  elseif string.find(process_name, "nvim") then
    process_name = "nvim"
  end

  return process_icons[process_name] or string.format("[%s]", process_name)
end

-- wezterm.on("update-right-status", function(window, pane)
--   -- demonstrates shelling out to get some external status.
--   -- wezterm will parse escape sequences output by the
--   -- child process and include them in the status area, too.
--   local success, date, stderr = wezterm.run_child_process { "date" }
--
--   -- However, if all you need is to format the date/time, then:
--   date = wezterm.strftime "%Y-%m-%d %H:%M:%S"
--
--   -- Make it italic and underlined
--   window:set_right_status(wezterm.format {
--     { Attribute = { Underline = "Single" } },
--     { Attribute = { Italic = true } },
--     { Text = "Hello " .. date },
--   })
-- end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local edge_background = "#0b0022"
  local background = "#1b1032"
  local foreground = "#808080"

  if tab.is_active then
    background = "#2b2042"
    foreground = "#c0c0c0"
  elseif hover then
    background = "#3b3052"
    foreground = "#909090"
  end

  local edge_foreground = background

  -- local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  -- title = wezterm.truncate_right(title, max_width - 2)
  --
  local cwd = wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Text = get_current_working_dir(tab) },
  }

  local title = string.format(" %s ~ %s  ", get_process(tab), cwd)

  if has_unseen_output then
    return {
      { Foreground = { Color = "#28719c" } },
      { Text = title },
    }
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)
