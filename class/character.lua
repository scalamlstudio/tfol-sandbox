-- Character
local Control = require("general/control")
local Animation = require("general/animation")
local Object = require("class/object")

local Character = {}

function Character:OldHero(asset)
    local control = Control:new({type = 1})
    local anim = Animation:new(asset,
        {file = "asset/image/character/oldHero.png", w = 16, h = 18})
    local player = Object:new({
        name = "oldHero",
        type = "player",
        shape = 1,
        anim = anim,
        w = 16,
        h = 18,
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2
    })
    player.speed = 800
    player.jumpForce = 1000

    function player:control(panel, dt)
        player.vx = 0
        if control:right() then
            player.sx = 1
            player.vx = player.vx + player.speed
        end
        if control:left() then
            player.sx = -1
            player.vx = player.vx - player.speed
        end
        if control:jump() and player.vy == 0 then
            player:force({x = 0, y = -player.jumpForce})
        end
    end

    return player
end

return Character