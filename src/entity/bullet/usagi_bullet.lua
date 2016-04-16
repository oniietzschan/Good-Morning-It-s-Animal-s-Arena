local UsagiBullet = class('UsagiBullet', Bullet)

function UsagiBullet:initialize(t)
    t.friendly = true

    t.w = 5
    t.h = 5

    t.img = img.bulletPlayer

    Bullet.initialize(self, t)

    self:shootTowardsMouse()
end

function UsagiBullet:shootTowardsMouse()
    local x, y = self:getCenter()
    local mx, my = Util:mousePos()
    self:setSpeed(Util.vectorBetween(x, y, mx, my, BULLET_PLAYER_SPEED))
end

return UsagiBullet
