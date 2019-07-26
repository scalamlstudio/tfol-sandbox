-- Animation

local Animation = {}

function Animation:new(asset, config)
    local anim = config
    anim.image = asset:getImage(config.file)
    anim.quads = {}
    anim.i = 1
    anim.duration = anim.duration or 1
    anim.currentTime = 0

    for y = 0, anim.image:getHeight() - anim.h, anim.h do
        for x = 0, anim.image:getWidth() - anim.w, anim.w do
            table.insert(anim.quads,
                love.graphics.newQuad(x, y, anim.w, anim.h, anim.image:getDimensions()))
        end
    end

    function anim:update(dt)
        anim.currentTime = anim.currentTime + dt
        if anim.currentTime >= anim.duration then
            anim.currentTime = anim.currentTime - anim.duration
        end
        anim.i = math.floor(anim.currentTime / anim.duration * #anim.quads) + 1
    end

    function anim:draw(x, y, d, sx, sy, ox, oy, r, g, b)
        love.graphics.setColor(r or 1, g or 1, b or 1)
        love.graphics.draw(anim.image, anim.quads[anim.i], x, y, d, sx, sy, ox, oy)
    end

    return anim
end

return Animation