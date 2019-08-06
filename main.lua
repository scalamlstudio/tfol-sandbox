local Asset = require("general/asset")
local Camera = require("general/camera")
local Control = require("general/control")

local World = require("class/world")
local Panel = require("class/panel")
local Object = require("class/object")

local Character = require("class/character")

local StartTime = math.floor(love.timer.getTime())

function love.load()
    love.window.setTitle("TEST")
    love.graphics.setBackgroundColor(0, 0, 0)
    -- love.window.setFullscreen(true)

    local panel = Panel:new("Time: 0", 10, 10)
    local space = love.physics.newWorld(0, 1500, true)
    local control = Control:new({type = "keyboard"})
    env = {
        asset = Asset,
        camera = Camera,
        panel = panel,
        space = space,
        control = control
    }
    world = World:new(env)
    player = Character:Rvros(env)
    table.insert(world.objects, player)
    env.world = world
    env.player = player
end

function love.update(dt)
    local width, height = love.window.getDesktopDimensions()
    env.panel:update("Time:" .. tostring(math.floor(love.timer.getTime()) - StartTime) ..
        "  FPS:" .. tostring(love.timer.getFPS()))
    env.panel:add("Window - W:" .. width .. "  H:" .. height)
    env.panel:add("Player - X:" .. tostring(player:getX()) ..
        "  Y:" .. tostring(player:getY()))
    Camera:follow(world, player) -- before others
    Camera:update(dt)
    world:update(dt)
    Asset:update(dt)
end

function love.draw()
    Camera:set()
    world:draw()
    Camera:unset()
    env.panel:draw()
end
