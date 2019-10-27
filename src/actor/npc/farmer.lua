local Npc = require('actor.npc')

local Sprite = require('core.sprite')

local Farmer = {}
Farmer.__index = Farmer
setmetatable(Farmer, {__index = Npc})

function Farmer.new()
	local instance = Npc.new()
	instance:setSprite(Sprite.new('assets/images/npc/farmer.png', 26, 3, 1))

	instance.name = 'Farmer'
	instance.dialogs = {
		{"All this work has sure gotten me starving", "I sure wish I had something to eat"},
	}

	setmetatable(instance, Farmer)
	return instance
end

function Farmer:getDialog()
	if Globals.player:hasItem('meat') then
		return {"Hoo boy this looks delicious!"}
	end

	return Npc.getDialog(self)
end

function Farmer:talkEnd()
	local potionIndex = Globals.player:getItem('meat')
	if potionIndex ~= nil then
		table.remove(Globals.player.heldItems, potionIndex)
		Gamestate.pop()
		return
	end

	Npc.talkEnd(self)
end

return Farmer
