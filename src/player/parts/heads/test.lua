--- Test head
-- @classmod player.parts.heads.test
-- @see player.parts.head

local Head = require('player.parts.head')
local Sprite = require('core.sprite')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Head})

--- Constructor
-- @return A new Test instance
function Test.new()
	local instance = Head.new()

	instance:setSprite(Sprite.new('assets/images/player/heads/test.png'))
	instance.torsoAttachment.x = instance.size.w / 2
	instance.torsoAttachment.y = instance.size.h

	setmetatable(instance, Test)
	return instance
end

return Test
