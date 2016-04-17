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

    self:facePlayer()
end

function AiEnemy:towardsPlayer()
    self.parent:setAnimation('walk')

    local x, y = self.parent:getCenter()
    local player = game:getPlayerPos()
    self.parent:setSpeed(Util.vectorBetween(x, y, player.x, player.y, self.parent.speed))

    self:nextActionIn(0.15 + rng() * 0.2)
end

function AiEnemy:shootAtPlayer()
    self.parent:setAnimation('walk')

    local x, y = self.parent:getCenter()
    local player = game:getPlayerPos()

    Bullet({
        x = x,
        y = y,
        speed = ENEMY_NORMAL_BULLET_SPEED,
        target = player,
    })

    -- towards player at half sdeed
    self.parent:setSpeed(Util.vectorBetween(x, y, player.x, player.y, self.parent.speed * 0.5))

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:shootVolleyAtPlayer()
    self.parent:setAnimation('stand')

    local x, y = self.parent:getCenter()

    -- stop first
    self.parent.speedX = 0
    self.parent.speedY = 0

    -- fire after a bit
    Timer.after(0.5, function()
        if self.parent.hp <= 0 then
            return
        end

        for i = -1, 1 do
            Bullet({
                x = x,
                y = y,
                speed = ENEMY_NORMAL_BULLET_SPEED,
                target = game:getPlayerPos(),
                angle = i * 0.1 - 0.01 + rng() * 0.02,
            })
        end
    end)

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:facePlayer()
    local player = game:getPlayerPos()
    local x, y = self.parent:getCenter()
    self.parent.img_mirror = (player.x < x)
end

function AiEnemy:nextActionIn(time)
    self.needsAction = false
    Timer.after(time, function() self.needsAction = true end)
end

return AiEnemy
