local Signal = require(script.Parent.SignalLib)

local Signals = {
	Message__Post = Signal.new("Message__Post"),
	RemoteCalls__Capped = Signal.new("RemoteCalls__Capped"),
	PlayerData__Loaded = Signal.new("PlayerData__Loaded"),

  -- ETC
}

return Signals
