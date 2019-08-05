-- Animation

local Animation = {}

function Animation:new(asset, config)
    local anim = config
    local image = asset:getImage(config.file)
    anim.name = anim.name or config.file
    anim.type = anim.type or "loop"
    anim.quads = {}
    anim.i = 1
    anim.duration = anim.duration or 1
    anim.currentTime = 0

    for y = 0, image:getHeight() - anim.h, anim.h do
        for x = 0, image:getWidth() - anim.w, anim.w do
            table.insert(anim.quads,
                love.graphics.newQuad(x, y, anim.w, anim.h, image:getDimensions()))
        end
    end

    function anim:update(dt)
        anim.currentTime = anim.currentTime + dt
        if anim.type == "loop" then
            if anim.currentTime >= anim.duration then
                anim.currentTime = anim.currentTime - anim.duration
            end
            anim.i = math.floor(anim.currentTime / anim.duration * #anim.quads) + 1
        elseif anim.type == "once" then
            anim.i = math.min(#anim.quads, math.floor(anim.currentTime / anim.duration * #anim.quads) + 1)
        end
    end

    function anim:ended()
        return anim.type == "once" and math.floor(anim.currentTime / anim.duration * #anim.quads) > #anim.quads
    end
    function anim:refresh()
        anim.currentTime = 0
    end

    function anim:draw(x, y, d, sx, sy, ox, oy, r, g, b, a)
        love.graphics.setColor(r or 1, g or 1, b or 1, a or 1)
        love.graphics.draw(asset:getImage(config.file), anim.quads[anim.i], x, y, d, sx, sy, ox, oy)
    end

    return anim
end

return Animation