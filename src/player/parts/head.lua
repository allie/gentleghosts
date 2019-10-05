--- Base class for head parts
-- @classmod player.parts.head
-- @see player.player

local Head = {}
Head.__index = Head

--- Constructor
-- @return A new Head instance
function Head.new()
	local instance = {}

	--- The graphic to render for the head
	instance.sprite = nil

	--- The size of this part
	-- @field w Width
	-- @field h Height
	instance.size = {w=0, h=0}

	--- The position of this part, relative to its bounding box. This
	-- value is calculated in the Player class after all three body parts
	-- have been loaded.
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.position = {x=0, y=0}

	--- Attachment point for the torso part relative to the top left of the head's bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.torsoAttachment = {x=0, y=0}

	setmetatable(instance, Head)
	return instance
end

--- Set the sprite for this part
-- @param sprite A Sprite object
-- @see core.sprite
function Head:setSprite(sprite)
	self.sprite = sprite
	self.size.w = sprite.fw
	self.size.h = sprite.fh
	self.sprite:playAnimation()
end

--- Update the sprite's animation
function Head:update(dt)
	self.sprite:update(dt)
end

--- Draw the head on the Player canvas
function Head:draw()
	if self.sprite == nil then
		return
	end

	self.sprite:draw(self.position.x, self.position.y)
end

return Head
