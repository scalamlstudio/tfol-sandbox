-- Character
local Control = require("general/control")
local Animation = require("general/animation")
local Object = require("class/object")

local Character = {}

function Character:Rvros(env)
    local anims = {{
        idle = Animation:new(env.asset,
            {name = "idle", file = "asset/image/character/rvros-idle-001.png",
            w = 50, h = 37, duration = 1}),
        run_left = Animation:new(env.asset,
            {name = "run", file = "asset/image/character/rvros-run-001.png",
            w = 50, h = 37, duration = 0.5}),
        run_right = Animation:new(env.asset,
            {name = "run", file = "asset/image/character/rvros-run-001.png",
            w = 50, h = 37, duration = 0.5}),
        fall = Animation:new(env.asset,
            {name = "fall", file = "asset/image/character/rvros-fall-001.png",
            w = 50, h = 37, duration = 0.2}),
        jump = Animation:new(env.asset,
            {name = "jump", type = "once", file = "asset/image/character/rvros-jump-001.png",
            w = 50, h = 37, duration = 0.4}),
        attack_1 = Animation:new(env.asset,
            {name = "attack", type = "once", file = "asset/image/character/rvros-attack-001.png",
            w = 50, h = 37, duration = 0.4}),
        cast_spell = Animation:new(env.asset,
            {name = "cast", type = "once", file = "asset/image/character/rvros-cast-001.png",
            w = 50, h = 37, duration = 0.2}),
        hurt = Animation:new(env.asset, 
            {name = "hurt", type = "once", file = "asset/image/character/rvros-hurt-001.png",
            w = 50, h = 37, duration = 0.2}),
        die = Animation:new(env.asset,
            {name = "die", type = "once", file = "asset/image/character/rvros-die-001.png",
            w = 50, h = 37, duration = 0.2}),
        wall_slide = Animation:new(env.asset,
            {name = "wall_slide", file = "asset/image/character/rvros-wall_slide-001.png",
            w = 50, h = 37, duration = 0.5})
    }}
    local player = Object:new(env, {
        name = "Rvros",
        hp = 10,
        parts = {{
            bodyType = "dynamic",
            tileBreaker = true,
            x = 300,
            y = 50,
            mass = 10,
            shapeType = 0,
            anim = anims[1]["idle"],
            w = 30,
            h = 28
        }, {
            bodyType = "static",
            x = 300,
            y = 200,
            shapeType = 1,
            w = 10,
            h = 2
        }}
    })
    player.mass = 10
    player.speed = 500
    player.jumpSpeed = 500
    player.jumpCD = 0.1
    player.state = "idle"
    local control = env.control or Control:new({type = "keyboard"})
    
    local function groundForce()
        return player.speed * player.mass / 1.2
    end
    local function airForce()
        return player.speed * player.mass / 10
    end
    local jumpCD = 0
    local groundCD = 0
    local airCD = 0
    local function canJump()
        return groundCD > 0 and jumpCD == 0
    end
    local function letsJump()
        jumpCD = player.jumpCD
        local tvx, tvy = player.parts[1].body:getLinearVelocity()
        player.parts[1].body:setPosition(
            player.parts[1].body:getX(),
            player.parts[1].body:getY() - 10)
        -- set Velocity is more consistant than applyForce
        player.parts[1].body:setLinearVelocity(tvx, -player.jumpSpeed)
    end
    local function forceRun(force)
        player.parts[1].body:applyForce(force, 0)
        if force > 0 then
            player.parts[1].sx = 1
        elseif force < 0 then
            player.parts[1].sx = -1
        end
    end
    function player:control(dt)
        player.parts[2].body:setPosition(
            player.parts[1].body:getX(),
            env.world.tile:findLand(player.parts[1].body:getX(), player.parts[1].body:getY() + 25) - 1
        )
        -- env.panel:add(player.name .. " control type " .. control.type)
        local tvx, tvy = player.parts[1].body:getLinearVelocity()
        -- env.panel:add("tmp: " .. tostring(tvx) .. " " .. tostring(tvy))
        local v4 = math.pow(tvx * tvx * tvx * tvx + tvy * tvy * tvy * tvy, 0.25)
        if v4 > player.speed then -- speed cap
            player.parts[1].body:setLinearVelocity(tvx * player.speed / v4, tvy * player.speed / v4)
        end
        if jumpCD > 0 then
            jumpCD = jumpCD - dt
        elseif jumpCD < 0 then
            jumpCD = 0
        end
        if player:grounded() then
            groundCD = groundCD + dt
            airCD = 0
        else
            groundCD = 0
            airCD = airCD + dt
        end
        env.panel:add("jumpCD:" .. jumpCD .. "  groundCD:" .. groundCD .. "  airCD:" .. airCD)
        -- FINITE STATE MACHINE --
        if player.state == "idle" then
            if control:jump() and canJump() then
                player.state = "jump"
                letsJump()
            elseif control:attack() then
                player.state = "attack_1"
            elseif control:cast() then
                player.state = "cast_spell"
            elseif control:left() then
                player.state = "run_left"
            elseif control:right() then
                player.state = "run_right"
            else
                player.parts[1].body:setLinearVelocity(tvx * 0.6, tvy)
            end
        elseif player.state == "run_left" then
            if control:jump() and canJump() then
                player.state = "jump"
                letsJump()
            elseif not control:left() then
                player.state = "idle"
            elseif not canJump() and airCD > 0.2 then
                player.state = "fall"
            else
                forceRun(-groundForce())
            end
        elseif player.state == "run_right" then
            if control:jump() and canJump() then
                player.state = "jump"
                letsJump()
            elseif not control:right() then
                player.state = "idle"
            elseif not canJump() and airCD > 0.2 then
                player.state = "fall"
            else
                forceRun(groundForce())
            end
        elseif player.state == "jump" then
            if tvy > 0 then
                player.state = "fall"
            elseif control:left() then
                forceRun(-airForce())
            elseif control:right() then
                forceRun(airForce())
            end
        elseif player.state == "fall" then
            if groundCD > 0 then
                player.state = "idle"
            elseif control:left() then
                forceRun(-airForce())
            elseif control:right() then
                forceRun(airForce())
            end
        elseif player.state == "attack_1" then
            if player.parts[1].anim:ended() then
                player.parts[1].anim:refresh()
                player.state = "idle"
            else
                player.parts[1].body:setLinearVelocity(tvx * 0.6, tvy * 0.8)
            end
        elseif player.state == "cast_spell" then
            if player.parts[1].anim:ended() then
                player.parts[1].anim:refresh()
                player.state = "idle"
            else
                player.parts[1].body:setLinearVelocity(tvx * 0.6, tvy * 0.8)
            end
        elseif player.state == "hurt" then
            if player.parts[1].anim:ended() then
                player.parts[1].anim:refresh()
                player.state = "idle"
            else
                player.parts[1].body:setLinearVelocity(tvx * 0.6, tvy * 0.8)
            end
        elseif player.state == "die" then
            if player.parts[1].anim:ended() then
                player.parts[1].anim:refresh()
                player.state = "idle"
            else
                player.parts[1].body:setLinearVelocity(0, 0)
            end
        end

        if anims[1][player.state] then
            player.parts[1].anim = anims[1][player.state]
        end
    end

    function player:getX()
        return player.parts[1].body:getX()
    end
    function player:getY()
        return player.parts[1].body:getY()
    end

    return player
end

function Character:OldHero(env)
    local anim = Animation:new(env.asset,
        {file = "asset/image/character/oldHero.png", w = 16, h = 18})
    local player = Object:new(env, {
        name = "oldHero",
        parts = {{
            bodyType = "dynamic",
            tileBreaker = true,
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

    return player
end

return Character