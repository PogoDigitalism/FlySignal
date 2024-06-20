local RunService = game:GetService('RunService')

local Signal = {}
Signal.__index = Signal

local output = false
if RunService:IsStudio() then
	output = true
end

function Signal.new(name: string)
	local self = setmetatable({}, Signal)
	self._name = name
	self._connections = {}
	self._once_connections = {}

	return self
end

function Signal:Fire(...)
	if output then warn('--> signal fire;', self._name) end
	for _, connection in ipairs(self._connections) do
		task.spawn(connection, ...)
	end
	for _, connection in ipairs(self._once_connections) do
		task.spawn(connection, ...)
	end
	table.clear(self._once_connections)
end

function Signal:Clean()
	table.clear(self._connections)
	table.clear(self._once_connections)
end

function Signal:Connect(func, forced_gc: Instance?)
	table.insert(self._connections, func)

	local disconnectFunc = function()
		for i, connection in ipairs(self._connections) do
			if connection == func then
				if output then warn('-->', tostring(func), 'disconnection for Signal', self._name) end
				table.remove(self._connections, i)
				break
			end
		end
	end

	return disconnectFunc
end

function Signal:Wait(duration : number?)
	local Running = coroutine.running()

	local _delay
	if duration then
		_delay = task.delay(duration, function(thread)
			task.defer(thread)
		end, Running)
	end

	self:Once(function(...)
		if _delay then task.cancel(_delay) end
		task.defer(Running, ...)
	end)

	return coroutine.yield()
end

function Signal:Once(func)
	table.insert(self._once_connections, func)
end

return Signal
