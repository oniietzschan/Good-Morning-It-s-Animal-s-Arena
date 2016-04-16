local AiEnemy = class('AiEnemy', Component)

function AiEnemy:initialize(t)
    Component.initialize(self, t)

    self.needsAction = true
end

local behaviours = {
    {o = 1,    v = 'towardsPlayer'},
    {o = 0.25, v = 'shootAtPlayer'},
    {o = 0.075, v = 'shootVolleyAtPlayer'},
}

function AiEnemy:update(dt)
    if self.needsAction == false then
        return
    end

    local behavioursMethod = Util.rngSelect(behaviours)
    self[behavioursMethod](self)
end

function AiEnemy:towardsPlayer()
    local x, y = self.parent:getCenter()
    local px, py = game:getPlayerPos()
    self.parent:setSpeed(Util.vectorBetween(x, y, px, py, self.parent.speed))

    self:nextActionIn(0.15 + rng() * 0.2)
end

function AiEnemy:shootAtPlayer()
    local x, y = self.parent:getCenter()

    Bullet({
        x = x,
        y = y,
        speed = ENEMY_NORMAL_BULLET_SPEED,
        target = player,
    })

    -- slow down!!
    self.parent.speedX = self.parent.speedX * (0.25 + rng() * 0.5)
    self.parent.speedY = self.parent.speedY * (0.25 + rng() * 0.5)

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:shootVolleyAtPlayer()
    local x, y = self.parent:getCenter()

    -- stop first
    self.parent.speedX = 0
    self.parent.speedY = 0

    -- fire after a bit
    Timer.after(0.5, function()
        for i = -1, 1 do
            Bullet({
                x = x,
                y = y,
                speed = ENEMY_NORMAL_BULLET_SPEED,
                target = player,
                angle = i * 0.1 - 0.01 + rng() * 0.02,
            })
        end
    end)

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:nextActionIn(time)
    self.needsAction = false
    Timer.after(time, function() self.needsAction = true end)
end

return AiEnemy
