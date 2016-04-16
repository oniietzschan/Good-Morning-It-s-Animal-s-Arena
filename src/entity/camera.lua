local Camera = class('Camera')

function Camera:initialize(game)
    self.game = game

    self.x = CAMERA_MIN_X
    self.y = CAMERA_MIN_Y

    self.layers = {}
end

function Camera:newLayer(name, scaleX, scaleY, drawFunc)
    scaleX = scaleX or 1
    scaleY = scaleY or 1

    table.insert(self.layers, {
        name = name,
        drawFunc = drawFunc,
        scaleX = scaleX,
        scaleY = scaleY,
        entities = {},
    })
end

function Camera:addToLayer(layerName, ent)
    local layer = self:getLayer(layerName)

    self.game:addIdIfMissing(ent)

    layer.entities[ent.id] = ent
end

function Camera:removeFromLayer(layerName, ent)
    local layer = self:getLayer(layerName)
    layer.entities[ent.id] = nil
end

function Camera:getLayer(name)
    for _,layer in ipairs(self.layers) do
        if layer.name == name then
            return layer
        end
    end

    error(('Unknown layer "%s"'):format(name))
end

function Camera:draw()
    for _, layer in ipairs(self.layers) do
        lg.push()

        lg.translate(self:getPosForTranslation(layer.scaleX, layer.scaleY))

        self:drawEntities(layer, self:getPosScaled(layer.scaleX, layer.scaleY))

        if layer.drawFunc then
            layer.drawFunc(self:getPosScaled(layer.scaleX, layer.scaleY))
        end

        lg.pop()
    end
end

function Camera:getPosForTranslation(scaleX, scaleY)
    local camX, camY = self:getPosScaled(scaleX, scaleY)

    -- 0.5 should be added after scaling for more accurate rounding. I did the math.
    return math.floor(camX + 0.5) * -1,
           math.floor(camY + 0.5) * -1
end

function Camera:getPosScaled(scaleX, scaleY)
    local camX, camY = self:getPos()

    return camX * scaleX, camY * scaleY
end

function Camera:getPos()
    if player ~= nil then
        local x, y = player:getRect()
        self.x = x - (CAMERA_WIDTH / 2)
        self.y = y - (CAMERA_HEIGHT / 2)
    end

    -- Need to round!
    return math.max(CAMERA_MIN_X, math.min(CAMERA_MAX_X, self.x)),
           math.max(CAMERA_MIN_Y, math.min(CAMERA_MAX_Y, self.y))
end

function Camera:drawEntities(layer, camX, camY)
    love.graphics.setColor(255, 255, 255, 255)
    for _, ent in pairs(layer.entities) do
        if ent:isVisible(camX, camY, CAMERA_WIDTH, CAMERA_HEIGHT) then
            ent:draw()
        end
    end
end

return Camera
