--- Test legs
-- @classmod player.parts.legs.test
-- @see player.parts.legs

local Legs = require('player.parts.legs')
local Sprite = require('core.sprite')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Legs})

--- Constructor
-- @return A new Test instance
function Test.new()
	local instance = Legs.new()

	instance:setSprite(Sprite.new('assets/images/player/legs/test.png', 24, 4, 0.3))
	instance.torsoAttachment.x = instance.size.w / 2
	instance.torsoAttachment.y = 0

	setmetatable(instance, Test)
	return instance
end

return Test
