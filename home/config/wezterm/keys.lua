local wezterm = require("wezterm")
local backdrops = require("backdrops")

local key_config = {}

-- macOS reserves Option for the us-altgr-intl dead-key layout (Option+letter
-- = accented characters), so plain-ALT shortcuts there go on Command instead.
local is_macos = wezterm.target_triple:find("apple") ~= nil
local nav_mod = is_macos and "CMD" or "ALT"
wezterm.log_info("current nav_mod: " ..nav_mod)

-- leaderkey setup
key_config.leader = { key = "Space", mods = "CTRL", timeout_millisections = 2000 }

-- smart splits config
-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

-- keymaps
key_config.keys = {
	{ key = "c", mods = "CTRL|ALT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.SpawnCommandInNewWindow({}),
	},
	{
		mods = "LEADER",
		key = "t",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = ";",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "/",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = nav_mod,
		key = "h",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = nav_mod,
		key = "l",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = nav_mod,
		key = "j",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = nav_mod,
		key = "k",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = nav_mod,
		key = "n",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = nav_mod,
		key = "p",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = nav_mod,
		key = ",",
		action = wezterm.action.ActivateWindowRelative(-1),
	},
	{
		mods = nav_mod,
		key = ".",
		action = wezterm.action.ActivateWindowRelative(1),
	},
	  -- show the pane selection mode, but have it swap the active and selected panes
	{
		key = "s",
		mods = nav_mod,
		action = wezterm.action.PaneSelect { mode = "SwapWithActive" },
	},
	{
		key = "n",
		mods = nav_mod .. "|SHIFT",
		action = wezterm.action.MoveTabRelative(-1),
	},
	-- Move tab one slot to the right
	{
		key = "p",
		mods = nav_mod .. "|SHIFT",
		action = wezterm.action.MoveTabRelative(1),
	},

	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
}

for i = 1, 9 do
	table.insert(key_config.keys, {
		key = tostring(i),
		mods = nav_mod,
		action = wezterm.action.ActivateTab(i - 1),
	})
end

return key_config
