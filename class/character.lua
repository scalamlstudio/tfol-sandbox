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
        parts = {{
            bodyType = "dynamic",
            ground = true,
            x = 300,
            y = 100,
            mass = 10,
            shapeType = 0,
            anim = anim,
            w = 16,
            h = 18
        }, {
            bodyType = "dynamic",
            x = 300,
            y = 90,
            shapeType = 1,
            h = 5,
            w = 5,
            effect = {},
            a = 0.1
        }},
        joints = {{
            type = "rope",
            id1 = 1,
            id2 = 2
        }}
    })
    player.mass = 10
    player.speed = 800
    player.jumpForce = 10000
    control = control or Control:new()
    
    function player:groundSpeed()
        return player.speed * player.mass / 2
    end
    function player:airSpeed()
        return player.speed * player.mass / 10
    end

    local lastJump = 0
    function player:control(dt)
        player.parts[2].body:applyForce(0, -100)
        local tx, ty = player.parts[1].body:getLinearVelocity()
        local tx2, ty2 = player.parts[2].body:getLinearVelocity()
        local v = math.sqrt(tx * tx + ty * ty)
        -- panel:add("tmp: " .. tostring(tx) .. " " .. tostring(ty))
        if v > player.speed then -- speed cap
            player.parts[1].body:setLinearVelocity(tx * player.speed / v, ty * player.speed / v)
        end
        if player:grounded() then -- friction
            player.parts[2].body:setLinearVelocity(tx2 * 0.2, ty2 * 0.2)
            player.parts[1].body:setLinearVelocity(tx * 0.6, ty)
        end
        if control:right() then
            if not control:left() then
                player.parts[1].sx = 1
            end
            if player:grounded() then
                player.parts[1].body:applyForce(player:groundSpeed(), -10)
            else
                player.parts[1].body:applyForce(player:airSpeed(), 0)
            end
        end
        if control:left() then
            if not control:right() then
                player.parts[1].sx = -1
            end
            if player:grounded() then
                player.parts[1].body:applyForce(-player:groundSpeed(), -10)
            else
                player.parts[1].body:applyForce(-player:airSpeed(), 0)
            end
        end
        if lastJump > 0 then
            lastJump = lastJump - 1
        end
        if control:jump() and player:grounded() and lastJump == 0 then
            panel:add("jump")
            lastJump = 10
            player.parts[1].body:applyForce(0, -player.jumpForce)
        end
    end

    return player
end

function Character:Rvros(asset, panel, space, control)
    local idleAnim = Animation:new(asset,
        {name = "idle", file = "asset/image/character/rvros-idle-001.png", w = 50, h = 37})
    local runAnim = Animation:new(asset,
        {name = "run", file = "asset/image/character/rvros-run-001.png", w = 50, h = 37})
    local jumpAnim = Animation:new(asset, {
        name = "jump",
        type = "once",
        file = "asset/image/character/rvros-jump-001.png", w = 50, h = 37,
        duration = 0.4
    })
    local player = Object:new(panel, space, {
        name = "Rvros",
        parts = {{
            bodyType = "dynamic",
            ground = true,
            x = 300,
            y = 50,
            mass = 10,
            shapeType = 0,
            anim = idleAnim,
            w = 50,
            h = 37
        }}
    })
    player.mass = 10
    player.speed = 1000
    player.jumpForce = 40000
    control = control or Control:new({type = "keyboard"})
    
    function player:groundSpeed()
        return player.speed * player.mass
    end
    function player:airSpeed()
        return player.speed * player.mass / 10
    end

    local lastJump = 0
    function player:control(dt)
        -- panel:add(player.name .. " control type " .. control.type)
        local tx, ty = player.parts[1].body:getLinearVelocity()
        local v = math.sqrt(tx * tx + ty * ty)
        -- panel:add("tmp: " .. tostring(tx) .. " " .. tostring(ty))
        if v > player.speed then -- speed cap
            player.parts[1].body:setLinearVelocity(tx * player.speed / v, ty * player.speed / v)
        end
        if player:grounded() and lastJump == 0 then -- friction
            player.parts[1].body:setLinearVelocity(tx * 0.6, ty)
        end
        if control:right() and not control:left() then
            player.parts[1].sx = 1
            if player:grounded() and lastJump == 0 then
                if player.parts[1].anim.name ~= "run" then
                    player.parts[1].anim = runAnim
                end
                player.parts[1].body:applyForce(player:groundSpeed(), -10)
            else
                player.parts[1].body:applyForce(player:airSpeed(), 0)
            end
        end
        if control:left() and not control:right() then
            player.parts[1].sx = -1
            if player:grounded() and lastJump == 0 then
                if player.parts[1].anim.name ~= "run" then
                    player.parts[1].anim = runAnim
                end
                player.parts[1].body:applyForce(-player:groundSpeed(), -10)
            else
                player.parts[1].body:applyForce(-player:airSpeed(), 0)
            end
        end
        if not control:right() and not control:left() and player.parts[1].anim.name ~= "idle" then
            if player:grounded() and lastJump == 0 then
                player.parts[1].anim = idleAnim
            -- else
            --     player.parts[1].anim = idleAnim
            end
        end
        if lastJump > 0 then
            lastJump = lastJump - 1
        end
        if control:jump() and player:grounded() and lastJump == 0 then
            -- panel:add("jump")
            player.parts[1].anim = jumpAnim
            lastJump = 10
            player.parts[1].body:applyForce(0, -player.jumpForce)
        end
    end

    return player
end

return Character