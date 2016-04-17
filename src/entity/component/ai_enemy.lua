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

    if self:isOnscreen() then
        Util.sound('enemyShootShort')
        self:fireBullet({})
    end

    -- towards player at half sdeed
    local x, y = self.parent:getCenter()
    local player = game:getPlayerPos()
    self.parent:setSpeed(Util.vectorBetween(x, y, player.x, player.y, self.parent.speed * 0.5))

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:shootVolleyAtPlayer()
    self.parent:setAnimation('stand')

    -- fire after a bit
    if self:isOnscreen() then
        Timer.after(0.5, function()
            if self.parent.hp <= 0 then
                return
            end

            Util.sound('enemyShootMedium')

            for i = -2, 2 do
                self:fireBullet({
                    angle = i * 0.13 - 0.01 + rng() * 0.02,
                })
            end
        end)
    end

    self:nextActionIn(1.15 + rng() * 0.2)
end

function AiEnemy:fireBullet(t)
    local x, y = self.parent:getCenter()

    t.x = x + (self.parent.img_mirror and (self.parent.offsetFireX * -1) or self.parent.offsetFireX)
    t.y = y + self.parent.offsetFireY
    t.target = game:getPlayerPos()
    t.speed = ENEMY_NORMAL_BULLET_SPEED

    Bullet(t)
end

function AiEnemy:isOnscreen()
    return not self:isOffscreen()
end

function AiEnemy:isOffscreen()
    local x, y = self.parent:getCenter()

    return x < GAME_MIN_X or y < GAME_MIN_Y or x > GAME_MAX_X or y > GAME_MAX_Y
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
