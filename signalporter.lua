-- SERVER SCRIPT

local players = game:GetService('Players')
local ts = game:GetService('TweenService')
local rs = game:GetService('ReplicatedStorage')
local ss = game:GetService('ServerStorage')

local SignalService = require(rs:WaitForChild('Signals').SignalService)

local port_to_client = rs:WaitForChild('RemoteEvents').Signals.PortToClient

local to_port = {	
	Quests__Refreshed = SignalService.Quests__Refreshed,
	Quest__Progressed = SignalService.Quest__Progressed,
	Quest__Completed = SignalService.Quest__Completed,

  -- ETC
}

local to_port_all_clients = {
	Game__Started = SignalService.Game__Started,
	Game__Finished = SignalService.Game__Finished,
}

for signal_name, signal in pairs(to_port) do
	signal:Connect(function(p: Player, ...)
		print('--> Portable Signal triggered: '..signal_name..' (', {...} ,')')
	
		port_to_client:FireClient(p, signal_name, ...)
	end)
end

for signal_name, signal in pairs(to_port_all_clients) do
	signal:Connect(function(...)
		print('--> Portable Signal triggered: '..signal_name..' (', {...} ,')')
		
		port_to_client:FireAllClients(signal_name, ...)
	end)
end
