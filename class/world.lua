local World = {}

function World:new()
    world = {}

    world.width = love.graphics.getWidth()
    world.height = love.graphics.getHeight()

    world.x = 0
    world.y = 0

    world.bs = 10          -- block size
    world.mt = {}          -- create the matrix
    world.mth = math.floor(world.height / world.bs)
    world.mtw = math.floor(world.width / world.bs)
    for i = 0, world.mth do
      world.mt[i] = {}     -- create a new row
      for j = 0, world.mtw do
        world.mt[i][j] = 0
      end
    end

    for i = 0, math.floor(world.height / world.bs) do
        world.mt[i][i] = 1
        world.mt[i][world.mtw - i] = 1
    end

    local function mttype(mtt)
        for i = 0, world.mth do
            for j = 0, world.mtw do
                local t = world.mt[i][j]
                if t == mtt then
                    love.graphics.rectangle('fill', j * world.bs, i * world.bs, world.bs, world.bs)
                end
            end
        end
    end

    local tbg01 = love.graphics.newImage("asset/tbg01.png")
    local function rocks()
        mttype(1)
    end

    local tbg02 = love.graphics.newImage("asset/tbg02.jpg")
    local function woods()
        mttype(0)
    end

    function world:draw()
        -- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
        love.graphics.stencil(rocks, "replace", 1)
        -- love.graphics.stencil(woods, "replace", 0)
        -- Only allow rendering on pixels which have a stencil value greater than 0.
        love.graphics.setStencilTest("equal", 1)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tbg01, 0, 0, 0, 1, 1)
        love.graphics.setStencilTest("equal", 0)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tbg02, 0, 0, 0, 1, 1)
        love.graphics.setStencilTest()
    end

    return world
end

return World