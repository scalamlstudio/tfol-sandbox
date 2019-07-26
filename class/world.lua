local Physics = require("general/physics")

local World = {}

function World:new(asset, objects, config)
    world = config or {}
    world.w = world.w or love.graphics.getWidth()
    world.h = world.h or love.graphics.getHeight()

    world.physics = world.physics or Physics:new({
        gravity = {x = 0, y = 100},
        w = world.w,
        h = world.h
    })

    world.ts = 10          -- tile size
    world.mt = {}          -- create the matrix
    world.mth = math.floor(world.h / world.ts)
    world.mtw = math.floor(world.w / world.ts)

    for i = 1, world.mth do
      world.mt[i] = {}     -- create a new row
      for j = 1, world.mtw do
        world.mt[i][j] = 0
      end
    end

    local rockid = 1
    local dirtid = 2
    local tiles = {rockid, dirtid}

    for i = 1, world.mth do
        world.mt[i][i] = rockid
        world.mt[i][world.mtw - i + 1] = rockid
        world.mt[i][1] = dirtid
        world.mt[i][world.mtw] = dirtid
    end
    for i = 1, world.mtw do
        world.mt[1][i] = dirtid
        world.mt[world.mth][i] = dirtid
    end

    local function mttype(mtt)
        for i = 1, world.mth do
            for j = 1, world.mtw do
                local t = world.mt[i][j]
                if t == mtt then
                    love.graphics.rectangle('fill', (j - 1) * world.ts, (i - 1) * world.ts, world.ts, world.ts)
                end
            end
        end
    end

    local tbgf = {}
    for i = 1, #tiles do
        local tileid = tiles[i]
        local function tilefunc()
            mttype(tileid)
        end
        tbgf[tileid] = tilefunc
    end

    function world:update(panel, dt)
        world.physics:update(panel, objects, dt)
        for i = 1, #objects do
            objects[i]:control(panel, dt) -- Sync Objects Positions if needed
        end
    end

    function world:draw(panel)
        -- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1.
        for i = 1, #tiles do
            local tileid = tiles[i]
            love.graphics.stencil(tbgf[tileid], "replace", tileid, true) -- false: the rest be 0, true: keep origin
            love.graphics.setStencilTest("equal", tileid)
            love.graphics.setColor(1, 1, 1)
            local bg = asset:getImage("asset/image/background/" .. tostring(tileid) .. ".png")
            love.graphics.draw(bg, 0, 0, 0, 4, 3)
        end
        -- close stencil
        love.graphics.setStencilTest()
        for i = 1, #objects do
            objects[i]:draw(panel)
        end
    end

    return world
end

return World