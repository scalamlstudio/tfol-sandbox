-- Tile

local Object = require("class/object")

local Tile = {}

function Tile:new(env, config)
    local tile = config or {}
    tile.ts = tile.ts or 10
    tile.w = tile.w or love.graphics.getWidth()
    tile.h = tile.h or love.graphics.getHeight()

    tile.mtw = math.floor(tile.w / tile.ts)
    tile.mth = math.floor(tile.h / tile.ts)

    rockid = tile.tiles[1]
    dirtid = tile.tiles[2]

    -- init matrix
    tile.mt = {}
    for i = 1, tile.mth do
      tile.mt[i] = {}
      for j = 1, tile.mtw do
        tile.mt[i][j] = 0
      end
    end

    -- generation function - START
    for i = 1, tile.mtw do
        tile.mt[1][i] = dirtid
        tile.mt[tile.mth][i] = dirtid
    end
    for i = math.floor(tile.mth / 2), tile.mth do
        for j = 1, tile.mtw do
            tile.mt[i][j] = dirtid
        end
    end
    for i = 1, tile.mth do
        -- tile.mt[i][i] = rockid
        tile.mt[i][tile.mtw - i + 1] = rockid
        tile.mt[i][1] = rockid
        tile.mt[i][tile.mtw] = rockid
    end
    -- generation function - END

    tile.objects = {}
    for i = 1, tile.mth do
        for j = 1, tile.mtw do
            if tile.mt[i][j] ~= 0 then
                table.insert(tile.objects, Object:new(env, {
                    type = "tile",
                    tileid = #tile.objects + 1,
                    tilei = i,
                    tilej = j,
                    parts = {{
                        shapeType = 4,
                        s = 2,
                        x = (j - 1) * tile.ts + tile.ts / 2,
                        y = (i - 1) * tile.ts + tile.ts / 2,
                        h = tile.ts,
                        w = tile.ts
                    }}
                }))
            end
        end
    end

    function tile:destroy(id)
        local tmptile = tile.objects[id]
        tmptile.parts[1].body:setActive(false)
        tmptile.parts[1].body:release()
        tmptile.parts[1].fixture:release()
        tile.mt[tmptile.tilei][tmptile.tilej] = 0
        table.remove(tile.objects, id)
    end

    function tile:findTouchDirection(x, y, dx, dy)
        local ti = math.floor(y / tile.ts) + 1
        local tj = math.floor(x / tile.ts) + 1
        while ti > 0 and tj > 0 and
            ti <= tile.mth and tj <= tile.mtw and tile.mt[ti][tj] == 0 do
            ti = ti + dy
            tj = tj + dx
        end
        if dx < 0 then
            tj = tj + 1
        end
        if dy < 0 then
            ti = ti + 1
        end
        return (tj - 1) * tile.ts, (ti - 1) * tile.ts
    end

    function tile:findLand(x, y, w, f)
        local mlx, mly = tile:findTouchDirection(x, y, 0, f)
        local llx, lly = tile:findTouchDirection(x - w / 2, y, 0, f)
        local rlx, rly = tile:findTouchDirection(x + w / 2, y, 0, f)
        if f < 0 then
            return math.max(mly, lly, rly)
        else
            return math.min(mly, lly, rly)
        end
    end

    function tile:findWall(x, y, h, f)
        local mlx, mly = tile:findTouchDirection(x, y, f, 0)
        local ulx, uly = tile:findTouchDirection(x, y - h / 2, f, 0)
        local dlx, dly = tile:findTouchDirection(x, y + h / 2, f, 0)
        if f < 0 then
            return math.max(mlx, ulx, dlx)
        else
            return math.min(mlx, ulx, dlx)
        end
    end

    function tile:draw(tileid)
        for i = 1, tile.mth do
            for j = 1, tile.mtw do
                if tile.mt[i][j] == tileid then
                    love.graphics.rectangle('fill', (j - 1) * tile.ts, (i - 1) * tile.ts,
                        tile.ts, tile.ts)
                end
            end
        end
    end

    function tile:drawFunc(tileid)
        local function tileDrawFunc()
            tile:draw(tileid)
        end
        return tileDrawFunc
    end

    return tile
end

return Tile