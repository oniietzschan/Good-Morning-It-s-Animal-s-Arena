local AiBoss = class('AiBoss', AiBase)

AiBoss.behaviours = {
    {o = 1, v = 'danmaku'},
}

function AiBoss:initialize(t)
    AiBase.initialize(self, t)

    self.needsAction = false
    self.myDanmaku = Util.roll(60, 'danmakuOne', 'danmakuTwo')

    self:moveToPosition()
end

function AiBoss:moveToPosition()
    self.atPosition = false

    self.parent:setAnimation('walk')
    local x = self.parent:getCenter()
    self.parent:setSpeed((x < 104 and self.parent.speed or (self.parent.speed * -1)), 0)

    -- face correct direction
    self.parent.img_mirror = (x > 104)
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
        elseif self.parent.speedX == 0 then
            self:moveToPosition()
        end
    end

    AiBase.update(self, dt)
end

function AiBoss:danmaku()
    print( self.myDanmaku)
    self[self.myDanmaku](self)
end

function AiBoss:danmakuOne()
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

function AiBoss:danmakuTwo()
    self.parent:setAnimation('stand')
    self.parent:setSpeed(0, 0)


    local target = {
        x = CAMERA_WIDTH  / 2 - 100 + rng() * 200,
        y = CAMERA_HEIGHT / 2 - 100 + rng() * 200,
    }
    local spread = 0.1

    for i = 1, 7 do
        local after = 0.001 + (i * 0.3)
        Timer.after(after, function()
            if self.parent.hp <= 0 then
                return
            end

            Util.sound('enemyShootMedium')

            for i = -2, 2 do
                local angle = i * spread
                self:fireBullet({
                    target = target,
                    speed = ENEMY_BOSS_BULLET_SPEED,
                    angle = angle,
                })
            end
        end)
    end

    self:nextActionIn(4)
end

return AiBoss
