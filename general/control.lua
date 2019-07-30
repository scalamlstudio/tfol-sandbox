-- Control

local Control = {}

function Control:new(config)
    control = config or {}
    control.type = control.type or "ai"
    control.rightKey = control.rightKey or 'd'
    control.leftKey = control.leftKey or 'a'
    control.jumpKey = control.jumpKey or 'w'
    if config.type == "keyboard" then
        function control:right()
            return love.keyboard.isDown(control.rightKey)
        end
        function control:left()
            return love.keyboard.isDown(control.leftKey)
        end
        function control:jump()
            return love.keyboard.isDown(control.jumpKey)
        end
    end
    return control
end

return Control