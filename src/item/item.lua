--- The base class for all items
-- @classmod item.item

local Gameobject = require('core.gameobject')

local Item = {}
Item.__index = Item
setmetatable(Item, {__index = Gameobject})

--- Constructor
-- @param x X coordinate
-- @param y Y coordinate
-- @param sprite The sprite for this item
-- @return A new Item instance
function Item.new(x, y, name, sprite)
	local instance = Gameobject.new()

	instance.type = 'item'

	--- The sprite to render for this item
	instance.sprite = sprite
	instance.name = name

	-- Set the weight to 0 so it stays in place
	instance.weight = 0

	-- Calculate the AABB
	instance.aabb.x = x
	instance.aabb.y = y
	instance.aabb.w = instance.sprite:getWidth()
	instance.aabb.h = instance.sprite:getHeight()

	setmetatable(instance, Player)
	return instance
end

--- Draw the item in the world
-- @param camera The level's camera
function Item:draw(camera)
	if self.sprite == nil then
		return
	end

	camera:attach()

	love.graphics.draw(self.sprite, self.aabb.x, self.aabb.y)

	camera:detach()
end

return Item
