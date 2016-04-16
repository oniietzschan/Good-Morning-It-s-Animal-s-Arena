local Bullet = class('Bullet', Base)

function Bullet:initialize(t)
    self.damage = t.damage or 1
    self.friendly = t.friendly or false

    t.layer = self.friendly and 'bulletPlayer' or 'bulletEnemy'

    t.w = t.w or 5
    t.h = t.h or 5

    t.imgColorFilter = t.imgColorFilter or {255, 192, 128, 255}

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Motion,
    })

    t.img = t.img or img.bulletPlayer

    Base.initialize(self, t)

    if t.target then
        self:shootTowardsTarget(t)
    elseif t.direction then
        self:shootTowardsDirection(t)
    else
        print('no target or direction for bullet')
        self:remove()
    end

    if t.onHit then
        self.onHit = t.onHit
    end
end

function Bullet:shootTowardsTarget(t)
    local x, y = self:getCenter()
    local dx, dy = Util.vectorBetween(x, y, t.target.x, t.target.y, t.speed)

    t.angle = t.angle or 0
    dx, dy = Vector.rotate(math.pi * t.angle, dx, dy)

    self:setSpeed(dx, dy)
end

function Bullet:shootTowardsDirection(t)
    local x, y = self:getCenter()

    self:setSpeed(Vector.rotate(math.pi * t.direction, t.speed, 0))
end

function Bullet:update(dt)
    Base.update(self, dt)

    self:removeIfOffscreen()
end

local DIST = 10

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

function Bullet:hitTarget()
    if self.onHit then
        local x, y = self:getCenter()
        self.onHit(x, y)
    end

    self:remove()
end

return Bullet
