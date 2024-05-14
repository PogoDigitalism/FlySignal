local Signal = {}
Signal.__index = Signal

function Signal.new(name: string)
	local self = setmetatable({}, Signal)
	self._name = name
	self._connections = {}

	return self
end

function Signal:Fire(...)
	warn('--> signal fire;', self._name)
	for _, connection in ipairs(self._connections) do
		task.spawn(connection, ...)
	end
end

function Signal:Clean()
	table.clear(self._connections)
end

function Signal:Connect(func, forced_gc: Instance?)
	table.insert(self._connections, func)

	local disconnectFunc = function()
		for i, connection in ipairs(self._connections) do
			if connection == func then
				warn('-->', tostring(func), 'disconnection for Signal', self._name)
				table.remove(self._connections, i)
				break
			end
		end
	end

	return disconnectFunc
end

function Signal:Once(func)
	table.insert(self._connections, func)
	
end

return Signal
