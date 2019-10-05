--- Base class for levels
-- @classmod level.level

local RedPotion = require('item.items.redpotion')

local Level = {}
Level.__index = Level

--- Constructor
-- @return A new Level instance
-- @param mapFile Path to the Tiled map file
function Level.new(mapFile)
	local instance = {}

	--- Background image
	instance.bg = nil

	--- Background offset
	-- @field x X offset
	-- @field y Y offset
	instance.bgOffset = {x=0, y=0}

	--- Background colour of the level
	instance.bgColour = {r=100, g=149, b=237}

	--- Background object
	-- @see core.background
	instance.bg = nil

	--- bump world
	instance.world = bump.newWorld()

	--- Game objects affected by gravity
	instance.objects = {}

	--- Gravity of the world in units/s^2
	instance.gravity = 30

	--- Tiled map
	instance.map = sti(mapFile, {'bump'})

	--- Item to class mapping
	instance.itemMap = {
		['redpotion'] = RedPotion
	}

	--- Camera
	instance.camera = Camera.new(
		Globals.player.aabb.x + Globals.player.aabb.cx,
		Globals.player.aabb.cy + Globals.player.aabb.cy,
		3
	)

	-- The bounds of the camera
	instance.cameraBounds = {
		left = love.graphics.getWidth() / 2 / instance.camera.scale,
		right = instance.map.width * instance.map.tilewidth - love.graphics.getWidth() / 2 / instance.camera.scale,
		top = love.graphics.getHeight() / 2 / instance.camera.scale,
		bottom = instance.map.height * instance.map.tileheight - love.graphics.getHeight() / 2 / instance.camera.scale,
	}

	-- Set spawn point for the player
	for k, object in pairs(instance.map.objects) do
		if object.name == 'spawn' then
			Globals.player.aabb.x = object.x
			Globals.player.aabb.y = object.y
			break
		end
	end

	-- Add player to the game objects collection
	table.insert(instance.objects, Globals.player)

	-- Load items into the world
	for k, object in pairs(instance.map.objects) do
		if object.type == 'item' then
			table.insert(
				instance.objects,
				instance.itemMap[object.name].new(object.x, object.y)
			)
		end
	end

	-- Add game objects to the world
	for i, obj in ipairs(instance.objects) do
		instance.world:add(obj, obj.aabb.x, obj.aabb.y, obj.aabb.w, obj.aabb.h)
	end

	-- Initialize STI with the world
	instance.map:bump_init(instance.world)

	setmetatable(instance, Level)
	return instance
end

--- Update the game world
-- @param dt Delta time
function Level:update(dt)
	-- Update the background
	self.bg:update(dt)

	-- Update all game objects
	for i, obj in ipairs(self.objects) do
		obj:update(dt)
	end

	-- Update the positions of game objects accounting for gravity
	local gdiff = self.gravity * dt

	for i, obj in ipairs(self.objects) do
		local ydiff = obj.velocity.y * dt * 60
		local xdiff = obj.velocity.x * dt

		local newY = obj.aabb.y + ydiff + gdiff
		local ax, ay, cols, len = self.world:move(obj, obj.aabb.x + xdiff, newY)

		obj.velocity.y = obj.velocity.y + gdiff

		if len > 0 and ay ~= newY then
			obj.velocity.y = 0
		end

		obj.aabb.x = ax
		obj.aabb.y = ay
	end

	-- Update the position of the camera to follow the character
	self.camera:lookAt(
		Globals.player.aabb.x + Globals.player.aabb.cx,
		Globals.player.aabb.y + Globals.player.aabb.cy
	)

	-- Clamp the camera within the bounds of the level
	self.camera.x = math.max(self.cameraBounds.left, self.camera.x)
	self.camera.x = math.min(self.cameraBounds.right, self.camera.x)
	self.camera.y = math.max(self.cameraBounds.top, self.camera.y)
	self.camera.y = math.min(self.cameraBounds.bottom, self.camera.y)
end

--- Draw the level on the screen
function Level:draw()
	-- Clear screen to the background colour
	love.graphics.clear(self.bgColour.r / 255, self.bgColour.g / 255, self.bgColour.b / 255)

	-- Reset the draw colour
	love.graphics.setColor(255, 255, 255)

	-- Draw the background image
	if self.bg ~= nil then
		self.bg:draw(self.camera.x / (self.map.width * self.map.tilewidth - Globals.player.aabb.w))
	end

	-- Calculate offset for map
	local tx = math.floor(self.camera.x - love.graphics.getWidth() / 2 / self.camera.scale)
	local ty = math.floor(self.camera.y - love.graphics.getHeight() / 2 / self.camera.scale)

	-- Draw the map
	self.map:draw(-tx, -ty, self.camera.scale, self.camera.scale)

	-- Draw game objects
	for i, obj in ipairs(self.objects) do
		obj:draw(self.camera)
	end
end

return Level
