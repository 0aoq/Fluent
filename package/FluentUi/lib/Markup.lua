--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================

Primary markup file manager
--]]

local FluentTypes = require(script.Parent.Types)
local state_manager = require(script.Parent.core["<fluent_component>"])

local import = {}; do
	local getTag = function(full, tagName)
		local __ = full:split(tagName .. '="')[2]
		if (__) then return __:split('"')[1]
			else return nil; end
	end
	
	import.file = {}; do
		local files = {}

		import.file.load = function(fileName: string, container)
			local file = files[fileName]; if (not file) then return warn("[Fluent]: File does not exist!"); end

			local pre = nil -- previously rendered component
			local function __(c)
				for _,x: FluentTypes.fluent_file_content in pairs(c) do
					-- split markup tags
					local t = x[1]; local c = t:split("<")[2]
					local after = c:split("?")[2]:sub(1) -- <TagName? value="">

					x.tag = c:split("?")[1] -- <TagName?>
					x.typ = getTag(after, "type") -- <TagName? type="__THIS">
					
					local specialValues = {"&;", "^"} -- special values that won't load from container
					local __par = getTag(after, "parent"); if (not table.find(specialValues, __par)) then 
						x.par = x.par or container[__par] or nil; else 
						x.par = __par or x.par or nil; end

					x.MARKUP_VALUE = x.MARKUP_VALUE or t:split(">")[2] -- <TagName? value="">THIS
					x.con = x.con or x[2]

					-- render component
					if (x.par == "&;") then x.par = container; end
					if (x.par == "^") then x.par = pre; end
					pre = state_manager.components.addComponent({ -- create each component
						componentName = x.tag or "FluentEmpty",
						type = x.typ or "Frame",
						container = x.par or container
					}, x.opt or function() end, x.MARKUP_VALUE or '{"FLUENT_VALUE":"empty_object"}')

					if (x.con) then __(x.con); end -- create components for nested markup
				end
			end; __(file.Contents)
		end

		import.file.create = function(file: FluentTypes.fluent_file) files[file.Name] = file; end
	end
end; return import