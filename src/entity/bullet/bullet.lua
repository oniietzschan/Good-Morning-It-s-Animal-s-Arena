local Bullet = class('Bullet', Base)

function Bullet:initialize(t)
    self.damage = t.damage or 1
    self.friendly = false or t.friendly

    t.w = t.w or 5
    t.h = t.h or 5

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Motion,
    })

    t.img = img.bulletPlayer

    Base.initialize(self, t)

    if t.target then
        self:shootTowardsTarget(t)
    end
end

function Bullet:shootTowardsTarget(t)
    local x, y = self:getCenter()
    local mx, my = t.target:getCenter()
    local dx, dy = Util.vectorBetween(x, y, mx, my, t.speed)

    t.angle = t.angle or 0
    dx, dy = Vector.rotate(math.pi * t.angle, dx, dy)

    self:setSpeed(dx, dy)
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
