--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================
Primary internal script. Responsible for all component styling
--]]

local val = require(script.Parent.Parent.Definitions)
local FluentTypes = require(script.Parent.Parent.Types)
local String = {variable = require(script.Parent.Parent.packages["String.variable"])};
local Syntax = require(script.Parent.Parent.packages.SyntaxHighlighting)

local TweenService = game:GetService("TweenService")
local Http = game:GetService("HttpService")

local internal = {}; do
    internal.renderedContainers = {}
    internal.components = {}

    internal.setMeta = function(__, isContainer: boolean, rendered: boolean, isSpecialInstance: boolean)
        return __:SetAttribute("fluentMeta", game:GetService("HttpService"):JSONEncode({
            renderedAt = os.time(),
            isContainer = isContainer,
            rendered = rendered,
            isSpecialInstance = isSpecialInstance
        }))
    end

    internal.styleSheet = require(script.Parent.Parent.Stylesheet)

    internal.bin = {}; do
        internal.bin.getStyle = function(name: string)
            return internal.styleSheet[name]
        end
    end; local bin = internal.bin

    -- table of all values WITH A FUNCTION TO CALL
    internal.styles = {
        "BorderRadius", "isFlex", "BoxShadow", 
        "Padding", "Border", "isItalic", "isBold"
    }
    internal.markupStyles = {"head", "title", "author"} -- (render folders/string values)

    -- style functions
    internal.styleValues = {}; do
        internal.styleValues.isFlex = function(component, style) -- @fluent_style:isFlex
            style.flexOrder = style.flexOrder or "Name"; style.alignX = style.alignX or "Left"
            style.alignY = style.alignY or "Top"; style.flexPadding = style.flexPadding or 0

            if (not component:FindFirstChild("FLUENT_LIST_LAYOUT")) then
                local UiListLayout = Instance.new("UIListLayout", component)
                UiListLayout.Name = "FLUENT_LIST_LAYOUT"
                UiListLayout.HorizontalAlignment = Enum.HorizontalAlignment[style.alignX]
                UiListLayout.VerticalAlignment = Enum.VerticalAlignment[style.alignY]
                UiListLayout.SortOrder = Enum.SortOrder[style.flexOrder]
                UiListLayout.Padding = UDim.new(style.flexPadding or 0, 0)
                internal.setMeta(UiListLayout, false, true, true)
            end
        end; internal.styleValues.BoxShadow = function(component, style) -- @fluent_style:BoxShadow
            if (component.Parent:FindFirstChild("Fluent_BoxShadow")) then return end

            local frame = Instance.new("Frame", component.Parent)
            component.Parent = frame
            frame.Name = component.Name
            frame.Size = component.Size
            frame.Position = component.Position
            frame.BackgroundTransparency = 1

            frame:SetAttribute("fluent_origin_size", frame.Size)
            frame:SetAttribute("fluent_origin_position", frame.Position)

            task.spawn(function()
                for i = 1, 100, 1 do
                    wait(0.01)
                    component.Size = UDim2.new(1, 0, 1, 0)
                    component.Position = UDim2.new(0, 0, 0, 0)
                end
            end)

            local boxshadow = Instance.new("ImageLabel", frame)

            style.boxShadowStyle = style.boxShadowStyle or 1
            if style.boxShadowStyle == 1 then
                boxshadow.Image = "rbxassetid://6919135242"

                if frame.Size.Y.Scale > 0.5 then
                    boxshadow.Size = component.Size + UDim2.new(0.3, 0, 0.4, 0)
                    boxshadow.ImageTransparency = style.boxShadowAlpha or 0
                else -- normal box shadow doesn't look good with objects that are too small
                    boxshadow.Size = component.Size + UDim2.new(0.4, 0, 0.5, 0)
                    boxshadow.ImageTransparency = style.boxShadowAlpha or 0.5
                end

                boxshadow.Position = component.Position + UDim2.new(-0.2, 0, -0.2, 0)
            else
                boxshadow.Image = "rbxassetid://6916236943"

                if frame.Size.Y.Scale > 0.5 then
                    boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.2, 0)
                    boxshadow.ImageTransparency = style.boxShadowAlpha or 0
                else -- normal box shadow doesn't look good with objects that are too small
                    boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.3, 0)
                    boxshadow.ImageTransparency = style.boxShadowAlpha or 0.65
                end

                boxshadow.Position = component.Position + UDim2.new(-0.1, 0, -0.1, 0)
            end

            boxshadow.Name = "Fluent_BoxShadow"
            boxshadow.BackgroundTransparency = 1
            component.ZIndex = component.ZIndex + 1
            boxshadow.ZIndex = component.ZIndex - 1
            frame.ZIndex = component.ZIndex

            internal.setMeta(boxshadow, false, true, true)
            internal.setMeta(frame, true, true, true)
        end; internal.styleValues.BorderRadius = function(component, style) -- @fluent_style:BorderRadius
            Instance.new("UICorner", component).CornerRadius = UDim.new(style.BorderRadius or 0, 0)
        end; internal.styleValues.Padding = function(component, style)
            local tempInstance = Instance.new("UIPadding", component); do
                tempInstance.PaddingTop = UDim.new(style.PaddingTop, 0)
                tempInstance.PaddingBottom = UDim.new(style.PaddingBottom, 0)

                tempInstance.PaddingLeft = UDim.new(style.PaddingLeft, 0)
                tempInstance.PaddingRight = UDim.new(style.PaddingRight, 0)
            end; internal.setMeta(tempInstance, false, true, true)
        end; internal.styleValues.Border = function(component, style)
            local tempInstance = Instance.new("UIStroke", component); do
                style.BorderApplyMode = style.BorderApplyMode or "Contextual"
                style.BorderJoinMode = style.BorderJoinMode or "Round"

                tempInstance.ApplyStrokeMode = Enum.ApplyStrokeMode[style.BorderApplyMode]
                tempInstance.Thickness = style.BorderThickness or 1
                tempInstance.Transparency = style.BorderOpacity or 0
                tempInstance.Color = style.BorderColor or Color3.fromRGB(0, 0, 0)
                tempInstance.LineJoinMode = Enum.LineJoinMode[style.BorderJoinMode]

                tempInstance.Name = "FLUENT_UI_STROKE"
            end; internal.setMeta(tempInstance, false, true, true)
        end

        internal.styleValues.isCode = function(component, style) Syntax.colorize(component, style.language); end

        -- isItalic/isBold
        internal.styleValues.isItalic = function(component, style) 
            component.RichText = true; component.Text = "<i>" .. component.Text .. "</i>"; end
        internal.styleValues.isBold = function(component, style) 
            component.RichText = true; component.Text = "<b>" .. component.Text .. "</b>"; end        
    end

    internal.styleComponent = function(component, style: FluentTypes.fluent_interface, MARKUP_INFO)
        if (style == nil) then return end

        local appliedStyles = component:GetAttribute(val.APPLIED_STYLES)
        if (not appliedStyles) then appliedStyles = '{}'; end
        appliedStyles = Http:JSONDecode(appliedStyles)

        local class = component:GetAttribute(val.CLASS_NAME)
        if (table.find(internal.markupStyles, class)) then
            if (not component:IsA("Folder") and component:IsA("StringValue")) then
                if (component.Value == "") then 
                    component.Value = style.MARKUP_VALUE or '{"FLUENT_VALUE":"empty_object"}'; end
            end; return
        end; if (class == "var") then
            String.variable.actions.createVariable({
                name = MARKUP_INFO[1],
                value = style.MARKUP_VALUE
            })
        end

        -- Styles

        component.BackgroundColor3 = style.Background or component.BackgroundColor3
        component.Position = style.Pos or component.Position
        component.Name = style.Name or component.Name
        component.BackgroundTransparency = style.Opacity or component.BackgroundTransparency
        component.BorderSizePixel = 0

        if (style.sizeX and style.sizeY) then -- set size
            component.Size = UDim2.new(style.sizeX , 0, style.sizeY, 0)
        end

        component.Visible = not style.hidden or not false

        for _,x in pairs(internal.styles) do
            if (style[x] == true or
                typeof(style[x]) == "number")
            then 
                if (not table.find(appliedStyles, x)) then
                    table.insert(appliedStyles, x)
                    internal.styleValues[x](component, style, x) 
                end
            end
        end

        -- @this Handle button specific properties
        if (component:IsA("TextButton")) then
            component.MouseButton1Click:Connect(function()
                if (style.active) then coroutine.wrap(style.active)(component, style); end
            end)

            component.AutoButtonColor = style.autoColor or false
        end

        -- @this Handle text related properties
        style.FontFamily = style.FontFamily or "SourceSans"
        if (component:IsA("TextLabel") or component:IsA("TextButton")) then
            component.RichText = style.isRichText or component.RichText
            component.Text = style.Content or component.Text
            component.TextScaled = style.ScaledFont or component.TextScaled
            component.TextColor3 = style.Color or component.TextColor3

            if (typeof(style.FontFamily) == "string") then
                component.Font = Enum.Font[style.FontFamily]
            else
                component.Font = style.FontFamily
            end
        end

        -- Events

        if (style.onhover) then
            component.MouseEnter:Connect(function()
                coroutine.wrap(style.onhover)(component)
            end)
        end

        if (style.onunhover) then
            component.MouseLeave:Connect(function()
                coroutine.wrap(style.onunhover)(component)
            end)
        end

        if (style.run) then
            coroutine.wrap(style.run)(Instance.new("LocalScript", component), component)
        end

        -- Finish Up
        component:SetAttribute(val.APPLIED_STYLES, Http:JSONEncode(appliedStyles))
    end

    -- scan container for classes
    internal.scanContainer = function(container, styles, isComponent: boolean)
        if (styles ~= internal.styleSheet) then
            -- if (isComponent) then table.insert(internal.styleSheet, 1, styles) end
            table.insert(internal.renderedContainers, 1, container)
        end

        if (container == nil) then return warn("[Fluent]: Components cannot be mounted onto null containers") end
        for _,component in pairs(container:GetDescendants()) do
            if (not component:IsA("LocalScript")) then
                internal.styleComponent(component, bin.getStyle(component:GetAttribute(val.CLASS_NAME)))
            end
        end
    end
end; return internal