--- Base class for all game objects
-- @classmod core.gameobject

local Gameobject = {}
Gameobject.__index = Gameobject

--- Constructor
-- @return A new Gameobject instance
function Gameobject.new()
	local instance = {}

	--- The object's axis-aligned bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	-- @field w Width
	-- @field h Height
	-- @field cx Centre X coordinate
	-- @field cy Centre Y coordinate
	instance.aabb = {x=0, y=0, w=0, h=0, cx=0, cy=0}

	--- The object's current velocity
	-- @field x X velocity
	-- @field y Y velocity
	instance.velocity = {x=0, y=0}

	--- The direction the object is facing; 1 = right, -1 = left
	instance.facing = 1

	--- The object's weight
	instance.weight = 1

	--- Enable or disable collision
	instance.isSolid = true

	setmetatable(instance, Gameobject)
	return instance
end

--- Update the object. This function is intended
-- to be overridden by child classes.
-- @param dt Delta time
function Gameobject:update(dt)
	-- Do nothing
end

--- Draw the object on the screen. This function is intended
-- to be overridden by child classes.
-- @param camera The level's camera
function Gameobject:draw(camera)
	-- Do nothing
end

return Gameobject
