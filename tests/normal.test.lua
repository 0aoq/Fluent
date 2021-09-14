--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================
--]]

local Fluent = require(game.ReplicatedStorage.FluentUi)
Fluent.mount(script.Parent)

-- ## render components

Fluent.client.components.addComponent({
    componentName = "FluentButton",
    type = "TextButton",
    container = script.Parent
})