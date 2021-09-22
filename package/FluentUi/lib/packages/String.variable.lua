--[[
	Simplified version of [https://github.com/0aoq/0aInterpreter/blob/main/package/exports/custom/base/val.ts] for Roblox.
	Licensed under the MIT license, originally built for 0aoq/Fluent
	
	https://github.com/0aoq/Fluent/blob/main/LICENSE
	0a_oq, 09/22/21; last updated: 09/22/21
]]

local package = {}; do
	-- types
	
	export type config = {
		openVar: string,
		closeVar: string
	}
	
	export type variable = {
		name: string,
		value: string,
	}
	
	-- storage location for all variables and values
	local variables, i = {}, 0
	
	-- create settings variable
	local settings: config; package.settings = {
		-- default settings
		openVar = "[",
		closeVar = "]"
	}; settings = package.settings
	
	-- main functions
	local splitVariable = function(str: any)
		if (typeof(str) ~= "string") then return end
		local __ = str:split(package.settings.openVar)[1]; if (__) then 
			return variables[__:split(package.settings.closeVar)[0]] or nil else
			return nil
		end
	end
	
	package.actions = {}; do
		package.actions.createVariable = function(var: variable) variables[var.name] = var;
			i = i + 1; script:SetAttribute("VariableCount", i); end
		
		package.actions.parseVariables = function(str: string)
			for _,x in pairs(str:split(" ")) do
				local var: variable = splitVariable(x)
				if (var) then
					-- replace all variables with their values
					str = str:gsub(settings.openVar .. var.name .. settings.closeVar, var.value)
				end; return str
			end
		end
	end
end; return package
