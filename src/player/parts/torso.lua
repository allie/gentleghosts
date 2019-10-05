--- Base class for torso parts
-- @classmod player.parts.torso
-- @see player.player

local Torso = {}
Torso.__index = Torso

--- Constructor
-- @return A new Torso instance
function Torso.new()
	local instance = {}

	--- The graphic to render for the torso
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

	--- The weight value of the torso; affects speed and jump height
	instance.weight = 50

	--- The health bonus the torso provides; affects total health
	instance.health = 10

	--- Attachment point for the head part relative to the top left of the torso's bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.headAttachment = {x=0, y=0}

	--- Attachment point for the legs part relative to the top left of the torso's bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.legsAttachment = {x=0, y=0}

	setmetatable(instance, Torso)
	return instance
end

--- Set the sprite for this part
-- @param sprite A Sprite object
-- @see core.sprite
function Torso:setSprite(sprite)
	self.sprite = sprite
	self.size.w = sprite.fw
	self.size.h = sprite.fh
	self.sprite:playAnimation()
end

--- Perform the action associated with the torso. This could be
-- an attack with a weapon, use of a tool, etc.
function Torso:action()
	-- Do nothing by default
end

--- Update the sprite's animation
-- @param dt Delta time
function Torso:update(dt)
	self.sprite:update(dt)
end

--- Draw the torso on the Player canvas
function Torso:draw()
	if self.sprite == nil then
		return
	end

	self.sprite:draw(self.position.x, self.position.y)
end

return Torso
