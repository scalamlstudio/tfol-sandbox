local World = {}

function World:new(asset, players, objects)
    world = {}

    world.width = love.graphics.getWidth()
    world.height = love.graphics.getHeight()

    world.x = 0
    world.y = 0

    world.bs = 10          -- block size
    world.mt = {}          -- create the matrix
    world.mth = math.floor(world.height / world.bs)
    world.mtw = math.floor(world.width / world.bs)

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
                    love.graphics.rectangle('fill', (j - 1) * world.bs, (i - 1) * world.bs, world.bs, world.bs)
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
        for i = 1, #players do
            players[i]:update(panel, dt)
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
        for i = 1, #players do
            players[i]:draw(panel)
        end
    end

    return world
end

return World