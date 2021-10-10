--[[
	GUI event controller without manually setting up remove events.
	Licensed under the MIT license, originally built for 0aoq/Fluent
	
	https://github.com/0aoq/Fluent/blob/main/LICENSE
	0a_oq, 10/07/21; last updated: 10/07/21
]]

local RunService = game:GetService("RunService")
local Storage = game:GetService("ReplicatedStorage")

_G["Fluent.UIEvent"] = {
	Name = "Fluent.UIEvent",
	Author = "0a_oq",
	Enabled = true
}

local checkClient, checkServer = 
	(function() return RunService:IsClient(); end),  (function() return RunService:IsServer(); end)

local lib = {}; do
	local events = {}

	-- types
	export type EventConfig = {
		Name: string,
		Action: any,
		Player: string?,

		Remote: any?,
		hasEvent: boolean?
	}

	-- create server assets
	local _remote, _remote1 = nil, nil
	lib.Server = function()
		local __ = Instance.new("RemoteEvent", Storage); __.Name = "Fluent.UIEvents://DirectPassage"
		local ___ = Instance.new("RemoteEvent", Storage); ___.Name = "Fluent.UIEvents://Passage"

		__.OnServerEvent:Connect(function(Player, args) events[args.config.Name] = args.config
		end); ___.OnServerEvent:Connect(function(Player, EventName) return events[EventName] or nil; end)
	end

	-- handle events
	lib.CreateEvent = function(config: EventConfig)
		-- create an event, and configure the event.Remote function to handle client events
		config.Remote = (function()
			local remote = Storage:FindFirstChild(config.Name)
			if (not remote) then return; end
			remote.OnClientEvent:Connect(function(args)
				config.Action(
					game:GetService("Players").LocalPlayer, 
					args
				); config.hasEvent = true
			end)
		end); if (checkClient()) then
			events[config.Name] = config
		elseif (checkServer()) then
			if (_remote) then _remote:FireServer({ config = config }) else
				warn("[UIEvents]: Please run UIEvents.Server() before creating events on the server.")
			end
		end
	end

	lib.RunEvent = function(Name, Player, args)
		-- handle event running
		local __;
		if (checkClient()) then 
			if (not events[Name]) then
				__ = Storage:WaitForChild("Fluent.UIEvents://Passage"):FireServer(Name) or nil
			else __ = events [Name]; end
		end

		local e: EventConfig = events[Name] or __; if (e) then
			if (e.Player) then if (Player.Name ~= e.Player) then return; end; end

			local PLAYER_INSTANCE = game:GetService("Players"):FindFirstChild(Player)
			if (not e.hasEvent) then e.Remote(PLAYER_INSTANCE, args); end

			if (e.Action) then
				if (checkServer()) then
					-- we're on the server, run function with server info
					local remote = Storage:FindFirstChild(e.Name) or Instance.new("RemoteEvent", Storage); remote.Name = e.Name
					if (remote) then remote:FireClient(PLAYER_INSTANCE, args); end
				else
					-- we're on the client, run function full client side
					e.Action(PLAYER_INSTANCE, args)
				end
			end
		else
			warn("[UIEvent]: Event name is invalid!")
		end
	end

	lib.PingPlayer = function(PlayerName: string, args)
		-- run events for a player whenever an event with the player's name comes up
		return task.spawn(function()
			while true do
				wait(); for _,x in pairs(events) do
					if (x.Player == PlayerName) then
						lib.RunEvent(x.Name, PlayerName, args)
					end
				end
			end
		end)
	end
end; return lib
