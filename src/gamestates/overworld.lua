local Sprite = require('core.sprite')

local Overworld = {}
Overworld.__index = Overworld

function Overworld:init()
	self.cursorIndex = 1
	self.levels = {}

	self.cursorSprite = Sprite.new('assets/images/player/spooky.png', 16, 4, 0.3)

	self.map = sti('assets/levels/overworld/overworld.lua')
	Globals.sound:startTrack('level1')


	for k, object in pairs(self.map.objects) do
		if object.type == 'level' then
			object.levelClass = require('level.levels.' .. object.name)
			self.levels[object.properties.levelNum] = object
		end
	end

	local level = self.levels[self.cursorIndex]

	--- Camera
	self.camera = Camera.new(
		level.x,
		level.y,
		3
	)

	-- The bounds of the camera
	self.cameraBounds = {
		left = love.graphics.getWidth() / 2 / self.camera.scale,
		right = self.map.width * self.map.tilewidth - love.graphics.getWidth() / 2 / self.camera.scale,
		top = love.graphics.getHeight() / 2 / self.camera.scale,
		bottom = self.map.height * self.map.tileheight - love.graphics.getHeight() / 2 / self.camera.scale,
	}
end

function Overworld:draw()
	love.graphics.clear()
	love.graphics.setColor(255, 255, 255)
	self.map:draw()

	-- Calculate offset for map
	local tx = math.floor(self.camera.x - love.graphics.getWidth() / 2 / self.camera.scale)
	local ty = math.floor(self.camera.y - love.graphics.getHeight() / 2 / self.camera.scale)

	-- Draw the map
	self.map:draw(-tx, -ty, self.camera.scale, self.camera.scale)

	local level = self.levels[self.cursorIndex]
	self.camera:attach()
	self.cursorSprite:draw(level.x, level.y)
	self.camera:detach()
end

function Overworld:update(dt)
	local newIndex = nil

	for i, key in ipairs(Globals.input.stack) do
		if key == 'right' and self.cursorIndex < #self.levels then
			newIndex = self.cursorIndex + 1
			break
		elseif key == 'left' and self.cursorIndex > 1 then
			newIndex = self.cursorIndex - 1
			break
		elseif key == 'a' then
			Globals.gamestates.play:setLevel(self.levels[self.cursorIndex].levelClass)
			Globals.gamestates.fade:setDuration(0.5)
			Globals.gamestates.fade:setNextState(Globals.gamestates.play)
			Gamestate.push(Globals.gamestates.fade)
			break
		end
	end

	if newIndex ~= nil then
		local newLevel = self.levels[newIndex]
		if newLevel ~= nil and newLevel.levelClass.unlocked() then
			self.cursorIndex = newIndex
		end
	end

	local level = self.levels[self.cursorIndex]
	-- Update the position of the camera to follow the character
	self.camera:lookAt(
		level.x,
		level.y
	)

	-- Clamp the camera within the bounds of the level
	self.camera.x = math.max(self.cameraBounds.left, self.camera.x)
	self.camera.x = math.min(self.cameraBounds.right, self.camera.x)
	self.camera.y = math.max(self.cameraBounds.top, self.camera.y)
	self.camera.y = math.min(self.cameraBounds.bottom, self.camera.y)
end

return Overworld
