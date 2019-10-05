--- Base class for sprites (animated and static)
-- @classmod core.sprite
-- @todo Add automatic updating across the whole game

local Sprite = {}
Sprite.__index = Sprite

--- Constructor
-- @param file An image file path
-- @param[opt] fw The width of one frame of the sprite's animation
-- @param[opt] frames The number of frames in the sprite's animation
-- @param[opt] duration The duration in seconds that each frame should span
-- @return A new Sprite instance
function Sprite.new(file, fw, frames, duration)
	local instance = {}

	--- Renderable image loaded from the given file name
	instance.image = love.graphics.newImage(file)

	--- Flag indicating whether or not the sprite is animated
	instance.animated = fw ~= nil

	--- Frame width
	instance.fw = fw or instance.image:getWidth()

	--- Frame height
	instance.fh = instance.image:getHeight()

	--- Total frames in the animation
	instance.frames = frames or 1

	--- Playback frame duration
	instance.duration = duration or 1

	--- Current frame
	instance.currentFrame = 1

	--- Playback status
	instance.playing = false

	--- Internal timer
	instance.timer = 0

	--- Quads for animation playback
	instance.quads = {}

	-- Calculate quads if animated
	if instance.animated then
		for i = 0, instance.frames - 1, 1 do
			local quad = love.graphics.newQuad(
				instance.fw * i,
				0,
				instance.fw,
				instance.image:getHeight(),
				instance.image:getDimensions()
			)

			table.insert(instance.quads, quad)
		end
	end

	-- Add self to the global sprite manager
	if instance.animated then
		Globals.updater:add(instance)
	end

	setmetatable(instance, Sprite)
	return instance
end

--- Reset the animation back to the first frame
function Sprite:resetAnimation()
	self.currentFrame = 1
end

--- Play the animation
function Sprite:playAnimation()
	self.playing = true
end

--- Pause the animation
function Sprite:pauseAnimation()
	self.playing = false
end

--- Pause the animation and reset it back to the first frame
function Sprite:stopAnimation()
	self.playing = false
	self.currentFrame = 1
end

--- Update the sprite's animation
-- @param dt Delta time
function Sprite:update(dt)
	-- Don't continue if this is a static sprite or it's not playing
	if not self.animated or not self.playing then
		return
	end

	-- Update the frame timer
	self.timer = self.timer + dt

	-- Advance frame if necessary
	if self.timer >= self.duration then
		self.timer = self.timer - self.duration
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > self.frames then
			self.currentFrame = 1
		end
	end
end

--- Draw the sprite on the screen
-- @param x X coordinate
-- @param y Y coordinate
-- @param r Orientation (radians)
-- @param sx X scale
-- @param sy Y scale
-- @param ox X origin offset
-- @param oy Y origin offset
function Sprite:draw(x, y, r, sx, sy, ox, oy)
	r = r or 0
	sx = sx or 1
	sy = sy or 1
	ox = ox or 0
	oy = oy or 0

	if self.animated then
		love.graphics.draw(self.image, self.quads[self.currentFrame], x, y, r, sx, sy, ox, oy)
	else
		love.graphics.draw(self.image, x, y, r, sx, sy, ox, oy)
	end
end

return Sprite
