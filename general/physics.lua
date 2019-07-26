-- Physics

local Physics = {}

function Physics:new(config)
    local physics = config or {}
    -- physics.type = physics.type or 1
    physics.w = physics.w or love.graphics.getWidth()
    physics.h = physics.h or love.graphics.getHeight()

    function physics:update(panel, objects, dt)
        for i = 1, #objects do
            local obj = objects[i]
            obj:force({x = physics.gravity.x * obj.gf, y = physics.gravity.y * obj.gf})
            obj:collide(panel, objects)
            obj:update(panel, dt)

            if obj.x < obj.w / 2 then
                obj.x = obj.w / 2
            elseif obj.x > physics.w - obj.w / 2 then
                obj.x = physics.w - obj.w / 2
            end
            if obj.y > physics.h then
                obj.vy = 0
                obj.y = physics.h
            end
        end
    end

    return physics
end

return Physics