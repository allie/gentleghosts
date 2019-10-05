--- Main menu game state
-- @module gamestates.mainmenu

local Menu = require('gamestates.menu')
local Background = require('core.background')

local MainMenu = {}
MainMenu.__index = MainMenu
setmetatable(MainMenu, {__index = Menu})

function MainMenu:init()
	self:basicInit()

	self.titleSize = 128
	self.titleFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.titleSize)
	self.title = 'GameOff'

	self.menuItems = {
		'Play',
		'Options'
	}

	self.itemStates = {
		['Play'] = Globals.gamestates.play,
		['Options'] = Globals.gamestates.optionsMenu
	}

	self.bg = Background.new({
		'assets/images/menu/bg/1.png',
		'assets/images/menu/bg/2.png',
		'assets/images/menu/bg/3.png'
	}, 100, 6, 0, -100)

	self.bg:autoscroll(2, 1, 'right')
	self.bg:autoscroll(3, 2, 'right')

	Globals.sound:startTrack('menu')
end

function MainMenu:draw()
	love.graphics.clear(unpack(self.bgColour))

	-- Draw the background
	self.bg:draw()

	-- Normal menu drawing
	self:basicDraw()
end

return MainMenu
