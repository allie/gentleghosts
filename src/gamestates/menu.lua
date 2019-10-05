--- Menu game state base class
-- @module gamestates.menu
-- @todo This code is a mess

local Menu = {}
Menu.__index = Menu

--- Basic initialization
function Menu:basicInit()
	self.itemsStart = love.graphics.getHeight() / 2
	self.itemSize = 64
	self.itemSpacing = 16
	self.itemFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.itemSize)
	self.itemFont:setFilter('nearest', 'nearest', 1)

	self.titleSize = 64
	self.titleFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.titleSize)
	self.titleFont:setFilter('nearest', 'nearest', 1)

	self.title = ''
	self.menuItems = {}

	self.itemStates = {}

	self.bgColour = {0/255, 0/255, 0/255}
	self.titleColour = {0/255, 255/255, 120/255}
	self.itemColour = {255/255, 255/255, 255/255}
	self.selectedItem = 1
end

--- Initialization
function Menu:init()
	self:basicInit()
end

--- Enter this state
function Menu:enter()

end

--- Resume this state
function Menu:resume()

end

--- Enter the game state associated with the current menu option
function Menu:enterMenuItem()
	Globals.sound:play('ui-select')
	Globals.gamestates.fade:setDuration(0.5)
	Globals.gamestates.fade:setNextState(self.itemStates[self.menuItems[self.selectedItem]])
	Gamestate.push(Globals.gamestates.fade)
end

--- Exit the current menu state
function Menu:exitMenu()
	Globals.sound:play('ui-back')
	Globals.gamestates.fade:setDuration(0.5)
	Gamestate.pop()
end

--- Check whether the cursor should be moved down
function Menu:checkMoveUp()
	-- Move cursor up
	if Globals.input:wasActivated('up') then
		Globals.sound:play('ui-move')
		self.selectedItem = self.selectedItem - 1
		if self.selectedItem < 1 then
			self.selectedItem = #self.menuItems
		end
		return true
	end
	return false
end

--- Check whether the cursor should be moved down
function Menu:checkMoveDown()
	-- Move cursor down
	if Globals.input:wasActivated('down') then
		Globals.sound:play('ui-move')
		self.selectedItem = self.selectedItem + 1
		if self.selectedItem > #self.menuItems then
			self.selectedItem = 1
		end
		return true
	end
	return false
end

--- Check whether the A button was pressed and a submenu should be entered
function Menu:checkEnterItem()
	return Globals.input:wasActivated('a') or Globals.input:wasActivated('start')
end

--- Check whether the back button was pressed and the menu must be exited
function Menu:checkExit()
	return Globals.input:wasActivated('b') or Globals.input:wasActivated('back')
end

--- A basic update routine for a standard menu
-- @param dt Delta time
function Menu:basicUpdate(dt)
	if self:checkMoveUp() then
	elseif self:checkMoveDown() then
	elseif self:checkEnterItem() then
		self:enterMenuItem()
	elseif self:checkExit() then
		self:exitMenu()
	end
end

--- Update the main menu
-- @param dt Delta time
function Menu:update(dt)
	self:basicUpdate()
end

--- Basic drawing
function Menu:basicDraw()
	-- Draw the game title
	love.graphics.setColor(unpack(self.titleColour))
	love.graphics.setFont(self.titleFont);
	love.graphics.printf(
		self.title,
		0,
		100,
		love.graphics.getWidth(),
		'center'
	)

	-- Draw the menu items
	love.graphics.setFont(self.itemFont);
	for i, item in ipairs(self.menuItems) do
		love.graphics.setColor(unpack(self.itemColour))

		local str = item
		if self.selectedItem == i then
			str = '> ' .. item .. ' <'
		end

		love.graphics.printf(
			str,
			0,
			self.itemsStart + (self.itemSize + self.itemSpacing) * (i - 1),
			love.graphics.getWidth(),
			'center'
		)
	end
end

--- Draw
function Menu:draw()
	love.graphics.clear(unpack(self.bgColour))
	self:basicDraw()
end

return Menu
