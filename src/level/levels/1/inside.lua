local Level = require('level.level')
local Background = require('core.background')

local Level1 = {}
Level1.__index = Level1
setmetatable(Level1, {__index = Level})

--- Constructor
-- @return A new Level1 instance
function Level1.new()
	local instance = Level.new('assets/levels/1/inside/level.lua')

	Globals.sound:startTrack('test')

	setmetatable(instance, Level1)
	return instance
end

return Level1
