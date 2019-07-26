-- Object

local Object = {}

function Object:new(config)
    local obj = config or {}

    obj.time = obj.time or love.timer.getTime()
    obj.name = obj.name or obj.time
    obj.type = obj.type or "object"
    obj.shape = obj.shape or 0 -- 0 circle, 1 square
    obj.gf = obj.gf or 1 -- gravity factor
    obj.d = obj.d or 0 -- rotation degree
    obj.w = obj.w or 2
    obj.h = obj.h or 1
    obj.m = obj.m or 1
    obj.x = obj.x or 0
    obj.y = obj.y or 0
    obj.vx = obj.vx or 0
    obj.vy = obj.vy or 0
    obj.sx = obj.sx or 1
    obj.sy = obj.sy or 1
    obj.r = obj.r or 1
    obj.g = obj.g or 1
    obj.b = obj.b or 1
    obj.lx = obj.x
    obj.ly = obj.y
    obj.fs = {}

    function obj:control(panel, dt)
    end

    function obj:force(nf)
        obj.fs[#obj.fs + 1] = nf
    end

    function obj:collide(panel, objects)
        local ax = 0
        local ay = 0
        for i = 1, #obj.fs do
            ax = ax + obj.fs[i].x / obj.m
            ay = ay + obj.fs[i].y / obj.m
        end
        obj.vx = obj.vx + ax
        obj.vy = obj.vy + ay
        obj.fs = {}
        panel:add("Check Collide: " .. obj.name)
        for i = 1, #objects do
            local another = objects[i]
            if another.name ~= obj.name and obj.m < another.m * 10 then
                local check = false
                if obj.shape == 0 and another.shape == 0 then -- use average circle first
                    local d = math.sqrt(math.pow(obj.x - another.x, 2) + math.pow(obj.y - another.y, 2))
                    if d < (obj.w + obj.h + another.w + another.h) / 4 then
                        check = true
                    end
                elseif obj.shape == 1 and another.shape == 1 then
                    panel:add("Checking Collide: " .. obj.name .. " vs " .. another.name)
                    check = true
                    if obj.x - obj.w / 2 > another.x + another.w / 2 or obj.x + obj.w / 2 < another.x - another.w / 2 then
                        check = false
                    end
                    if obj.y - obj.h / 2 < another.y + another.h / 2 or obj.y + obj.h / 2 < another.y - another.h / 2 then
                        check = false
                    end
                end
                if check then
                    panel:add("Collide " .. obj.name .. " " .. another.name)
                    obj.vx = (-obj.vx + another.vx) * another.m / (obj.m + another.m)
                    obj.vy = (-obj.vy + another.vy) * another.m / (obj.m + another.m)
                end
            end
        end
    end

    function obj:update(panel, dt)
        obj.lx = obj.x
        obj.ly = obj.y
        obj.x = obj.x + obj.vx * dt
        obj.y = obj.y + obj.vy * dt
        if obj.anim then
            obj.anim:update(dt)
        end
    end

    function obj:draw(panel)
        if obj.anim then
            obj.anim:draw(obj.x, obj.y, obj.d, obj.sx, obj.sy, obj.w / 2, obj.h, obj.r, obj.g, obj.b)
        end
        if obj.image then
            love.graphics.setColor(obj.r, obj.g, obj.b)
            love.graphics.draw(obj.image, obj.x, obj.y, obj.d, obj.sx, obj.sy, obj.w / 2, obj.h)
        end
        if panel then
            panel:add("objName:" .. obj.name .. "  x: " .. tostring(obj.x) .. "  y: " .. tostring(obj.y))
        end
    end

    return obj
end

return Object