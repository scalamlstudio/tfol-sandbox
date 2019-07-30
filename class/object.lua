-- Object

local Object = {}

function Object:new(panel, space, config)
    local obj = config or {}

    obj.time = obj.time or love.timer.getTime()
    obj.name = obj.name or love.math.random(100000000, 199999999)

    obj.x = obj.x or 0
    obj.y = obj.y or 0
    obj.mass = obj.mass or 1
    obj.bodyType = obj.bodyType or "static"
    obj.body = love.physics.newBody(space, obj.x, obj.y, obj.bodyType)
    obj.body:setMass(obj.mass)
    obj.body:setFixedRotation(obj.fixRotate or true)

    obj.shapes = obj.shapes or {}
    

    obj.shapeType = obj.shapeType or 1 -- 0 circle, 1 square
    obj.w = obj.w or 2
    obj.h = obj.h or 2
    if obj.shapeType == 0 then
        obj.shape = love.physics.newCircleShape(obj.h / 2)
    elseif obj.shapeType == 1 then
        obj.shape = love.physics.newRectangleShape(0, 0, obj.h, obj.w)
    end
    obj.density = obj.density or 1
    obj.fixture = love.physics.newFixture(obj.body, obj.shape, obj.density)
    if obj.effect then
        obj.fixture:setSensor(true)
    end

    obj.sx = obj.sx or 1
    obj.sy = obj.sy or 1
    obj.r = obj.r or 1
    obj.g = obj.g or 1
    obj.b = obj.b or 1
    obj.a = obj.a or 1

    function obj:grounded()
        local contacts = obj.body:getContacts()
        if #contacts > 0 then
            for i = 1, #contacts do
                local x1, y1, x2, y2 = contacts[i]:getPositions()
                -- panel:add(tostring(x1) .. tostring(y1) .. tostring(x2) .. tostring(y2))
                if y1 and y2 and y1 > obj.body:getY() and y2 > obj.body:getY() then
                    return true
                end
            end
        end
        return false
    end

    function obj:control(dt)
    end

    function obj:update(dt)
        if obj.anim then
            obj.anim:update(dt)
        end
    end

    function obj:draw()
        -- if panel and obj.body then
        --     panel:add("obj:" .. obj.name ..
        --         "  x: " .. tostring(obj.body:getX()) .. "  y: " .. tostring(obj.body:getY()))
        -- end
        if obj.anim then
            obj.anim:draw(obj.body:getX(), obj.body:getY(), obj.body:getAngle(),
                obj.sx, obj.sy, obj.w / 2, obj.h / 2, obj.r, obj.g, obj.b, obj.a)
        end
        if obj.image then
            love.graphics.setColor(obj.r, obj.g, obj.b, obj.a)
            love.graphics.draw(obj.image, obj.body:getX(), obj.body:getY(),
                obj.body:getAngle(), obj.sx, obj.sy, obj.w / 2, obj.h / 2)
        end
        love.graphics.setColor(1, 0, 0) -- set the drawing color to green for the ground
        if obj.shapeType == 1 then
            love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
        elseif obj.shapeType == 0 then
            love.graphics.circle("line", obj.body:getX(), obj.body:getY(),
                obj.shape:getRadius(), 20)
        end
    end

    return obj
end

return Object