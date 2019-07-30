-- Tile

local Object = require("class/object")

local Tile = {}

function Tile:new(panel, space, config)
    local tile = config or {}
    tile.ts = tile.ts or 10
    tile.w = tile.w or love.graphics.getWidth()
    tile.h = tile.h or love.graphics.getHeight()

    tile.mtw = math.floor(tile.w / tile.ts)
    tile.mth = math.floor(tile.h / tile.ts)

    rockid = tile.tiles[1]
    dirtid = tile.tiles[2]

    tile.mt = {}
    for i = 1, tile.mth do
      tile.mt[i] = {}
      for j = 1, tile.mtw do
        tile.mt[i][j] = 0
      end
    end

    for i = 1, tile.mth do
        tile.mt[i][i] = rockid
        tile.mt[i][tile.mtw - i + 1] = rockid
        tile.mt[i][1] = dirtid
        tile.mt[i][tile.mtw] = dirtid
    end
    for i = 1, tile.mtw do
        tile.mt[1][i] = dirtid
        tile.mt[tile.mth][i] = dirtid
    end

    local objects = {}
    for i = 1, tile.mth do
        for j = 1, tile.mtw do
            if tile.mt[i][j] ~= 0 then
                table.insert(objects, Object:new(panel, space, {
                    h = tile.ts,
                    w = tile.ts,
                    x = (j - 1) * tile.ts + tile.ts / 2,
                    y = (i - 1) * tile.ts + tile.ts / 2
                }))
            end
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

    return tile, objects
end

return Tile