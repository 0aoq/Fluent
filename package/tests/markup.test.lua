-- Basic FluentUi markup template

--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================
--]]

local Fluent = require(game.ReplicatedStorage.FluentUi); Fluent.mount(script.Parent)
Fluent.file.create({Name = "Index", Contents = {
    -- doc
    {tag = ("<head>"), par = script.Parent, con = {
        {tag = ("<author>"), par = ("^"), MARKUP_VALUE = ("0a_oq")}
    }};

    -- workspace
    {tag = ("FluentButton"), typ = ("TextButton"), par = (script.Parent)}
}}); Fluent.file.load("Index")