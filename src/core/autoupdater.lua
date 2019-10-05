--- A global manager that automatically updates all items given to it
-- @classmod core.autoupdater

local AutoUpdater = {}
AutoUpdater.__index = AutoUpdater

--- Constructor
-- @return A new AutoUpdater instance
function AutoUpdater.new()
	local instance = {}

	--- The collection of objects managed by this class
	instance.objects = {}

	setmetatable(instance, AutoUpdater)
	return instance
end

--- Add a new object to the updater
-- @param object The object to add
function AutoUpdater:add(object)
	table.insert(self.objects, object)
end

--- Update all objects
-- @param dt Delta time
function AutoUpdater:update(dt)
	for i, object in ipairs(self.objects) do
		object:update(dt)
	end

	-- If the object has a 'finished' property and it's marked as true,
	-- remove it from the updater
	for i = #self.objects, 1, -1 do
		if self.objects[i].finished ~= nil and self.objects[i].finished then
			table.remove(self.objects, i)
		end
	end
end

return AutoUpdater
