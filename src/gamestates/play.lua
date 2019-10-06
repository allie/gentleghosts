--- Gameplay game state
-- @module gamestates.play

local Sprite = require('core.sprite')
local Player = require('player.player')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')

local Play = {}
Play.__index = menu

function Play:init()
	Globals.player = Player.new()
	Globals.player:setSprite(Sprite.new('assets/images/player/spooky.png', 16, 4, 0.3))

	self.level = TestLevel.new()

	self.hud = Hud.new()
end

function Play:draw()
	love.graphics.clear()
	self.level:draw()
	self.hud:draw()
end

function Play:update(dt)
	self.level:update(dt)
end

return Play
