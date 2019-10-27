--- Gameplay game state
-- @module gamestates.play

local Sprite = require('core.sprite')
local Player = require('actor.player')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')

local Play = {}
Play.__index = Play

function Play.new()
	local instance = {}
	setmetatable(instance, Play)

	Globals.player = Player.new()
	Globals.player:setSprite(Sprite.new('assets/images/player/spooky.png', 16, 4, 0.3))

	instance.levels = {}
	instance.currentLevel = nil

	return instance
end

function Play:reset()
	self.levels = {}
	self.currentLevel = nil
end

function Play:init()
	self.inited = true
	Globals.player = Player.new()
	Globals.player:setSprite(Sprite.new('assets/images/player/spooky.png', 16, 4, 0.3))

	self:initLevel()
	self.hud = Hud.new()
end

function Play:setLevel(levelClass)
	self.currentLevel = levelClass

	if self.inited and not self:getLevel() then
		self:initLevel()
	end

	self:getLevel():enter()
end

function Play:initLevel()
	if self.currentLevel then
		self.levels[self.currentLevel] = self.currentLevel.new()
	end
end

function Play:getLevel()
	return self.levels[self.currentLevel]
end

function Play:draw()
	love.graphics.clear()
	self:getLevel():draw()
	self.hud:draw()
	Talkies.draw()
end

function Play:update(dt)
	if Globals.updateTalkies(dt) then return end
	self:getLevel():update(dt)
end

return Play
