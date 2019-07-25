local Character = {}

function Character:newPlayer(asset, width, height, duration)
    local player = {}

    local image = love.graphics.newImage(asset)
 
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.width = width
    player.height = height
 
    player.ground = player.y
    player.speed = 800
    player.y_velocity = 0
    player.jump_height = -1000
    player.gravity = -5000

    player.spriteSheet = image
    player.quads = {}
    player.face = 1

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(player.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    player.quadNow = player.quads[1]
    player.quadSize = #player.quads

    player.duration = duration or 1
    player.currentTime = 0

    function player:update(left, right, jump, dt)
        if left then
            player.face = 1
            if player.x < (love.graphics.getWidth() - player.width / 2) then
                player.x = player.x + (player.speed * dt)
            else
                player.x = love.graphics.getWidth() - player.width / 2
            end
        end
        if right then
            player.face = -1
            if player.x > player.width / 2 then 
                player.x = player.x - (player.speed * dt)
            else
                player.x = player.width / 2
            end
        end

        if jump then
            if player.y == player.ground then
                player.y_velocity = player.jump_height
            end
        end

        player.y = player.y + player.y_velocity * dt
        player.y_velocity = player.y_velocity - player.gravity * dt

        if player.y > player.ground then
            player.y_velocity = 0
            player.y = player.ground
        end

        player.currentTime = player.currentTime + dt
        if player.currentTime >= player.duration then
            player.currentTime = player.currentTime - player.duration
        end
        player.quadNow = player.quads[math.floor(player.currentTime / player.duration * player.quadSize) + 1]
    end

    function player:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(player.spriteSheet, player.quadNow, player.x, player.y, 0, player.face, 1, player.width / 2, player.height)
    end

    return player
end

return Character
