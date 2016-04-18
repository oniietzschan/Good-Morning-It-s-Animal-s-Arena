local Frill = class('Frill', BaseFrill)

function Frill:initialize(t)
    self.img = t.img or img.tiles
    self.quad = t.quad or self.img.quads[1]

    BaseFrill.initialize(self, t)

    self.x, self.y = self.parent:getRect()

    if t.varianceX then
        self.x = self.x - t.varianceX + rng(t.varianceX * 2)
    end
end

function Frill:remove()
    self.game.camera:removeFromLayer(self.layer, self)
end

function Frill:isVisible()
    return true
end

function Frill:draw()
    -- hack
    local extraOffset = 0
    if self.parent and self.parent:isInstanceOf(Enemy) and self.parent.img_mirror then
        extraOffset = -4
    elseif self.parent and self.parent:isInstanceOf(Player) and self.parent.form == NEKO and self.parent.img_mirror then
        extraOffset = 8
    end

    lg.setColor(unpack(self.imgColorFilter))
    lg.draw(
        self.img.image,
        self.quad,
        self.x + self.offsetX + extraOffset,
        self.y + self.offsetY
    )
end

return Frill
