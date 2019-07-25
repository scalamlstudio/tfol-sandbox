local Character = {}

function Character:new(asset, anim, config)
    local player = config
 
    player.ground = player.y
    player.speed = 800
    player.y_velocity = 0
    player.jump_height = -1000

    player.anim = anim

    player.duration = 1
    player.currentTime = 0

    function player:draw(panel)
        player.anim:draw(player.x, player.y, player.face, 1, player.w / 2, player.h)
        panel:add("playerX: " .. tostring(player.x) .. "\nplayerY: " .. tostring(player.y))
    end

    return player
end

return Character
