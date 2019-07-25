local Panel = {}

function Panel:new(text, x, y)
    panel = {}

    panel.width = love.graphics.getWidth()
    panel.height = love.graphics.getHeight()

    panel.text = text
    panel.x = x
    panel.y = y

    function panel:update(newText)
        panel.text = newText
    end

    function panel:add(newText)
        panel.text = panel.text .."\n" .. newText
    end

    function panel:draw()
        love.graphics.print(panel.text, panel.x, panel.y)
    end

    return panel
end

return Panel