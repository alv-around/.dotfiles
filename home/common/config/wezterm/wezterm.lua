-- setup
local wezterm = require("wezterm")
local utf8 = require("utf8")

local config = wezterm.config_builder()

-- GPU setup
-- enable WebGpu if there is an integrated GPU available with Vulkan drivers
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		break
	end
end

-- enable wayland to avoid problems with wayland fractional scaling
-- config.enable_wayland = false

--- INFO: Uncomment to activate random backgrounds.
--- this has to be called before any other backdrop method
-- require("backdrops"):set_images():random()

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- mouse
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- TODO: refactor code in append method
for k, v in pairs(require("keys")) do
	config[k] = v
end
for k, v in pairs(require("appearance")) do
	config[k] = v
end

return config
