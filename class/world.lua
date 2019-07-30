local Tile = require("class/tile")
local Object = require("class/object")

local World = {}

function World:new(asset, panel, space, config)
    world = config or {}
    world.w = world.w or love.graphics.getWidth()
    world.h = world.h or love.graphics.getHeight()

    local rockid = 1
    local dirtid = 2
    local tiles = {rockid, dirtid}

    world.tile, world.objects = Tile:new(panel, space, {
        ts = 10,
        w = world.w,
        h = world.h,
        tiles = tiles
    })

    function world:update(dt)
        space:update(dt)
        for i = 1, #world.objects do
            world.objects[i]:control(dt) -- Sync Objects Positions if needed
            world.objects[i]:update(dt)
        end
    end

    function world:draw()
        -- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1.
        for i = 1, #tiles do
            local tileid = tiles[i]
            love.graphics.stencil(world.tile:drawFunc(tileid), "replace", tileid, true) -- false: the rest be 0, true: keep origin
            love.graphics.setStencilTest("equal", tileid)
            love.graphics.setColor(1, 1, 1)
            local bg = asset:getImage("asset/image/background/" .. tostring(tileid) .. ".png")
            love.graphics.draw(bg, 0, 0, 0, 4, 3)
        end
        -- close stencil
        love.graphics.setStencilTest()

        -- objects
        for i = 1, #world.objects do
            world.objects[i]:draw()
        end
    end

    return world
end

return World