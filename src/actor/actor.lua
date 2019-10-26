--- The main character of the game
-- @classmod actor.actor

local Gameobject = require('core.gameobject')

local Actor = {}
Actor.__index = Actor
setmetatable(Actor, {__index = Gameobject})

--- Constructor
-- @return A new Actor instance
function Actor.new()
	local instance = Gameobject.new()

	instance.type = 'actor'

	--- The graphic to render for the actor
	instance.sprite = nil

	--- The actor's current animation state
	instance.state = 'idle'

	instance.actionRadius = 10

	setmetatable(instance, Actor)
	return instance
end

--- Set the sprite for the actor and update the AABB
-- @param sprite A sprite object
-- @see core.sprite
function Actor:setSprite(sprite)
	self.sprite = sprite
	self.aabb.w = sprite.fw
	self.aabb.h = sprite.fh
	self.sprite:playAnimation()
end

--- Update the actor (handle input, etc.)
-- @param dt Delta time
-- @todo Add max velocity
function Actor:update(dt)
end

function Actor:getActionRect()
	local l = self.aabb.x
	if self.facing == 1 then
		l = l + self.aabb.w
	else
		l = l - self.actionRadius
	end
	local t = self.aabb.y
	local w = self.actionRadius
	local h = self.actionRadius

	return l, t, w, h
end

--- Draw the actor on the screen
-- @todo Incorporate camera coords
-- @param camera The level's camera
function Actor:draw(camera)
	camera:attach()

	if self.sprite == nil then
		return
	end

	if self.facing == -1 then
		self.sprite:draw(self.aabb.x, self.aabb.y, 0, self.facing, 1, self.aabb.w, 0)
	else
		self.sprite:draw(self.aabb.x, self.aabb.y)
	end

	camera:detach()
end

return Actor
