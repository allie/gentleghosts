local Npc = require('actor.npc')

local Sprite = require('core.sprite')

local TestNpc = {}
TestNpc.__index = TestNpc
setmetatable(TestNpc, {__index = Npc})

function TestNpc.new()
	local instance = Npc.new()
	instance:setSprite(Sprite.new('assets/images/items/meat.png'))

	instance.name = 'Test NPC'
	instance.dialogs = {
		{"Hey there", "what gives"},
		{"Go away"}
	}

	setmetatable(instance, TestNpc)
	return instance
end

function TestNpc:getDialog()
	if Globals.player:hasItem('redpotion') then
		return {"Hey thanks for the potion!"}
	end

	return Npc.getDialog(self)
end

function TestNpc:talkEnd()
	local potionIndex = Globals.player:getItem('redpotion')
	if potionIndex ~= nil then
		table.remove(Globals.player.heldItems, potionIndex)
		Gamestate.pop()
		return
	end

	Npc.talkEnd(self)
end

return TestNpc
