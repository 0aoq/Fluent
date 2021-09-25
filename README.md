<h1 align="center">🎉 Fluent Ui</h1>

<p align="center">
A simple Roblox UI framework aimed at making easy to use syntax that supports values similar to CSS for advanced styling, with simple syntax.
</p>

Fluent supports an easy to use system for creating components and adding them to GUIs for the player to interact with.<br>
You can define your own components, or use the built in components.

*Using the built in components*
```lua
local Fluent = require(game.ReplicatedStorage.FluentUi); Fluent.mount(script.Parent)
Fluent.file.create({Name = "Index", Contents = {
    -- workspace
	{'<FluentCenter? type="Frame" parent="&;">', {
		{'<FluentButton? type="TextButton">'}
	}}
}}); Fluent.file.load("Index", script.Parent)
```

[Using custom components](https://github.com/0aoq/Fluent/blob/main/tests/custom-button-tutorial.test.lua)