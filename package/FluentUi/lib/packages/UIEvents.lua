--[[
	GUI event controller without manually setting up remove events.
	Licensed under the MIT license, originally built for 0aoq/Fluent
	
	https://github.com/0aoq/Fluent/blob/main/LICENSE
	0a_oq, 10/07/21; last updated: 10/07/21
]]

local RunService = game:GetService("RunService")

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

	-- handle events
	lib.CreateEvent = function(config: EventConfig) 
		-- create an event, and configure the event.Remote function to handle client events
		config.Remote = (function()
			local remote = game:GetService("ReplicatedStorage"):FindFirstChild(config.Name)
			if (not remote) then return; end
			remote.OnClientEvent:Connect(function(args)
				config.Action(
					game:GetService("Players").LocalPlayer, 
					args
				); config.hasEvent = true
			end)
		end); events[config.Name] = config 
	end

	lib.RunEvent = function(Name, Player, args)
		-- handle event running
		local e: EventConfig = events[Name]; if (e) then
			if (e.Player) then if (Player.Name ~= e.Player) then return; end; end

			local PLAYER_INSTANCE = game:GetService("Players"):FindFirstChild(Player)
			if (not e.hasEvent) then e.Remote(PLAYER_INSTANCE, args); end

			if (e.Action) then
				if (checkServer()) then
					-- we're on the server, run function with server info
					local remote = game:GetService("ReplicatedStorage"):FindFirstChild(e.Name)
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