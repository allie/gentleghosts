--- Audio menu game state
-- @module gamestates.audiomenu

local Menu = require('gamestates.menu')

local AudioMenu = {}
AudioMenu.__index = AudioMenu
setmetatable(AudioMenu, {__index = Menu})

function AudioMenu:init()
	self:basicInit()

	self.itemsStart = self.itemsStart - 50

	self.title = 'Audio'

	self.menuItems = {
		'Master volume',
		'SFX volume',
		'Music volume',
		'Defaults'
	}
end

return AudioMenu
