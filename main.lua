local Asset = require("general/asset")
local Camera = require("general/camera")
local Control = require("general/control")
local Animation = require("general/animation")

local World = require("class/world")
local Panel = require("class/panel")
local Object = require("class/object")

local Character = require("class/character")

local StartTime = love.timer.getTime()

function love.load()
    love.window.setTitle("TEST")
    -- love.window.setFullscreen(true)

    love.graphics.setBackgroundColor(0, 0, 0)

    panel = Panel:new("Time: 0", 10, 10)
    space = love.physics.newWorld(0, 1500, true)

    world = World:new(Asset, panel, space)
    control = Control:new({type = "keyboard"})
    player = Character:Rvros(Asset, panel, space, control)
    npc = Character:OldHero(Asset, panel, space)
    table.insert(world.objects, player)
    table.insert(world.objects, npc)
    table.insert(world.objects, Object:new(panel, space, {
        name = "TestBlock",
        parts = {{
            x = 300,
            y = 400,
            shapeType = 1,
            h = 256,
            w = 256,
            effect = {},
            a = 0.1,
            image = Asset:getImage("asset/image/background/1.png")
        }}
    }))
end

function love.update(dt)
    local width, height = love.window.getDesktopDimensions()
    panel:update("Time:" .. tostring(math.floor(love.timer.getTime() - StartTime)))
    panel:add("Window - W:" .. width .. "  H:" .. height)
    panel:add("Player - X:" .. tostring(player:getX()) ..
        "  Y:" .. tostring(player:getY()))
    -- panel:add("Main Control: " .. control.type)
    Camera:follow(world, player) -- before others
    world:update(dt)
    Asset:update(panel)
end

function love.draw()
    Camera:set()
    world:draw()
    Camera:unset()
    panel:draw()
end
