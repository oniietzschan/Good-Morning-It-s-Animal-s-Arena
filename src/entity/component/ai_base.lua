local AiBase = class('AiBase', Component)

function AiBase:initialize(t)
    Component.initialize(self, t)

    self.needsAction = true
end

function AiBase:update(dt)
    if self.needsAction == false then
        return
    end

    local behavioursMethod = Util.rngSelect(self.behaviours)
    self[behavioursMethod](self)

    self:facePlayer()
end

function AiBase:fireBullet(t)
    local x, y = self.parent:getCenter()

    t.x = x + (self.parent.img_mirror and (self.parent.offsetFireX * -1) or self.parent.offsetFireX)
    t.y = y + self.parent.offsetFireY
    t.target = game:getPlayerPos()
    t.speed = ENEMY_NORMAL_BULLET_SPEED

    Bullet(t)
end

function AiBase:isOnscreen()
    return not self:isOffscreen()
end

function AiBase:isOffscreen()
    local x, y = self.parent:getCenter()

    return x < GAME_MIN_X or y < GAME_MIN_Y or x > GAME_MAX_X or y > GAME_MAX_Y
end

function AiBase:facePlayer()
    local player = game:getPlayerPos()
    local x, y = self.parent:getCenter()
    self.parent.img_mirror = (player.x < x)
end

function AiBase:nextActionIn(time)
    self.needsAction = false
    Timer.after(time, function() self.needsAction = true end)
end

return AiBase
