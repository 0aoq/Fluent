local TweenService = game:GetService("TweenService")

return {
    FluentButton = {
        Background = Color3.fromRGB(255, 255, 255);
        BorderRadius = 0.15;
        BoxShadow = true;
        ScaledFont = true;

        sizeX = 0.15;
        sizeY = 0.03;

        PaddingTop = 0.1;
        PaddingBottom = 0.1;
        PaddingLeft = 0.1;
        PaddingRight = 0.1;

        active = function(self)
            TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.2}):Play()
            wait(0.04); TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
        end,

        onhover = function(self)
            TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
        end, onunhover = function(self)
            TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
        end,
    },
    FluentCenter = {
        Opacity = 1;
        sizeX = 1;
        sizeY = 1;
        isFlex = true;
        alignX = "Center";
        alignY = "Center";
    },
    FluentEmpty = {Opacity = 1},
    TextArea = {
        Background = Color3.fromRGB(255, 255, 255),
        BoxShadow = true;
        BorderRadius = 0.15;
        ScaledFont = true;
        sizeX = 0.25;
        sizeY = 0.15;

        PaddingTop = 0.1;
        PaddingBottom = 0.1;
        PaddingLeft = 0.1;
        PaddingRight = 0.1;

        isCode = true;
        language = "lua";

        instanceType = "TextBox";
    },
    span = { FontFamily = Enum.Font.Ubuntu; ScaledFont = true; sizeX = 0.1; sizeY = 0.1; }
}