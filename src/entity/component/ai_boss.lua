local AiBoss = class('AiBoss', AiBase)

AiBoss.behaviours = {
    {o = 1, v = 'danmaku'},
}

function AiBoss:initialize(t)
    AiBase.initialize(self, t)

    self.needsAction = false

    self:moveToPosition()
end

function AiBoss:moveToPosition()

    self.atPosition = false

    self.parent:setAnimation('walk')
    local x = self.parent:getCenter()
    self.parent:setSpeed((x < 0 and self.parent.speed or (self.parent.speed * -1)), 0)
end

function AiBoss:update(dt)
    if self.atPosition == false then

        if self.parent.hp <= 0 then
            return
        end

        local x = self.parent:getCenter()
        if x > 104 and x < 536 then
            self.atPosition = true
            self.needsAction = true
        end
    end

    AiBase.update(self, dt)
end

function AiBoss:danmaku()
    self.parent:setAnimation('stand')
    self.parent:setSpeed(0, 0)

    Util.sound('enemyShootLong')

    local spread = 0.1
    local jitter = 0.05

    for i = -2, 2 do
        local after = 0.001 + ((i + 3) * 0.1)
        local angle = i * spread - jitter + rng() * jitter * 2
        Timer.after(after, function()
            if self.parent.hp <= 0 then
                return
            end
            self:fireBullet({
                target = {x = CAMERA_WIDTH / 2, y = CAMERA_HEIGHT / 2},
                speed = ENEMY_BOSS_BULLET_SPEED,
                angle = angle,
            })
        end)
    end

    self:nextActionIn(1)
end

return AiBoss
