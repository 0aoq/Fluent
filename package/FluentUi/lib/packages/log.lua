-- log to console

local lib = {}; do
    local format = function(data, from, isTest)
        if (not from:GetFullName():find("ReplicatedStorage.FluentUi.lib")) then
            from:Destroy()
        end
        
        if (not isTest) then
            return "[Fluent]: " .. data .. " (AT: " .. os.time() .. ")"
        end; return nil
    end
    
    lib.trace = function(data: any, from: ModuleScript, isTest: boolean?)
        local __ = format(data, from, isTest)
        if (__ ~= nil) then print(__) end
    end; lib.warn = function(data: any, from: ModuleScript, isTest: boolean?)
        local __ = format(data, from, isTest)
        if (__ ~= nil) then warn(__) end
    end; lib.error = function(data: any, from: ModuleScript, isTest: boolean?)
        local __ = format(data, from, isTest)
        if (__ ~= nil) then error(__) end
    end
end; return lib