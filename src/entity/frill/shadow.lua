local Shadow = class('Shadow', Frill)

function Shadow:initialize(t)
    t.img = img.shadow
    t.imgColorFilter = COLOR_SHADOW

    Frill.initialize(self, t)
end

function Shadow:update(dt)
    if self.parent then
        self.x, self.y = self.parent:getRect()
    end
end

return Shadow
