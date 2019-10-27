local Item = require('item.item')

local Meat = {}
Meat.__index = Meat
setmetatable(Meat, {__index = Item})

--- Constructor
-- @return A new Item instance
-- @param x X coordinate
-- @param y Y coordinate
function Meat.new(x, y)
	local instance = Item.new(
		x,
		y,
		'meat',
		love.graphics.newImage('assets/images/items/meat.png')
	)

	setmetatable(instance, Meat)
	return instance
end

return Meat
