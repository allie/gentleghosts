local Level = require('level.level')
local Background = require('core.background')

local Level1 = {}
Level1.__index = Level1
setmetatable(Level1, {__index = Level})

--- Constructor
-- @return A new Level1 instance
function Level1.new()
	local instance = Level.new('assets/levels/1/level.lua')

	instance.bg = Background.new({
		'assets/levels/1/bg/1.png',
		'assets/levels/1/bg/2.png',
		'assets/levels/1/bg/3.png',
		'assets/levels/1/bg/4.png',
		'assets/levels/1/bg/5.png'
	}, 100, 6, 0, -100)

	instance.bg:autoscroll(5, 5, 'right')

	Globals.sound:startTrack('test')

	setmetatable(instance, Level1)
	return instance
end

return Level1
