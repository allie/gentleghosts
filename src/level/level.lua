--- Base class for levels
-- @classmod level.level

local Level = {}
Level.__index = Level

local DRAW_DOORS = true
local DOOR_WIDTH = 30
local DOOR_HEIGHT = 30

local FALL_DAMAGE = 1

--- Constructor
-- @return A new Level instance
-- @param mapFile Path to the Tiled map file
function Level.new(mapFile)
	local instance = {}

	instance.type = 'level'

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

	instance.doors = {}

	--- Gravity of the world in units/s^2
	instance.gravity = 30

	--- Tiled map
	instance.map = sti(mapFile, {'bump'})

	instance.checkpoint = nil

	--- Camera
	instance.camera = Camera.new(
		Globals.player.aabb.x + Globals.player.aabb.cx,
		Globals.player.aabb.cy + Globals.player.aabb.cy,
		3
	)

	instance.mapBounds = {
		left = 0,
		right = instance.map.width * instance.map.tilewidth,
		top = 0,
		bottom = instance.map.height * instance.map.tileheight
	}

	-- The bounds of the camera
	instance.cameraBounds = {
		left = (love.graphics.getWidth() / 2) / instance.camera.scale,
		right = instance.mapBounds.right - (love.graphics.getWidth() / 2) / instance.camera.scale,
		top = (love.graphics.getHeight() / 2) / instance.camera.scale,
		bottom = instance.mapBounds.bottom - (love.graphics.getHeight() / 2) / instance.camera.scale,
	}

	-- Load items into the world
	for k, object in pairs(instance.map.objects) do
		if object.name == 'spawn' or object.type == 'spawn' then
			instance.checkpoint = object
			Globals.player:setPos(object.x, object.y)

			-- Add player to the game objects collection
			table.insert(instance.objects, Globals.player)
		elseif object.type == 'npc' then
			local npc = require('actor.npc.' .. object.name).new()
			npc:setPos(object.x, object.y)

			table.insert(
				instance.objects,
				npc
			)
		elseif object.type == 'item' then
			table.insert(
				instance.objects,
				require('item.items.' .. object.name).new(object.x, object.y)
			)
	elseif object.type == 'level' or object.type == 'exit' then
			table.insert(instance.doors, {
				type = object.type,
				name = object.name,
				isSolid = false,
				aabb = {
					x = object.x - DOOR_WIDTH / 2,
					y = object.y - DOOR_HEIGHT / 2,
					w = DOOR_WIDTH,
					h = DOOR_HEIGHT
				}
			})
		end
	end

	-- Add game objects to the world
	for i, obj in ipairs(instance.objects) do
		instance.world:add(obj, obj.aabb.x, obj.aabb.y, obj.aabb.w, obj.aabb.h)
	end

	for i, door in ipairs(instance.doors) do
		instance.world:add(door, door.aabb.x, door.aabb.y, door.aabb.w, door.aabb.h)
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
		if obj.shouldRemove then
			table.remove(i)
		else
			obj:update(dt)
		end
	end

	if Globals.input:wasActivated('b') then
		local items, len = self.world:queryRect(Globals.player:getActionRect())
		for i, item in ipairs(items) do
			if item ~= Globals.player then
				if item.type == 'npc' then
					item:talk()
					break
				elseif item.type == 'item' then
					if item.id ~= nil then
						Globals.player.heldItems[item.id] = item
					else
						table.insert(Globals.player.heldItems, item)
					end

					self.world:remove(item)

					for i, obj in ipairs(self.objects) do
						if obj == item then
							table.remove(self.objects, i)
						end
					end
					break
				elseif item.type == 'level' then
					local level = require('level.levels.' .. item.name)
					if level.unlocked() then
						Gamestate.push(Globals.gamestates.fade:pop())
						Globals.gamestates.play:setLevel(level)
						Globals.gamestates.play:init()
					end
				elseif item.type == 'exit' then
					Gamestate.pop()
				end
			end
		end
	end

	-- Update the positions of game objects accounting for gravity
	local gdiff = self.gravity * dt

	local filter = self:getBumpFilter()

	for i, obj in ipairs(self.objects) do
		local ydiff = obj.velocity.y * dt * 60
		local xdiff = obj.velocity.x * dt

		local newY = obj.aabb.y + ydiff + gdiff
		local ax, ay, cols, len = self.world:move(
			obj,
			obj.aabb.x + xdiff,
			newY,
			filter
		)

		obj.velocity.y = obj.velocity.y + gdiff

		if len > 0 and ay ~= newY then
			obj.velocity.y = 0
		end

		obj:setPos(ax, ay)

		if obj == Globals.player then
			for j, col in ipairs(cols) do
				if col.other.type == 'checkpoint' then
					col.other.shouldRemove = true
					self.checkpoint = col.other
				end
			end
		end
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

	self:checkDamage()
end

function Level:checkDamage()
	-- Check fall damage
	if
		Globals.player.aabb.x < self.mapBounds.left
		or Globals.player.aabb.x > self.mapBounds.right
		or Globals.player.aabb.y < self.mapBounds.top
		or Globals.player.aabb.y > self.mapBounds.bottom
	then
		Globals.player.health.current = Globals.player.health.current - FALL_DAMAGE

		if Globals.player.health.current > 0 then
			self:respawnPlayer()
			return
		end
	end

	if Globals.player.health.current <= 0 then
		self:gameover()
	end
end

function Level:gameover()
	Gamestate.pop()
end

function Level:respawnPlayer()
	if self.checkpoint then
		self.ignoreCollision = true
		Gamestate.push(Globals.gamestates.fade:pop())
		Globals.input:reset()
		Globals.player.velocity.x = 0
		Globals.player.velocity.y = 0
		Globals.player:setPos(self.checkpoint.x, self.checkpoint.y)
	end
end

function Level:getBumpFilter()
	if self.ignoreCollision then
		self.ignoreCollision = false
		return function(a, b)
			return false
		end
	end

	return function(a, b)
		if b.isSolid == false then
			return 'cross'
		else
			return 'slide'
		end
	end
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

	if DRAW_DOORS then
		self.camera:attach()
		for i, door in ipairs(self.doors) do
			love.graphics.rectangle('line', door.aabb.x, door.aabb.y, door.aabb.w, door.aabb.h)
		end
		self.camera:detach()
	end
end

function Level.unlocked()
	return true
end

return Level
