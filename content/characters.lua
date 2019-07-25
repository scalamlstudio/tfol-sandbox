-- Characters
local Control = require("general/control")
local Physics = require("general/physics")
local Animation = require("general/animation")
local Character = require("class/character")

local Characters = {}

function Characters:OldHero(asset)
    local control = Control:new({type = 1})
    local physics = Physics:new({type = 1, gravity = 5000})
    local anim = Animation:new(asset,
        {file = "asset/image/character/oldHero.png", w = 16, h = 18})
    local player = Character:new(asset, anim,
        {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2, w = 16, h = 18})
    
    function player:update(panel, dt)
        if control:right() then
            player.face = 1
            player.x = player.x + (player.speed * dt)
        end
        if control:left() then
            player.face = -1
            player.x = player.x - (player.speed * dt)
        end
        if control:jump() and player.y == player.ground then
            player.y_velocity = player.jump_height
        end

        physics:update(player, dt)

        player.currentTime = player.currentTime + dt
        if player.currentTime >= player.duration then
            player.currentTime = player.currentTime - player.duration
        end

        player.anim.i = math.floor(player.currentTime / player.duration * #player.anim.quads) + 1
    end

    return player
end

return Characters