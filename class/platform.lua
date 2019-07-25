local Platform = {}

function Platform:new()
    platform = {}

    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()

    platform.x = 0
    platform.y = 0 -- platform.height / 2

    function platform:draw()
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
    end

    return platform
end

return Platform