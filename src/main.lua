--- Entry point for love
-- @script main

-- Load external libraries
Signal = require('lib.hump.signal')
Gamestate = require('lib.hump.gamestate')
Camera = require('lib.hump.camera')
bump = require('lib.bump.bump')
sti = require('lib.sti.sti')
bitser = require('lib.bitser.bitser')

local Config = require('core.config')
local AutoUpdater = require('core.autoupdater')
local InputManager = require('core.inputmanager')
local SoundManager = require('core.soundmanager')

-- Game states
local FadeState = require('gamestates.fade')
local MenuState = require('gamestates.mainmenu')
local OptionsState = require('gamestates.optionsmenu')
local AudioState = require('gamestates.audiomenu')
local ControlsState = require('gamestates.controlsmenu')
local PlayState = require('gamestates.play')

--- Table holding anything that should be easily accessible anywhere within the game
Globals = {}

-- A custom love.run is used so we can avoid clearing every frame; we
-- do that manually elsewhere
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	return function()
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		if love.timer then dt = love.timer.step() end
 
		if love.update then love.update(dt) end
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.origin() 
			if love.draw then love.draw() end
 
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end

--- Register game state and do initialization
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)

	Globals.config = Config.new('settings.lua')

	Globals.gamestates = {
		fade = FadeState,
		mainMenu = MenuState,
		optionsMenu = OptionsState,
		audioMenu = AudioState,
		controlsMenu = ControlsState,
		play = PlayState
	}

	Globals.updater = AutoUpdater.new()
	Globals.input = InputManager.new()
	Globals.input:findGamepads()
	Globals.sound = SoundManager.new()

	Gamestate.registerEvents()
	Gamestate.switch(Globals.gamestates.mainMenu)
end

function love.update(dt)
	Globals.updater:update(dt)
end
