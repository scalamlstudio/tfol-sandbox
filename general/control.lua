-- Control

local Control = {}

function Control:new(config)
    control = {}
    if config.type == 1 then
        function control:right()
            return love.keyboard.isDown('d')
        end
        function control:left()
            return love.keyboard.isDown('a')
        end
        function control:jump()
            return love.keyboard.isDown('space')
        end
    end
    return control
end

return Control