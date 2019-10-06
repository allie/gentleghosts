local Npc = require('actor.npc')

local Sprite = require('core.sprite')

local TestNpc = {}
TestNpc.__index = TestNpc
setmetatable(TestNpc, {__index = Npc})

function TestNpc.new()
	local instance = Npc.new()
	instance:setSprite(Sprite.new('assets/images/player/legs/test.png', 24, 4, 0.3))

	instance.name = 'Test NPC'
	instance.dialogs = {
		{"Hey there", "what gives"},
		{"Go away"}
	}

	setmetatable(instance, TestNpc)
	return instance
end

return TestNpc
