local wezterm = require("wezterm")

local theme_colors = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

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
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	local retval = current_dir == HOME_DIR and "." or string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
	return string.format("%s", retval)
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

	local edge_background = theme_colors.tab_bar["inactive_tab_edge"]
	local background = theme_colors.tab_bar.inactive_tab["bg_color"]
	local foreground = theme_colors.tab_bar.inactive_tab["fg_color"]

	if tab.is_active then
		background = theme_colors.tab_bar.active_tab["bg_color"]
		foreground = theme_colors.tab_bar.active_tab["fg_color"]
	elseif hover then
		background = theme_colors.tab_bar.inactive_tab_hover["bg_color"]
		foreground = theme_colors.tab_bar.inactive_tab_hover["fg_color"]
	end

	local edge_foreground = background

	-- local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width - 2)
	--

	local title = string.format(" %s %s ", tab.tab_index, get_process(tab))

	if has_unseen_output then
		return {
			{ Background = { Color = edge_foreground } },
			{ Foreground = { Color = edge_background } },
			{ Text = SOLID_RIGHT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = theme_colors.brights[7] } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end

	return {
		{ Background = { Color = edge_foreground } },
		{ Foreground = { Color = edge_background } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		cwd_uri = cwd_uri.path:sub(8)
		local slash = cwd_uri:find("/")
		local cwd = ""
		local hostname = ""
		if slash then
			hostname = cwd_uri:sub(1, slash - 1)
			-- Remove the domain name portion of the hostname
			local dot = hostname:find("[.]")
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			-- and extract the cwd from the uri
			cwd = cwd_uri:sub(slash)

			table.insert(cells, cwd)
			table.insert(cells, hostname)
		end
	end

	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %H:%M")
	table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
	end

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		theme_colors.brights[0],
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8",
	}
	-- local colors = theme_colors.ansi

	-- Foreground color for the text across the fade
	local text_fg = theme_colors.cursor_fg

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	local function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)
