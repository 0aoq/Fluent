--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================

TextBox syntax highlighting
--]]

local colors = {
    keyword = "249, 126, 114",
    __function = "114, 241, 184",
    operator = "109, 119, 179",
    boolean = "255, 245, 246"
}

local languages = {}; do
    languages.lua = {
        { word = "local", color = colors.keyword },
        { word = "function", color = colors.keyword },
        { word = "end", color = colors.keyword },
        { word = "return", color = colors.keyword },
        { word = "for", color = colors.keyword },
        { word = "do", color = colors.keyword },

        { word = "script", color = colors.__function },
        { word = "Parent", color = colors.__function },
        { word = "wait", color = colors.__function },
        { word = "print", color = colors.__function },

        { word = "true", color = colors.boolean },
        { word = "false", color = colors.boolean },
    }
end

local lib = {}; do
    lib.token = {
        PLUS = '+',
        MINUS = '-',
        MULTI = '*',
        DIV = '/'
    }

    function lib.colorize(box, dictionary)
        if (typeof(dictionary) == "string") then dictionary = languages[dictionary]; end
        for _,v in pairs(dictionary) do
            box.Text = string.gsub(box.Text, v.word, '<b><font color="rgb(' .. v.color .. ')">' .. v.word .. '</font></b>')
        end

        local con1, con2;
        con1 = box.Focused:Connect(function()
            box.Text = box.Text:gsub("<br%s*/>", "\n")
            return (box.Text:gsub("<[^<>]->", ""))
        end)

        con2 = box.FocusLost:Connect(function()
            con1:Disconnect(); con2:Disconnect(); lib.colorize(box, dictionary)
        end)

        return box.Text
    end
end; return lib