local Bullet = class('Bullet', Base)

function Bullet:initialize(t)
    t.w = t.w or 5
    t.h = t.h or 5

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Motion,
    })

    t.img = img.bulletPlayer

    Base.initialize(self, t)

    self:shootTowardsMouse()
end

function Bullet:shootTowardsMouse()
    local x, y, w, h = self:getRect()
    local mX, mY = Util:mousePos()
    local relX = mX - x - w / 2
    local relY = mY - y - h / 2
    self:shootTowards(BULLET_PLAYER_SPEED, relX, relY)
end

function Bullet:shootTowards(speed, x, y)
    local speedX, speedY = Vector.normalize(x, y)
    speedX = speedX * speed
    speedY = speedY * speed
    self.speedX = speedX
    self.speedY = speedY

end

function Bullet:update(dt)
    Base.update(self, dt)

    self:removeIfOffscreen()
end

local DIST = 100

function Bullet:removeIfOffscreen()
    local x, y = self:getRect()
    if x < GAME_MIN_X - DIST or x > GAME_MAX_X + DIST or y < GAME_MIN_Y - DIST or y > GAME_MAX_Y + DIST then
        self:remove()
    end
end

return Bullet
