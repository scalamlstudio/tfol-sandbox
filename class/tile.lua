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
    for i = tile.mth / 2, tile.mth do
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

    local objects = {}
    for i = 1, tile.mth do
        for j = 1, tile.mtw do
            if tile.mt[i][j] ~= 0 then
                table.insert(objects, Object:new(env, {
                    type = "tile",
                    parts = {{
                        x = (j - 1) * tile.ts + tile.ts / 2,
                        y = (i - 1) * tile.ts + tile.ts / 2,
                        h = tile.ts,
                        w = tile.ts
                    }}
                }))
            end
        end
    end
    -- for i = 1, tile.mth do
    --     local tmpj = 1
    --     local tmpt = tile.mt[i][1]
    --     for j = 1, tile.mtw do
    --         if tile.mt[i][j] ~= tmpt then
    --             if tmpt ~= 0 then
    --                 table.insert(objects, Object:new(env, {
    --                     parts = {{
    --                         y = (i - 1) * tile.ts + tile.ts / 2,
    --                         x = (tmpj - 1) * tile.ts + tile.ts * (j - tmpj) / 2,
    --                         h = tile.ts,
    --                         w = tile.ts * (j - tmpj)
    --                     }}
    --                 }))
    --             end
    --             tmpj = j
    --             tmpt = tile.mt[i][j]
    --         end
    --     end
    --     if tmpt ~= 0 then
    --         table.insert(objects, Object:new(env, {
    --             parts = {{
    --                 y = (i - 1) * tile.ts + tile.ts / 2,
    --                 x = (tmpj - 1) * tile.ts + tile.ts * (tile.mtw - tmpj + 1) / 2,
    --                 h = tile.ts,
    --                 w = tile.ts * (tile.mtw - tmpj + 1)
    --             }}
    --         }))
    --     end
    -- end

    function tile:findLand(x, y)
        local ti = math.floor(y / tile.ts) + 1
        local tj = math.floor(x / tile.ts) + 1
        while ti > 0 and tj > 0 and
            ti <= tile.mth and tj <= tile.mtw and tile.mt[ti][tj] == 0 do
            ti = ti + 1
        end
        return (ti - 1) * tile.ts
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

    return tile, objects
end

return Tile