-- Physics

local Physics = {}

function Physics:new(config)
    physics = {}
    if config.type == 1 then
        function physics:update(obj, dt)
            obj.y = obj.y + obj.y_velocity * dt
            obj.y_velocity = obj.y_velocity + config.gravity * dt

            if obj.x < obj.w / 2 then
                obj.x = obj.w / 2
            elseif obj.x > (love.graphics.getWidth() - obj.w / 2) then
                obj.x = love.graphics.getWidth() - obj.w / 2
            end
            if obj.y > obj.ground then
                obj.y_velocity = 0
                obj.y = obj.ground
            end
        end
    end
    return physics
end

return Physics