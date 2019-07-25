-- Animation

local Animation = {}

function Animation:new(asset, config)
    anim = {}
    local image = asset:getImage(config.file)
    anim.spriteSheet = image
    anim.quads = {}
    anim.i = 1

    for y = 0, image:getHeight() - config.h, config.h do
        for x = 0, image:getWidth() - config.w, config.w do
            table.insert(anim.quads,
                love.graphics.newQuad(x, y, config.w, config.h, image:getDimensions()))
        end
    end

    function anim:draw(x, y, sx, sy, ox, oy, r, g, b)
        love.graphics.setColor(r or 1, g or 1, b or 1)
        love.graphics.draw(anim.spriteSheet, anim.quads[anim.i], x, y, 0, sx, sy, ox, oy)
    end

    return anim
end

return Animation