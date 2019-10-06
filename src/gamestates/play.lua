--- Gameplay game state
-- @module gamestates.play

Talkies = require('lib.talkies.talkies')

local Sprite = require('core.sprite')
local Player = require('actor.player')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')

local Play = {}
Play.__index = menu

function Play:init()
	Globals.player = Player.new()
	Globals.player:setSprite(Sprite.new('assets/images/player/torsos/test.png', 24, 4, 0.3))


	self.dialogFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', Globals.config.dialogFontSize)
	Talkies.font = self.dialogFont

	self.level = TestLevel.new()

	self.hud = Hud.new()
end

function Play:draw()
	love.graphics.clear()
	self.level:draw()
	self.hud:draw()
	Talkies.draw()
end

function Play:update(dt)
	if Talkies.isOpen() then
		if Globals.input:wasActivated('a') or Globals.input:wasActivated('b') then
			Talkies.onAction()
		end
		if Globals.input:wasActivated('up') then
			Talkies.prevOption()
		end
		if Globals.input:wasActivated('down') then
			Talkies.nextOption()
		end
		Talkies.update(dt)
	else
		self.level:update(dt)
	end
end

return Play
