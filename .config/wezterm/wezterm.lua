local wezterm = require 'wezterm';

require('status_line')

return {
  keys = {
    -- This will create a new split and run your default program inside it
    {key="Enter", mods="CTRL|SHIFT",
      action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="Enter", mods="CTRL|SHIFT|ALT",
      action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},

    -- Tab Management: somehow not working out of the box, so we shall redefine them
    {key="PageUp", mods="CTRL",
      action=wezterm.action{ActivateTabRelative=-1}},
    {key="PageDown", mods="CTRL",
      action=wezterm.action{ActivateTabRelative=1}},

    {key="1", mods="ALT",
      action=wezterm.action{ActivateTab=0}},
    {key="2", mods="ALT",
      action=wezterm.action{ActivateTab=1}},
    {key="3", mods="ALT",
      action=wezterm.action{ActivateTab=2}},
    {key="4", mods="ALT",
      action=wezterm.action{ActivateTab=3}},
    {key="5", mods="ALT",
      action=wezterm.action{ActivateTab=4}},
    {key="6", mods="ALT",
      action=wezterm.action{ActivateTab=5}},
    {key="7", mods="ALT",
      action=wezterm.action{ActivateTab=6}},
    {key="8", mods="ALT",
      action=wezterm.action{ActivateTab=7}},
    {key="9", mods="ALT",
      action=wezterm.action{ActivateTab=8}},
  },
  font = wezterm.font("Fira Code"),
  tab_bar_at_bottom = true,

  window_background_opacity = 1.0,
  window_background_image = "/home/lyc/Pictures/Wallpapers/misc/abstract.jpg",
  window_background_image_hsb = {
    brightness = 0.3,
    hue = 1.0,
    saturation = 1.0,
  },
}
