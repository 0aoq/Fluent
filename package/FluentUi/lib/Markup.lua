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
	import.file = {}; do
		local files = {}

		import.file.load = function(fileName: string)
			local file = files[fileName]; if (not file) then return warn("[Fluent]: File does not exist!"); end

			local pre = nil -- previously rendered component
			local function __(c)
				for _,x: FluentTypes.fluent_file_content in pairs(c) do
					if (x.par == "^") then x.par = pre; end
					pre = state_manager.components.addComponent({ -- create each component
						componentName = x.tag or "FluentEmpty",
						type = x.typ or "Frame",
						container = x.par or nil
					}, x.opt or function() end, x.MARKUP_VALUE or '{"FLUENT_VALUE":"empty_object"}')

					if (x.con) then __(x.con); end -- create components for nested markup
				end
			end; __(file.Contents)
		end

		import.file.create = function(file: FluentTypes.fluent_file) files[file.Name] = file; end
	end
end; return import