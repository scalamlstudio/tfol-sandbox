-- Object

local Object = {}

function Object:new(env, config)
    local obj = config or {}

    obj.time = obj.time or love.timer.getTime()
    obj.type = obj.type or "default"
    obj.name = obj.name or "no-" .. love.math.random(100000000, 199999999)
    obj.hp = obj.hp or 1

    obj.parts = obj.parts or {}
    for i = 1, #obj.parts do
        local part = obj.parts[i] -- object body
        part.x = part.x or 0
        part.y = part.y or 0
        part.mass = part.mass or 0
        part.tileBreaker = part.tileBreaker or false
        part.bodyType = part.bodyType or "static"
        part.body = love.physics.newBody(env.space, part.x, part.y, part.bodyType)
        part.body:setMass(part.mass)
        part.body:setFixedRotation(part.fixRotate or true)

        part.shapeType = part.shapeType or 1
        part.w = part.w or 2
        part.h = part.h or 2
        if part.shapeType == 0 then
            part.shape = love.physics.newCircleShape(part.h / 2)
        elseif part.shapeType == 1 then
            part.shape = love.physics.newRectangleShape(0, 0, part.w, part.h)
        elseif part.shapeType == 2 then
            part.shape = love.physics.newEdgeShape(part.x - part.w, part.y, part.x + part.w, part.y)
        elseif part.shapeType == 4 then
            part.shape = love.physics.newPolygonShape({
                -part.w / 2, -part.h / 2 + part.s, -part.w / 2 + part.s, -part.h / 2,
                 part.w / 2 - part.s, -part.h / 2, part.w / 2, -part.h / 2 + part.s,
                 part.w / 2, part.h / 2 - part.s, part.w / 2 - part.s, part.h / 2,
                -part.w / 2 + part.s, part.h / 2, -part.w / 2, part.h / 2 - part.s
            })
        end
        part.density = part.density or 1
        part.fixture = love.physics.newFixture(part.body, part.shape, part.density)
        if part.effect then
            part.fixture:setSensor(true)
        end
        part.sx = part.sx or 1
        part.sy = part.sy or 1
        part.r = part.r or 1
        part.g = part.g or 1
        part.b = part.b or 1
        part.a = part.a or 1
    end

    obj.joints = obj.joints or {}
    for i = 1, #obj.joints do
        local joint = obj.joints[i] -- object joint
        if joint.id1 and obj.parts[joint.id1] and joint.id2 and obj.parts[joint.id2] then
            local jointType = joint.type or "weld"
            if jointType == "weld" then
                joint.x = joint.x or obj.parts[joint.id1].body:getX()
                joint.y = joint.y or obj.parts[joint.id1].body:getY()
                joint.collideConnected = joint.collideConnected or false
                love.physics.newWeldJoint(obj.parts[joint.id1].body, obj.parts[joint.id2].body,
                    joint.x, joint.y, joint.collideConnected)
            elseif jointType == "rope" then
                joint.x1 = joint.x1 or obj.parts[joint.id1].body:getX()
                joint.y1 = joint.y1 or obj.parts[joint.id1].body:getY()
                joint.x2 = joint.x2 or obj.parts[joint.id2].body:getX()
                joint.y2 = joint.y2 or obj.parts[joint.id2].body:getY()
                joint.maxLength = joint.maxLength or 10
                joint.collideConnected = joint.collideConnected or false
                love.physics.newRopeJoint(obj.parts[joint.id1].body, obj.parts[joint.id2].body,
                    joint.x1, joint.y1, joint.x2, joint.y2, joint.maxLength, joint.collideConnected)
            else
            end
        end
    end

    function obj:grounded()
        for i = 1, #obj.parts do
            local part = obj.parts[i] -- object body
            local contacts = part.body:getContacts()
            if #contacts > 0 then
                for i = 1, #contacts do
                    local x1, y1, x2, y2 = contacts[i]:getPositions()
                    if (part.shapeType == 1 or part.shapeType == 4) and y1 and y2 and y1 > part.body:getY() and y2 > part.body:getY() + part.h / 4 then
                        return true
                    elseif part.shapeType == 0 and y1 and y1 > part.body:getY() + part.h / 4 then
                        return true
                    end
                end
            end
        end
        return false
    end

    function obj:control(dt)
        -- if env.panel and string.sub(obj.name, 1, 3) ~= "no-" then
        --     env.panel:add("control obj:" .. obj.name)
        -- end
    end

    function obj:update(dt)
        for i = 1, #obj.parts do
            local part = obj.parts[i] -- object body
            if part.anim then
                part.anim:update(dt)
            end
        end
    end

    function obj:draw()
        if env.panel and obj.type ~= "tile" then
            env.panel:add("obj:" .. obj.name)
        end
        for i = 1, #obj.parts do
            local part = obj.parts[i] -- object body
            if env.panel and part.body and obj.type ~= "tile" then
                env.panel:add("  x: " .. tostring(part.body:getX()) .. "  y: " .. tostring(part.body:getY()))
            end
            if part.anim then
                part.anim:draw(part.body:getX(), part.body:getY(), part.body:getAngle(),
                    part.sx, part.sy, part.anim.w / 2, part.anim.h / 2, part.r, part.g, part.b, part.a)
            end
            if part.image then
                love.graphics.setColor(part.r, part.g, part.b, part.a)
                love.graphics.draw(part.image, part.body:getX(), part.body:getY(),
                    part.body:getAngle(), part.sx, part.sy, part.w / 2, part.h / 2)
            end
            love.graphics.setColor(1, 0, 0) -- set the drawing color to green for the ground
            if part.body:isActive() then
                if part.shapeType == 1 or part.shapeType == 4 then
                    love.graphics.polygon("line", part.body:getWorldPoints(part.shape:getPoints()))
                elseif part.shapeType == 0 then
                    love.graphics.circle("line", part.body:getX(), part.body:getY(),
                        part.shape:getRadius(), 20)
                end
            end
        end
    end

    return obj
end

return Object