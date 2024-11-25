-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Import our new module (put this near the top of your wezterm.lua)
local appearance = require("theme")

-- Use it!
if appearance.is_dark() then
	config.color_scheme = "Tokyo Night"
else
	config.color_scheme = "Tokyo Night Day"
end

-- For example, changing the color scheme:
-- config.font = wezterm.font 'Dank Mono'
config.font = wezterm.font("Berkeley Mono")
config.font_size = 13
-- Slightly transparent and blurred background
config.window_background_opacity = 1
config.macos_window_background_blur = 30
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
-- Sets the font for the window frame (tab bar)
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	font = wezterm.font({ family = "Berkeley Mono", weight = "Bold" }),
	font_size = 13,
}
config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config
