local Fluent = require(game.ReplicatedStorage.FluentUi); Fluent.mount(script.Parent)

Fluent.file.create({Name = "Index", Contents = {
    -- doc
    {'<head? parent="&;">', {
        {'<author? parent="^">0a_oq'}
    }};

    -- workspace
    {'<FluentCenter? type="Frame" parent="&;">', {
        {'<FluentButton? type="TextButton">'},
    }}
}})

local file, app, components = Fluent.file.load("Index", script.Parent)

-- create animation runtime
Fluent.Actions.StreamManager.CreateRuntime({
    name = "TweenBackground",
    runtime = {
        Tween = {
            time = 1,
            TweenTable = {BackgroundTransparency = 0.8}
        }
    }
})

-- tween our button
for _,x in pairs(components) do 
    if (x.Name == "FLUENT_COMPONENT:TextButton") then        
        wait(2)
        Fluent.Actions.StreamManager.CreateManager({mount = x, runtime = "TweenBackground", actions = { Tween = true }})
    end
end

repeat wait() until script.Parent
script.Parent = app