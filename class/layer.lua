local Layer = {}

function Layer:new(config)
    layer = {}

    layer.conf = config
    layer.x = config.x or 0
    layer.y = config.y or 0
    layer.width = config.width or love.graphics.getWidth()
    layer.height = config.height or love.graphics.getHeight()

    function layer:draw(panel)
        if layer.conf.layerType == 0 then
            love.graphics.setColor(layer.conf.r, layer.conf.g, layer.conf.b, layer.conf.a)
            love.graphics.rectangle('fill', layer.x, layer.y, layer.width, layer.height)
        end
    end

    return layer
end

return Layer