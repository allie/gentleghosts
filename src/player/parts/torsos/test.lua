--- Test torso
-- @classmod player.parts.torsos.test
-- @see player.parts.torso

local Torso = require('player.parts.torso')
local Sprite = require('core.sprite')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Torso})

--- Constructor
-- @return A new Test instance
function Test.new()
	local instance = Torso.new()

	instance:setSprite(Sprite.new('assets/images/player/torsos/test.png', 24, 4, 0.3))
	instance.headAttachment.x = instance.size.w / 2
	instance.headAttachment.y = 4
	instance.legsAttachment.x = instance.size.w / 2
	instance.legsAttachment.y = instance.size.h - 4

	setmetatable(instance, Test)
	return instance
end

return Test
