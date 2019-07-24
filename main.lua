local World = require("class/world")
local Platform = require("class/platform")
local Player = require("class/player")

function love.load()
    love.window.setTitle("TEST")
    love.graphics.setBackgroundColor(0.4, 0.6, 0.9) -- Sky Blue

    world = World:new()
    platform = Platform:new()
    player = Player:new("asset/oldHero.png", 16, 18, 1)
end

function love.update(dt)
    player:update(love.keyboard.isDown('d'), love.keyboard.isDown('a'), love.keyboard.isDown('space'), dt)
end

function love.draw()
    world:draw()
    platform:draw()
    player:draw()
end
