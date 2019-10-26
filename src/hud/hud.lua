--- HUD (heads up display)
-- @classmod hud.hud

local Health = require('hud.health')

local Hud = {}
Hud.__index = Hud

--- Constructor
-- @return A new Hud instance
function Hud.new()
	local instance = {}

	--- UI scale
	instance.scale = 2

	--- Canvas to draw the HUD to (in order to scale 2x later)
	instance.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

	--- Health bar instance
	-- @see hud.health
	instance.health = Health.new()

	setmetatable(instance, Hud)
	return instance
end

--- Draw the HUD
function Hud:draw()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	self.health:draw(10, 10, Globals.player.health.current)

	for i, item in ipairs(Globals.player.heldItems) do
		love.graphics.draw(
			item.sprite,
			(self.canvas:getWidth() / 2) - item.sprite:getWidth() - 10 * i,
			10
		)
	end

	love.graphics.setCanvas()

	love.graphics.draw(self.canvas, 0, 0, 0, self.scale, self.scale)
end

return Hud
