local AiEnemy = class('AiEnemy', AiBase)

-- local behaviours

AiEnemy.behaviours = {
    {o = 1,    v = 'towardsPlayer'},
    {o = 0.25, v = 'shootAtPlayer'},
    {o = 0.065, v = 'shootVolleyAtPlayer'},
}

function AiEnemy:towardsPlayer()
    self.parent:setAnimation('walk')

    local x, y = self.parent:getCenter()
    local player = game:getPlayerPos()
    self.parent:setSpeed(Util.vectorBetween(x, y, player.x, player.y, self.parent.speed))

    self:nextActionIn(0.35 + rng() * 0.2)
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
    self.parent:setSpeed(0, 0)

    -- fire after a bit
    if self:isOnscreen() then
        Timer.after(0.5, function()
            if self.parent.hp <= 0 then
                return
            end

            Util.sound('enemyShootMedium')

            for i = -1, 1 do
                self:fireBullet({
                    angle = i * 0.17 - 0.01 + rng() * 0.02,
                })
            end
        end)
    end

    self:nextActionIn(1.15 + rng() * 0.2)
end

return AiEnemy
