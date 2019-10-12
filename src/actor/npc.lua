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

function Npc:getDialog()
	return self.dialogs[self.currentDialog]
end

function Npc:talk()
	local dialog = self:getDialog()
	if dialog ~= nil then
		Talkies.say(self.name, dialog, {
			oncomplete = function (dialog) self:talkEnd(dialog) end
		})
	end
end

function Npc:talkEnd(dialog)
	if self.currentDialog < #self.dialogs then
		self.currentDialog = self.currentDialog + 1
	end
end

return Npc
