--- A red potion to restore health
-- @classmod item.items.redpotion
-- @see item.item

local Item = require('item.item')

local RedPotion = {}
RedPotion.__index = RedPotion
setmetatable(RedPotion, {__index = Item})

--- Constructor
-- @return A new Item instance
-- @param x X coordinate
-- @param y Y coordinate
function RedPotion.new(x, y)
	local instance = Item.new(x, y, love.graphics.newImage('assets/images/items/redpotion.png'))

	setmetatable(instance, RedPotion)
	return instance
end

return RedPotion
