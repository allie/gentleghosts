--- love configuration file
-- @script conf

--- Set love configuration
-- @param t Configuration table
function love.conf(t)
	t.identity = 'GameOff'
	t.accelerometerjoystick = false 
	t.window.title = 'Game-Off'
	t.window.icon = nil
	t.window.width = 1024
	t.window.height = 768
	t.window.resizable = false
	t.window.fullscreen = false
	t.window.fullscreentype = 'desktop'
	t.window.vsync = 1
	t.window.msaa = 0
	t.window.depth = nil
	t.window.stencil = nil
	t.window.display = 1
	t.window.highdpi = true
	t.window.x = nil
	t.window.y = nil
	t.modules.audio = true
	t.modules.data = true
	t.modules.event = true
	t.modules.font = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.joystick = true
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.physics = false
	t.modules.sound = true
	t.modules.system = true
	t.modules.thread = true
	t.modules.timer = true
	t.modules.touch = false
	t.modules.video = true
	t.modules.window = true
	t.console = true
end
