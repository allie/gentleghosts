--- Test level
-- @classmod level.levels.test
-- @see level.level

local Level = require('level.level')
local Background = require('core.background')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Level})

--- Constructor
-- @return A new Test instance
function Test.new()
	local instance = Level.new('assets/levels/test/test.lua')

	instance.bg = Background.new({
		'assets/levels/test/bg/1.png',
		'assets/levels/test/bg/2.png',
		'assets/levels/test/bg/3.png',
		'assets/levels/test/bg/4.png',
		'assets/levels/test/bg/5.png'
	}, 100, 6, 0, -100)

	instance.bg:autoscroll(5, 5, 'right')

	Globals.sound:startTrack('level1')

	setmetatable(instance, Test)
	return instance
end

return Test
