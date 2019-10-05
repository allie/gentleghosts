--- The main character of the game
-- @classmod player.player

local Gameobject = require('core.gameobject')

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = Gameobject})

--- Constructor
-- @return A new Player instance
function Player.new()
	local instance = Gameobject.new()

	--- The graphic to render for the player
	instance.sprite = nil

	--- The player's current animation state
	instance.state = 'idle'

	--- The player's health state
	-- @field total Total health
	-- @field current Current health
	instance.health = {total=2, current=2}

	-- Current input state
	instance.input = {}

	-- Valid keys for handling input
	instance.validKeys = {
		['a'] = true,
		['d'] = true,
		['space'] = true,
		['left'] = true,
		['right'] = true
	}

	setmetatable(instance, Player)
	return instance
end

--- Set the sprite for the player and update the AABB
-- @param sprite A sprite object
-- @see core.sprite
function Player:setSprite(sprite)
	self.sprite = sprite
	self.aabb.w = sprite.fw
	self.aabb.h = sprite.fh
	self.sprite:playAnimation()
end

--- Update the player (handle input, etc.)
-- @param dt Delta time
-- @todo Add max velocity
function Player:update(dt)
	-- Recalculate the player's x velocity based on pressed keys
	-- (only if a jump is not occurring)
	if self.velocity.y == 0 then
		self.velocity.x = 0

		for i, key in ipairs(Globals.input.stack) do
			-- Left
			if key == 'left' then
				self.velocity.x = -180
				self.facing = -1

			-- Right
			elseif key == 'right' then
				self.velocity.x = 180
				self.facing = 1
			end
		end
	end

	-- If space was pressed, begin a jump
	if Globals.input:wasActivated('a') and self.velocity.y == 0 then
		if self.weight == 0 then
			self.velocity.y = 0
		else
			Globals.sound:play('player-jump')
			self.velocity.y = -7.8 / self.weight
		end
	end
end

--- Draw the player on the screen
-- @todo Incorporate camera coords
-- @param camera The level's camera
function Player:draw(camera)
	if self.sprite == nil then
		return
	end

	camera:attach()

	if self.facing == -1 then
		self.sprite:draw(self.aabb.x, self.aabb.y, 0, self.facing, 1, self.aabb.w, 0)
	else
		self.sprite:draw(self.aabb.x, self.aabb.y)
	end

	camera:detach()
end

return Player
