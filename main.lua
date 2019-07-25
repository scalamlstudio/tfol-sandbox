local Asset = require("general/asset")
local Control = require("general/control")
local Animation = require("general/animation")

local World = require("class/world")
local Panel = require("class/panel")
local Object = require("class/object")

local Characters = require("content/characters")

local StartTime = love.timer.getTime()

function love.load()
    love.window.setTitle("TEST")
    love.graphics.setBackgroundColor(0, 0, 0)
    characters = {}
    objects = {}
    characters[1] = Characters:OldHero(Asset)
    world = World:new(Asset, characters, objects)
    panel = Panel:new("Time: 0", 10, 10)
end

function love.update(dt)
    panel:update("Time: " .. tostring(math.floor(love.timer.getTime() - StartTime)))
    world:update(panel, dt)
    Asset:update(panel)
end

function love.draw()
    world:draw(panel)
    panel:draw()
end
