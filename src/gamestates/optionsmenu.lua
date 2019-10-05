--- Options menu game state
-- @module gamestates.optionsmenu

local Menu = require('gamestates.menu')

local OptionsMenu = {}
OptionsMenu.__index = OptionsMenu
setmetatable(OptionsMenu, {__index = Menu})

function OptionsMenu:init()
	self:basicInit()

	self.itemsStart = self.itemsStart - 50

	self.title = 'Options'

	self.menuItems = {
		'Audio',
		'Video',
		'Controls',
		'Misc'
	}

	self.itemStates = {
		['Audio'] = Globals.gamestates.audioMenu,
		['Video'] = nil,
		['Controls'] = Globals.gamestates.controlsMenu,
		['Misc'] = nil
	}
end

return OptionsMenu
