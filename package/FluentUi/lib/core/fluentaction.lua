--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================

Action state manager.
--]]

local Http = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local FluentTypes = require(script.Parent.Parent.Types)
local console = require(script.Parent.Parent.packages.log)

local lib = {}; do
    lib.StreamManager = {}; do
        local streams = {}
        lib.StreamManager.CreateRuntime = function(i: FluentTypes.fluent_new_action_mount)
            streams[i.name] = i.runtime
        end

        lib.StreamManager.CreateManager = function(i: FluentTypes.fluent_new_action_manager)
            local m = streams[i.runtime]
            if (m) then
                i.mount:SetAttribute("FLUENT_STREAM_RUNTIME", Http:JSONEncode(
                    {LastUpdated = os.time(), Runtime = i.runtime})
                )

                -- HANDLE ACTIONS

                if (i.actions.Tween) then
                    local _state: FluentTypes.C_TweenService = m.Tween

                    TweenService:Create(i.mount, TweenInfo.new(
                        _state.time, 
                        _state.style or Enum.EasingStyle.Quint,
                        _state.direction or Enum.EasingDirection.InOut), 
                        _state.TweenTable
                    ):Play()
                end

                -- END HANDLE ACTIONS
            else console.warn("Failed to run action stream: Runtime doesn't exist.", script); end
        end
    end
end; return lib