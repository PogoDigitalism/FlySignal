-- CLIENT SCRIPT

local players = game:GetService('Players')
local ts = game:GetService('TweenService')
local rs = game:GetService('ReplicatedStorage')
local ss = game:GetService('ServerStorage')

local SignalService = require(rs:WaitForChild('Signals').SignalService)

local port_to_client = rs:WaitForChild('RemoteEvents').Signals.PortToClient

port_to_client.OnClientEvent:Connect(function(signal_name: string, ...)
	SignalService[signal_name]:Fire(...)
end)
