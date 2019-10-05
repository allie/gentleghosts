--- Health HUD element
-- @classmod hud.health

local Health = {}
Health.__index = Health

--- Constructor
-- @return A new Health instance
function Health.new()
	local instance = {}

	--- The sprite for each health bar tick
	instance.sprite = love.graphics.newImage('assets/images/hud/health.png')

	--- The amount of ticks to put on a row before breaking to the next
	instance.ticksPerRow = 20

	setmetatable(instance, Health)
	return instance
end

--- Draw the Health bar
-- @param x X coordinate
-- @param y Y coordinate
-- @param ticks Number of ticks to draw
function Health:draw(x, y, ticks)
	local ticksLeft = ticks
	local drawnOnRow = 0
	local cx = x
	local cy = y

	while ticksLeft > 0 do
		if drawnOnRow >= self.ticksPerRow then
			cy = cy + self.sprite:getHeight() + 1
			cx = x
			drawnOnRow = 0
		end

		love.graphics.draw(self.sprite, cx, cy)

		ticksLeft = ticksLeft - 1
		drawnOnRow = drawnOnRow +1
		cx = cx + self.sprite:getWidth() + 1
	end
end

return Health
