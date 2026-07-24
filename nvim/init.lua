-- Entry point — load config modules
-- Files live directly in the nvim config dir (not on Lua's package.path,
-- which only includes the lua/ subdir), so load them via dofile().

local configPath = vim.fn.stdpath("config")

dofile(configPath .. "/settings.lua")
dofile(configPath .. "/keybindings.lua")
dofile(configPath .. "/plugins.lua")

-- Colorscheme lives in colors/minimal-fedu.lua; load after plugins so plugin
-- highlight groups exist when it runs.
vim.cmd("colorscheme minimal-fedu")
