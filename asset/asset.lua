local Asset = {}

local assetImageQueue = {} -- load image when used
local assetImageTime = {} -- drop image when expired

function Asset:loadImage(file)
    if ~assetImageQueue[file] then
        assetImageQueue[file] = love.graphics.newImage(asset)
    end
    return assetImageQueue[file]
end

function Asset:Expired()
    
end

return Asset