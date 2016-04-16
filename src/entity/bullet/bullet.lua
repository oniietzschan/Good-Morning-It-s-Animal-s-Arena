local Bullet = class('Bullet', Base)

function Bullet:initialize(t)
    t.w = t.w or 5
    t.h = t.h or 5

    self.damage = t.damage or 1
    self.friendly = false or t.friendly

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Motion,
    })

    t.img = img.bulletPlayer

    Base.initialize(self, t)

    self:shootTowardsMouse()
end

function Bullet:shootTowardsMouse()
    local x, y = self:getCenter()
    local mx, my = Util:mousePos()
    self:setSpeed(Util.vectorBetween(x, y, mx, my, BULLET_PLAYER_SPEED))
end

function Bullet:getCenter()
    local x, y, w, h = self:getRect()

    return x + w / 2, y + h / 2
end

function Bullet:setSpeed(dx, dy)
    self.speedX = dx
    self.speedY = dy
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

function Bullet:move(relX, relY)
   self:setPosRel(relX, relY)
   return relX, relX, {}, 0
end

return Bullet
