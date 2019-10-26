--- Gameplay game state
-- @module gamestates.play

local Sprite = require('core.sprite')
local Player = require('actor.player')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')

local Play = {}
Play.__index = Play

function Play:init()
	self.inited = true

	Globals.player = Player.new()
	Globals.player:setSprite(Sprite.new('assets/images/player/spooky.png', 16, 4, 0.3))

	self.level = self.levelClass.new()

	self.hud = Hud.new()
end

function Play:setLevel(levelClass)
	self.levelClass = levelClass
end

function Play:draw()
	love.graphics.clear()
	self.level:draw()
	self.hud:draw()
	Talkies.draw()
end

function Play:update(dt)
	if Globals.updateTalkies(dt) then return end
	self.level:update(dt)
end

return Play
