--- A parallax scrolling background
-- @classmod core.background

local Background = {}
Background.__index = Background

--- Constructor
-- @param images A table of images to use for the layers
-- @param[opt] intensity Specifies how intense the parallax effect should be; 0 disables the effect
-- @param[opt] scale Scale to draw the background with
-- @param[opt] xOffset X offset for drawing the background
-- @param[opt] yOffset Y offset for drawing the background
-- @return A new Level instance
function Background.new(images, intensity, scale, xOffset, yOffset)
	local instance = {}

	--- Layers of the background
	instance.layers = {}

	--- Parallax intensity; 0 disables the effct
	instance.intensity = intensity or 0

	--- Scale to draw the background with
	instance.scale = scale or 1

	--- Drawing position
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.position = {x=x, y=y}

	--- Drawing offset
	-- @field x X offset
	-- @field y Y offset
	instance.offset = {x=xOffset or 0, y=yOffset or 0}

	-- Add layers in order
	for i, image in ipairs(images) do
		table.insert(instance.layers, love.graphics.newImage(image))
	end

	--- Width of one layer
	instance.layerWidth = instance.layers[1]:getWidth() * instance.scale

	--- X coordinate limits (for drawing along the X axis)
	instance.limit = (instance.layerWidth / 2) * (instance.intensity / 100)

	--- The bounds to render within
	-- @param w Width
	-- @param h Height
	instance.bounds = {
		w = (instance.limit - (-instance.limit)) + instance.layers[1]:getWidth() * instance.scale,
		h = instance.layers[1]:getHeight() * instance.scale
	}

	--- Autoscrolling layers (none by default)
	instance.autoscrollLayers = {}

	-- Add background to auto updater
	Globals.updater:add(instance)

	setmetatable(instance, Background)
	return instance
end

--- Enable autoscrolling on a layer
function Background:autoscroll(layer, speed, direction)
	self.autoscrollLayers[layer] = {
		position = 0,
		speed = speed
	}

	if direction == 'left' then
		self.autoscrollLayers[layer].direction = -1
	elseif direction == 'right' then
		self.autoscrollLayers[layer].direction = 1
	end
end

--- Update the background autoscrolling
-- @param dt Delta time
function Background:update(dt)
	for key, layer in pairs(self.autoscrollLayers) do
		layer.position = layer.position + (layer.speed / 100) * -layer.direction * dt

		if layer.direction == -1 and layer.position >= 1 then
			layer.position = -1
		elseif layer.direction == 1 and layer.position <= -1 then
			layer.position = 1
		end
	end
end

--- Draw the background
-- @param scroll How far along the map's X axis to calculate for; between 0 and 1
function Background:draw(scroll)
	love.graphics.setColor(1, 1, 1)

	scroll = scroll or 0.5

	-- Convert scroll to be between -1 and 1 for convenience
	scroll = scroll * 2 - 1

	-- Find the centre point
	local cx = love.graphics.getWidth() / 2 + self.offset.x
	local cy = love.graphics.getHeight() / 2 + self.offset.y

	for i, layer in ipairs(self.layers) do
		local mul = 1 / ((#self.layers - i) + 1)

		-- Render static layers
		if self.autoscrollLayers[i] == nil then
			love.graphics.draw(
				layer,
				cx - (mul * self.limit * scroll),
				cy,
				0,
				self.scale, self.scale,
				layer:getWidth() / 2,
				layer:getHeight() / 2
			)

		-- Render autoscrolling layers
		else
			local x = cx - (self.limit * self.autoscrollLayers[i].position) - (mul * self.limit * scroll)

			love.graphics.draw(
				layer,
				x,
				cy,
				0,
				self.scale, self.scale,
				layer:getWidth() / 2,
				layer:getHeight() / 2
			)

			-- Draw the layer a second time alongside the first so it wraps
			if x > 0 then
				x = x - layer:getWidth() * self.scale
			else
				x = x + layer:getWidth() * self.scale
			end

			love.graphics.draw(
				layer,
				x,
				cy,
				0,
				self.scale, self.scale,
				layer:getWidth() / 2,
				layer:getHeight() / 2
			)
		end
	end
end

return Background
