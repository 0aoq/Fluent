local Fluent = require(game.ReplicatedStorage.FluentUi); Fluent.mount(script.Parent)

local clicked = 0
Fluent.createComponent({
	Name = "MyButton",
	Styles = {
		-- can be shortened to 4 lines of styles, and 1 function
		Background = Color3.fromRGB(3, 146, 255);
		BoxShadow = true;
		
		Color = Color3.fromRGB(255, 255, 255);
		BorderRadius = 0.2;
		
		sizeX = 0.1;
		sizeY = 0.03;
		
		FontFamily = Enum.Font.Ubuntu;
		ScaledFont = true;
		
		Content = "Clicked: 0";
		
		active = function(self)
			clicked = clicked + 1
			print("Button Clicked! Total: " .. clicked)
			self.Text = "Clicked: " .. clicked
		end,
	}
})

Fluent.file.create({Name = "Index", Contents = {
	-- doc
	{tag = ("<head>"), par = (script.Parent), con = {
		{tag = "<author>", par = ("^"), MARKUP_VALUE = ("0a_oq")}
	}};
	
	-- workspace
	{tag = ("FluentCenter"), typ = ("Frame"), par = (script.Parent), con = ({ -- center our button with the built in class
		{tag = ("MyButton"), typ = ("TextButton"), par = ("^")} -- create our button, and parent it to the previous item
	})}
}}); Fluent.file.load("Index")