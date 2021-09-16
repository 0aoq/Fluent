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
	{'<head? parent="&;">', {
		{'<author? parent="^">0a_oq'}
	}};

    -- workspace
	{'<FluentCenter? type="Frame" parent="&;">', {
		{'<FluentButton? type="TextButton" parent="^">'}
	}}
}}); Fluent.file.load("Index", script.Parent)