local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action


-- =========== Visuals ===============
--- Hide title bar and auto-hide tab bar
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true

--- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = '2px'

--- Initial window size
config.initial_cols = 130
config.initial_rows=38


-- =========== Colors ===========
config.colors = {
  background = '#121214',
}



-- =========== Keys ===========
config.keys = {
  -- Replace Alt+Enter with F11 for fullscreen
  { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },
  { key = 'F11', action = act.ToggleFullScreen },
  --  send keytriggers for micro editor: CtrlBackspace, CtrlShiftArrows(Left/Right) for selection, CtrlShiftArrows(Up/Down) for multiple cursor expansion.
  { key = 'Backspace', mods = 'CTRL', action = act.SendString '\x17' },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6D' },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6C' },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6A' },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6B' },
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

