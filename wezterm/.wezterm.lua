local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action


-- =========== Visuals: Hide title bar and auto-hide tab bar ===============
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = '2px'


-- =========== Colors ===========
config.colors = {
  background = '#121214',
}



-- =========== Keys: Replace Alt+Enter with F11 for fullscreen ===========
config.keys = {
  { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },
  { key = 'F11', action = act.ToggleFullScreen },
}



-- =========== Copy Mode Customizations =========== 

local key_tables = wezterm.gui.default_key_tables()

-- 1. Word movement
table.insert(key_tables.copy_mode, { key = 'LeftArrow', mods = 'CTRL', action = act.CopyMode 'MoveBackwardWord' })
table.insert(key_tables.copy_mode, { key = 'RightArrow', mods = 'CTRL', action = act.CopyMode 'MoveForwardWord' })

-- 2. Fixed 's' to start selecting (Cell mode)
table.insert(key_tables.copy_mode, { key = 's', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } })

-- 3. Use 'c' to Copy and Close
table.insert(key_tables.copy_mode, { key = 'c', mods = 'NONE', action = act.Multiple {
  { CopyTo = 'ClipboardAndPrimarySelection' },
  act.CopyMode 'Close',
} })


config.key_tables = key_tables



return config

