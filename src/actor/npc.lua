local Actor = require('actor.actor')

Talkies = require('lib.talkies.talkies')

local Npc = {}
Npc.__index = Npc
setmetatable(Npc, {__index = Actor})

function Npc.new()
	local instance = Actor.new()

	instance.type = 'npc'

	instance.name = 'NPC'

	instance.currentDialog = 1
	instance.dialogs = {}

	setmetatable(instance, Npc)
	return instance
end

function Npc:talk()
	local dialog = self.dialogs[self.currentDialog]
	if dialog ~= nil then
		Talkies.say(self.name, dialog)
	end
end

return Npc
