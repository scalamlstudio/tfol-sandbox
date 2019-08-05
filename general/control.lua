-- Control

local Control = {}

function Control:new(config)
    local control = config or {}
    control.type = control.type or "ai"
    control.rightKey = control.rightKey or 'd'
    control.leftKey = control.leftKey or 'a'
    control.jumpKey = control.jumpKey or 'w'
    control.attackKey = control.attackKey or 'space'
    control.castKey = control.castKey or 'c'
    if control.type == "keyboard" then
        function control:right()
            return love.keyboard.isDown(control.rightKey) and not love.keyboard.isDown(control.leftKey)
        end
        function control:left()
            return love.keyboard.isDown(control.leftKey) and not love.keyboard.isDown(control.rightKey)
        end
        function control:jump()
            return love.keyboard.isDown(control.jumpKey)
        end
        function control:attack()
            return love.keyboard.isDown(control.attackKey)
        end
        function control:cast()
            return love.keyboard.isDown(control.castKey)
        end
    else
        function control:right()
            return false
        end
        function control:left()
            return false
        end
        function control:jump()
            return false
        end
    end
    return control
end

return Control