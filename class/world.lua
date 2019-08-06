local Tile = require("class/tile")

local World = {}

function World:new(env, config)
    world = config or {}
    world.w = world.w or love.graphics.getWidth()
    world.h = world.h or love.graphics.getHeight()

    local rockid = 1
    local dirtid = 2
    local tiles = {rockid, dirtid}

    world.objects = {}
    world.tile = Tile:new(env, {
        ts = 40,
        w = world.w,
        h = world.h,
        tiles = tiles
    })

    function world:update(dt)
        for i = #world.tile.objects, 1, -1 do
            world.tile.objects[i].active = false
            if love.math.random() < 0.01 and #world.tile.objects > 100 then
                world.tile:destroy(i)
            end
        end
        for i = 1, #world.objects do
            for j = 1, #world.objects[i].parts do
                local part = world.objects[i].parts[j]
                if part.tileBreaker then
                    for ii = 1, #world.tile.objects do
                        local tile = world.tile.objects[ii]
                        if love.physics.getDistance(tile.parts[1].fixture, part.fixture) < 30 then
                            tile.active = true
                        end
                    end
                end
            end
        end
        for i = 1, #world.tile.objects do
            world.tile.objects[i].parts[1].body:setActive(world.tile.objects[i].active)
        end
        env.space:update(dt)
        env.panel:add("World Objects Number: " .. tostring(#world.objects))
        env.panel:add("World Tiles Number: " .. tostring(#world.tile.objects))
        for i = 1, #world.objects do
            world.objects[i]:control(dt) -- Sync Objects Positions if needed
            world.objects[i]:update(dt)
        end
    end

    function world:draw()
        -- draw a rectangle as a stencil. Each pixel touched by the rectangle
        -- will have its stencil value set to 1.
        for i = 1, #tiles do
            local tileid = tiles[i]
             -- false: the rest be 0, true: keep origin
            love.graphics.stencil(world.tile:drawFunc(tileid), "replace", tileid, true)
            love.graphics.setStencilTest("equal", tileid)
            love.graphics.setColor(1, 1, 1)
            local bg = env.asset:getImage("asset/image/background/" .. tostring(tileid) .. ".png")
            love.graphics.draw(bg, 0, 0, 0, 4, 3)
        end
        -- close stencil
        love.graphics.setStencilTest()
        -- objects
        for i = 1, #world.objects do
            world.objects[i]:draw()
        end
        -- tiles
        for i = 1, #world.tile.objects do
            world.tile.objects[i]:draw()
        end
    end

    return world
end

return World