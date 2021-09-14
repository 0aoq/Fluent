--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================
--]]

local FluentTypes = require(script.lib.Types)
local internal = require(script.lib.core["<fluent>"])
local components = require(script.lib.core["<fluent_component>"])
local markup = require(script.lib.Markup)

local _0aoq_fluent = {}; do
    _G.FluentUi = {
        name = "FluentUi",
        author = "0a_oq"
    }

    -- module
    local util = {}; do
        util.PrintLines = function(lines: {string}) for _,x in pairs(lines) do print(x); end end
    end

    util.PrintLines({
        "===== 0aoq/FluentUi =====",
        "Render stream started!   ",
        "Components registered!   ",
        "===== 0aoq/FluentUi ====="
    })

    _0aoq_fluent.client = {}; do
        _0aoq_fluent.mount = function(container, styles) 
            styles = styles or {}
			internal.scanContainer(container, styles, false)
			container:SetAttribute("FLUENT_RENDER_STATE", true)
        end

        -- @function Returns a table of all elements that match a className
        _0aoq_fluent.getElementsByClassName = function(container, className)
            if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end
            local elements = {}

            for _,component in pairs(container:GetDescendants()) do
                if component:GetAttribute("FLUENT_UI_CLASS") == className then
                    table.insert(elements, 1, component)
                end
            end

            return elements
        end

        -- @function Get the element that is the specific number in the list
        _0aoq_fluent.nthChild = function(container, className, x, style)
            if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end
            for i,v in pairs(_0aoq_fluent.getElementsByClassName(container, className)) do
                if (i == x) then
                    internal.styleComponent(v, style)
                    v:SetAttribute("FLUENT_UI_CLASS", v:GetAttribute("FLUENT_UI_CLASS") .. i)
                end
            end
        end
    end

    _0aoq_fluent.client.test = function()
        local function ENCODE(json) return game:GetService("HttpService"):JSONEncode(json) end
        return ENCODE(internal.styleSheet), ENCODE(internal.components)
    end

    -- /// START SECTION: Markup

    _0aoq_fluent.file = {}; do
		_0aoq_fluent.file.load = function(fileName: string) return markup.file.load(fileName) end
		_0aoq_fluent.file.create = function(file: FluentTypes.fluent_file) return markup.file.create(file); end
    end

    -- /// END SECTION: Markup
end; return _0aoq_fluent