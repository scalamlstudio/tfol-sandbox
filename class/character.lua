-- Character
local Control = require("general/control")
local Animation = require("general/animation")
local Object = require("class/object")

local Character = {}

function Character:OldHero(asset, panel, space, control)
    local anim = Animation:new(asset,
        {file = "asset/image/character/oldHero.png", w = 16, h = 18})
    local player = Object:new(panel, space, {
        name = "oldHero",
        bodyType = "dynamic",
        shapeType = 1,
        anim = anim,
        w = 16,
        h = 18,
        x = 300,
        y = 100,
        mass = 10
    })
    player.speed = 800
    player.jumpForce = 5000
    control = control or Control:new({type = "keyboard"})
    
    function player:groundSpeed()
        return player.speed * player.mass / 2
    end
    function player:airSpeed()
        return player.speed * player.mass / 10
    end

    function player:control(dt)
        local tx, ty = player.body:getLinearVelocity()
        local v = math.sqrt(tx * tx + ty * ty)
        -- panel:add("tmp: " .. tostring(tx) .. " " .. tostring(ty))
        if v > player.speed then -- speed cap
            player.body:setLinearVelocity(tx * player.speed / v, ty * player.speed / v)
        end
        if player:grounded() then -- friction
            player.body:setLinearVelocity(tx * 0.6, ty)
        end
        if control:right() then
            if not control:left() then
                player.sx = 1
            end
            if player:grounded() then
                player.body:applyForce(player:groundSpeed(), 0)
            else
                player.body:applyForce(player:airSpeed(), 0)
            end
        end
        if control:left() then
            if not control:right() then
                player.sx = -1
            end
            if player:grounded() then
                player.body:applyForce(-player:groundSpeed(), 0)
            else
                player.body:applyForce(-player:airSpeed(), 0)
            end
        end
        if control:jump() and player:grounded() then
            panel:add("jump")
            player.body:applyForce(0, -player.jumpForce)
        end
    end

    return player
end

return Character