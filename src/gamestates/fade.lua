--- Fade transition state
-- @module gamestates.fade
-- @todo Fade in

local Fade = {}
Fade.__index = Fade

function Fade:init()
	--- Image data from the screen grabbed immediately upon entering this state
	self.screenshot = nil

	--- The fade out duration in seconds
	self.duration = 0.5

	--- Animation timer in seconds
	self.timer = 0

	--- Whether to transition forward or backward
	self.direction = 'next'
end

--- Set the animation duration
-- @param duration The duration (in seconds)
function Fade:setDuration(duration)
	self.duration = duration
end

--- Set the next state the transition should fade to
-- @param state The next state
function Fade:setNextState(state)
	self.nextState = state
end

--- Capture an image of the existing screen to fade from
function Fade:freezeScreen()
	local instance = self
	love.graphics.captureScreenshot(function(data)
		instance.screenshot = love.graphics.newImage(data)
	end)
end

--- Fade to the next state
function Fade:fadeToNext()
	self:freezeScreen()
	self.timer = 0
	self.direction = 'next'
end

--- Fade to the previous state
function Fade:fadeToPrevious()
	self:freezeScreen()
	self.timer = 0
	self.direction = 'prev'
end

--- Enter (fade to next)
function Fade:enter()
	self:fadeToNext()
end

--- Resume (fade to previous)
function Fade:resume()
	self:fadeToPrevious()
end

--- Draw the screenshot and a fade to black on top of it
function Fade:draw()
	love.graphics.clear()

	if self.screenshot ~= nil then
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(self.screenshot, 0, 0, 0, 0.5, 0.5)
	end

	love.graphics.setColor(0, 0, 0, self.timer / self.duration)
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

--- Update the transition
-- @param dt Delta time
function Fade:update(dt)
	self.timer = self.timer + dt

	if self.timer >= self.duration then
		if self.direction == 'next' then
			Gamestate.push(self.nextState)
		elseif self.direction == 'prev' then
			Gamestate.pop()
		end
	end
end

return Fade
