local Asset = {}

local assetImageQueue = {} -- load image when used
local assetImageTime = {} -- drop image when expired
local assetAudioQueue = {} -- load audio when used
local assetAudioTime = {} -- drop audio when expired
local defaultImage = love.graphics.newImage("asset/image/background/0.png")
local defaultAudio = nil -- love.audio.newSource("asset/audio/bgm/0.mp3")

function Asset:getImage(file)
    if file ~= nil then
        if assetImageQueue[file] ~= nil then
        else
            assetImageQueue[file] = love.graphics.newImage(file)
        end
        assetImageTime[file] = love.timer.getTime()
        return assetImageQueue[file]
    else
        return defaultImage
    end
end

function Asset:getAudio(file)
    if file ~= nil then
        if assetAudioQueue[file] ~= nil then
        else
            assetAudioQueue[file] = love.audio.newSource(file)
        end
        assetAudioTime[file] = love.timer.getTime()
        return assetAudioQueue[file]
    else
        return defaultAudio
    end
end

function Asset:update(panel)
    for file, time in pairs(assetImageTime) do
        if love.timer.getTime() - time > 60 then
            panel:add("expire image: " .. file)
            assetImageQueue[file] = nil
            assetImageTime[file] = nil
        end
    end
    for file, time in pairs(assetAudioTime) do
        if love.timer.getTime() - time > 60 then
            panel:add("expire audio: " .. file)
            assetAudioQueue[file] = nil
            assetAudioTime[file] = nil
        end
    end
end

return Asset