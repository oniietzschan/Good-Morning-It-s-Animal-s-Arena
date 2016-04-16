local Image = class('Image')

function Image:initialize(path, quad_w, quad_h)
    self.image = lg.newImage(path)

    self.quad_w = quad_w or 16
    self.quad_h = quad_h or 16
    self.quads = self:initializeQuads()
end

function Image:initializeQuads()
    local w, h = self.quad_w, self.quad_h
    local quads = {}
    for y = 1, math.floor(self.image:getHeight() / h) do
        for x = 1, math.floor(self.image:getWidth() / w) do
            table.insert(quads,
                lg.newQuad((x - 1) * w, (y - 1) * h, w, h, self.image:getDimensions())
            )
        end
    end

    return quads
end

function Image:getWidth()
    return self.image:getWidth()
end

function Image:getHeight()
    return self.image:getHeight()
end

return Image
