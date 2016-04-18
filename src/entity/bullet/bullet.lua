local Bullet = class('Bullet', Base)

function Bullet:initialize(t)
    t.img = t.img or img.bulletEnemy
    t.layer = self.friendly and 'bulletPlayer' or 'bulletEnemy'

    t.w = t.w or t.img:getWidth()
    t.h = t.h or t.img:getHeight()
    t.x = t.x - t.w / 2
    t.y = t.y - t.h / 2

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Motion,
    })

    Base.initialize(self, t)

    self.damage = t.damage or 1
    self.onHit = t.onHit or nil
    self.onRemove = t.onRemove or nil
    self.friendly = t.friendly or false
    self.pierce = t.pierce or false

    if t.target then
        self:shootTowardsTarget(t)
    elseif t.direction then
        self:shootTowardsDirection(t)
    else
        print('no target or direction for bullet')
        self:remove()
    end

    if t.duration then
        self.durationTimer = Timer.after(t.duration, function ()
            self:remove()
        end)
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

    if not self.pierce then
        self:remove()
    end
end

function Bullet:remove()
    if self.onRemove then
        local x, y = self:getCenter()
        self.onRemove(x, y)
    end

    if self.durationTimer then
        Timer.cancel(self.durationTimer)
    end

    Base.remove(self)
end

return Bullet
