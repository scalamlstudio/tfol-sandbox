local Asset = require("general/asset")
local Control = require("general/control")
local Animation = require("general/animation")

local World = require("class/world")
local Panel = require("class/panel")
local Object = require("class/object")

local Character = require("class/character")

local StartTime = love.timer.getTime()

function love.load()
    love.window.setTitle("TEST")
    love.graphics.setBackgroundColor(0, 0, 0)
    objects = {}
    objects[1] = Character:OldHero(Asset)
    objects[2] = Object:new({
    	name = "TestBlock",
    	shape = 1,
    	gf = 0,
    	m = 100,
    	h = 100,
    	w = 100,
    	x = 500,
    	y = 500,
    	image = Asset:getImage("asset/image/background/1.png")
    })
    world = World:new(Asset, objects, config)
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
