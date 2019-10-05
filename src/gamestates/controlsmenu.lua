--- Controls config game state
-- @module gamestates.controlsmenu

local Menu = require('gamestates.menu')
local Sprite = require('core.sprite')

local ControlsMenu = {}
ControlsMenu.__index = ControlsMenu
setmetatable(ControlsMenu, {__index = Menu})

function ControlsMenu:init()
	self.title = ''

	self.titleSize = 48
	self.titleFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.titleSize)
	self.titleFont:setFilter('nearest', 'nearest', 1)

	self.bgColour = {0/255, 0/255, 0/255}
	self.titleColour = {0/255, 255/255, 120/255}
	self.itemColour = {255/255, 255/255, 255/255}

	self.selectedItem = 1
	self.selectedDevice = 1

	self.deviceItems = {
		'Keyboard / mouse',
		'Gamepad'
	}

	self.menuItems = {
		'',
		'Jump',
		'Attack',
		'Drink potion',
		'Use item',
		'Menu',
		'Back'
	}

	--- A table of internal input names indexed by control names
	-- @todo Come up with a less messy way
	self.controlsMapping = {
		['Jump'] = 'a',
		['Attack'] = 'b',
		['Drink potion'] = 'x',
		['Use item'] = 'y',
		['Menu'] = 'start',
		['Back'] = 'back'
	}

	self.itemsStart = 200;
	self.itemSize = 48
	self.itemSpacing = 16
	self.itemFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.itemSize)
	self.itemFont:setFilter('nearest', 'nearest', 1)

	local xbox = 'assets/images/hud/controller/xbox/'

	self.xboxSprites = {
		['a'] = Sprite.new(xbox .. 'a.png', 16, 2, 0.3),
		['b'] = Sprite.new(xbox .. 'b.png', 16, 2, 0.3),
		['x'] = Sprite.new(xbox .. 'x.png', 16, 2, 0.3),
		['y'] = Sprite.new(xbox .. 'y.png', 16, 2, 0.3),
		['dpleft'] = Sprite.new(xbox .. 'dpleft.png', 16, 2, 0.3),
		['dpright'] = Sprite.new(xbox .. 'dpright.png', 16, 2, 0.3),
		['dpup'] = Sprite.new(xbox .. 'dpup.png', 16, 2, 0.3),
		['dpdown'] = Sprite.new(xbox .. 'dpdown.png', 16, 2, 0.3),
		['leftx-'] = Sprite.new(xbox .. 'lsleft.png', 16, 2, 0.3),
		['leftx+'] = Sprite.new(xbox .. 'lsright.png', 16, 2, 0.3),
		['lefty+'] = Sprite.new(xbox .. 'lsup.png', 16, 2, 0.3),
		['lefty-'] = Sprite.new(xbox .. 'lsdown.png', 16, 2, 0.3),
		['leftstick'] = Sprite.new(xbox .. 'lsclick.png', 16, 2, 0.3),
		['rightx-'] = Sprite.new(xbox .. 'rsleft.png', 16, 2, 0.3),
		['rightx+'] = Sprite.new(xbox .. 'rsright.png', 16, 2, 0.3),
		['righty+'] = Sprite.new(xbox .. 'rsup.png', 16, 2, 0.3),
		['righty-'] = Sprite.new(xbox .. 'rsdown.png', 16, 2, 0.3),
		['rightstick'] = Sprite.new(xbox .. 'rsclick.png', 16, 2, 0.3),
		['leftshoulder'] = Sprite.new(xbox .. 'lb.png', 16, 2, 0.3),
		['rightshoulder'] = Sprite.new(xbox .. 'rb.png', 16, 2, 0.3),
		['triggerleft'] = Sprite.new(xbox .. 'lt.png', 16, 2, 0.3),
		['triggerright'] = Sprite.new(xbox .. 'rt.png', 16, 2, 0.3),
		['start'] = Sprite.new(xbox .. 'start.png', 16, 2, 0.3),
		['back'] = Sprite.new(xbox .. 'back.png', 16, 2, 0.3)
	}

	self.gamepadBindings = {}
	self.keyBindings = {}

	self.bindingTimer = 0
	self.bindingDuration = 3
	self.didBind = false
end

function ControlsMenu:enter()
	-- If there is a gamepad connected, prioritize it over keyboard
	if Globals.input.gamepad ~= nil then
		self.deviceItems = {
			'Gamepad',
			'Keyboard / mouse'
		}
	end
end

function ControlsMenu:leave()
	-- End the animations for all sprites
	for button, sprite in pairs(self.xboxSprites) do
		sprite:stopAnimation()
	end
end

