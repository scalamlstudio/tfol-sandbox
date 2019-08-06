local Tile = require("class/tile")

local World = {}

function World:new(env, config)
    world = config or {}
    world.w = world.w or love.graphics.getWidth()
    world.h = world.h or love.graphics.getHeight()

    local rockid = 1
    local dirtid = 2
    local tiles = {rockid, dirtid}

    world.tile, world.objects = Tile:new(env, {
        ts = 10,
        w = world.w,
        h = world.h,
        tiles = tiles
    })

    local function easyDist(x1, y1, x2, y2)
        return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    end

    function world:update(dt)
        for i = 1, #world.objects do
            if world.objects[i].type == "tile" then
                for j = 1, #world.objects[i].parts do
                    if world.objects[i].parts[j].bodyType == "static" then
                        world.objects[i].parts[j].active = false
                    end
                end
            end
        end
        for i = 1, #world.objects do
            for j = 1, #world.objects[i].parts do
                local part1 = world.objects[i].parts[j]
                if part1.bodyType ~= "static" then
                    for ii = 1, #world.objects do
                        for jj = 1, #world.objects[ii].parts do
                            if i ~= ii or j ~= jj and
                                world.objects[ii].type == "tile" then
                                local part2 = world.objects[ii].parts[jj]
                                if part2.bodyType == "static" and
                                    easyDist(part2.x, part2.y, part1.body:getX(), part1.body:getY()) < 50 then
                                    part2.active = true
                                end
                            end
                        end
                    end
                end
            end
        end
        for i = 1, #world.objects do
            if world.objects[i].type == "tile" then
                for j = 1, #world.objects[i].parts do
                    if world.objects[i].parts[j].bodyType == "static" then
                        world.objects[i].parts[j].body:setActive(world.objects[i].parts[j].active)
                    end
                end
            end
        end
        env.space:update(dt)
        env.panel:add("World Objects Number: " .. tostring(#world.objects))
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
    end

    return world
end

return World