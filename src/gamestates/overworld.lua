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
		elseif key == 'left' and self.cursorIndex > 1 then
			newIndex = self.cursorIndex - 1
		elseif key == 'a' then
			Globals.gamestates.play:setLevel(self.levels[self.cursorIndex].levelClass.new())
			Globals.gamestates.fade:setDuration(0.5)
			Globals.gamestates.fade:setNextState(Globals.gamestates.play)
			Gamestate.push(Globals.gamestates.fade)
		end
	end

	if newIndex ~= nil then
		local newLevel = self.levels[newIndex]
		if newLevel ~= nil and newLevel.levelClass.unlocked() then

		end
	end
end

return Overworld