function ControlsMenu:keypressed(key)
	if self.waiting then
		if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
			return
		end

		local control = self.controlsMapping[self.menuItems[self.selectedItem]]
		Globals.input:rebind(control, 'key', key)
		self.didBind = true
	end
end

function ControlsMenu:mousepressed(button)
	if self.waiting then
		local control = self.controlsMapping[self.menuItems[self.selectedItem]]
		Globals.input:rebind(control, 'mouse', button)
		self.didBind = true
	end
end

function ControlsMenu:gamepadpressed(gamepad, button)
	if self.waiting then
		if button == 'dpup' or button == 'dpdown' or button == 'dpleft' or button == 'dpright' then
			return
		end

		local control = self.controlsMapping[self.menuItems[self.selectedItem]]
		Globals.input:rebind(control, 'button', button)
		self.didBind = true
	end
end

function ControlsMenu:gamepadaxis(gamepad, axis, value)
	if self.waiting then
		if axis ~= 'triggerleft' and axis ~= 'triggerright' then
			return
		end

		local control = self.controlsMapping[self.menuItems[self.selectedItem]]
		Globals.input:rebind(control, 'trigger', axis)
		self.didBind = true
	end
end

function ControlsMenu:update(dt)
	-- Update waiting timer
	if self.waiting then
		self.bindingTimer = self.bindingTimer + dt

		-- If the control was successfully rebound or the timer is up,
		-- stop waiting for an input
		if self.didBind or self.bindingTimer >= self.bindingDuration then
			self.waiting = false
		end

		-- Block all other interactions
		return
	end

	-- Up and down
	if self:checkMoveUp() then
	elseif self:checkMoveDown() then

	-- Start waiting for input
	elseif self:checkEnterItem() and self.selectedItem ~= 1 then
		self.waiting = true
		self.didBind = false
		self.bindingTimer = 0
		return

	-- Exit the menu
	elseif self:checkExit()	then
		Gamestate.pop()
		return

	else
		-- Handle left and right movement while device is selected
		if self.selectedItem == 1 then
			if Globals.input:wasActivated('left') then
				self.selectedDevice = self.selectedDevice - 1
				if self.selectedDevice < 1 then
					self.selectedDevice = #self.deviceItems
				end
			elseif Globals.input:wasActivated('right') then
				self.selectedDevice = self.selectedDevice + 1
				if self.selectedDevice > #self.deviceItems then
					self.selectedDevice = 1
				end
			end

			self.title = self.deviceItems[self.selectedDevice]
		end
	end
end

function ControlsMenu:draw()
	love.graphics.clear()

	-- Draw the selected device title
	love.graphics.setColor(unpack(self.titleColour))
	love.graphics.setFont(self.titleFont);

	if self.selectedItem == 1 then
		love.graphics.printf(
			'< ' .. self.title .. ' >',
			0,
			50,
			love.graphics.getWidth(),
			'center'
		)
	else
		love.graphics.printf(
			self.title,
			0,
			50,
			love.graphics.getWidth(),
			'center'
		)
	end

	-- Draw control labels
	love.graphics.setFont(self.itemFont);
	for i, item in ipairs(self.menuItems) do
		if i ~= 1 then
			love.graphics.setColor(unpack(self.itemColour))

			local str = item
			if self.selectedItem == i then
				str = '> ' .. item
			end

			love.graphics.printf(
				str,
				200,
				self.itemsStart + (self.itemSize + self.itemSpacing) * (i - 1),
				love.graphics.getWidth() - 400,
				'left'
			)

			-- If a button is being rebound, write some text
			if self.waiting and self.selectedItem == i then
				love.graphics.printf(
					'Waiting...',
					200,
					self.itemsStart + (self.itemSize + self.itemSpacing) * (i - 1),
					love.graphics.getWidth() - 400,
					'right'
				)

			-- Draw the button for each bound control
			else
				if self.deviceItems[self.selectedDevice] == 'Gamepad' then
					local control = self.controlsMapping[self.menuItems[i]]
					local binding = Globals.config.gamepadBindings[control]

					if binding ~= nil then
						local name = binding[2]
						-- @todo Render different sprites for playstation controllers
						self.xboxSprites[name]:draw(
							love.graphics.getWidth() - 248,
							self.itemsStart + (self.itemSize + self.itemSpacing) * (i - 1),
							0, 3, 3
						)

						-- Animate the highlighted button
						if self.selectedItem == i then
							self.xboxSprites[name]:playAnimation()
						else
							self.xboxSprites[name]:stopAnimation()
						end
					end
				end
			end
		end
	end

	love.graphics.setColor(1, 1, 1)
end

return ControlsMenu
