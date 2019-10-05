--- A configuration management class
-- @classmod core.config

local Config = {}
Config.__index = Config

--- Constructor
-- @return A new Config instance
function Config.new()
	local instance = {}

	--- The name of the file containing user settings
	instance.file = 'settings'

	setmetatable(instance, Config)

	instance:load()

	return instance
end

--- Load data from either the user settings file or the default settings file
function Config:load()
	local settings = {}
	local didLoad = false

	if not love.filesystem.getInfo(self.file) then
		settings = love.filesystem.load('assets/data/defaultsettings.lua')()
	else
		settings = bitser.loads(love.filesystem.read(self.file))
		didLoad = true
	end

	for key, val in pairs(settings) do
		self[key] = val
	end

	if not didLoad then
		self:write()
	end
end

--- Write data to the user settings file
function Config:write()
	local settings = {}

	for key, val in pairs(self) do
		if key ~= 'write' and
			key ~= 'load' and
			key ~= 'new' and
			key ~= 'file' and
			key ~= '__index' then
			settings[key] = val
		end
	end

	local success, message = love.filesystem.write(self.file, bitser.dumps(settings))

	if not success then
		print(message)
	end
end

return Config
