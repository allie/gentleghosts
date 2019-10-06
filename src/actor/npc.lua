local Actor = require('actor.actor')

local Npc = {}
Npc.__index = Npc
setmetatable(Npc, {__index = Actor})

function Npc.new()
	local instance = Actor.new()

	instance.currentDialog = 0
	instance.dialogs = {}

	setmetatable(instance, Npc)
	return instance
end

return Npc
