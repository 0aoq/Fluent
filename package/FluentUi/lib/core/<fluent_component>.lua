--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================

Primary component state manager script, handles stylesheet definitions
--]]

local internal = require(script.Parent["<fluent>"])
local FluentTypes = require(script.Parent.Parent.Types)

local import = {}; do
	import.components = {}; do
		import.components.createComponent = function(component: FluentTypes.fluent_component)
			if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end

			for _,x in pairs(internal.renderedContainers) do
				internal.components[component.Name] = component
				internal.styleSheet[component.Name] = component.Styles

				internal.scanContainer(x, internal.styleSheet, true)
			end
		end

		import.components.addComponent = function(
			componentConfig: FluentTypes.fluent_component_config,
			interface_function: any,
			MARKUP_VALUE: string
		)
			if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end

			local name = componentConfig.componentName

			if (name == "head") then 
				componentConfig.type = "Folder"
				componentConfig.name = "<" .. name .. ">"
			elseif (table.find(internal.markupStyles, name)) then 
				componentConfig.type = "StringValue"
				componentConfig.name = "<" .. name .. ">"
			end

			local __ = Instance.new(componentConfig.type, componentConfig.container)
			__.Name = componentConfig.name or "FLUENT_COMPONENT:" .. componentConfig.type
			__:SetAttribute("FLUENT_UI_CLASS", componentConfig.componentName)
			if (interface_function) then interface_function(__); end
			if (__:IsA("StringValue")) then __.Value = MARKUP_VALUE; end

			local style = internal.bin.getStyle(componentConfig.name)
			
			internal.scanContainer(componentConfig.container, style, true)
			internal.styleComponent(__, style)

			internal.setMeta(componentConfig.container, true, true, false)
			internal.setMeta(__, false, true, false)

			return __
		end

		import.components.removeComponent = function(componentName: string)
			for _,x in pairs(internal.components) do
				if (x == componentName) then
					internal.components[x] = nil
				end
			end
		end
	end
end; return import