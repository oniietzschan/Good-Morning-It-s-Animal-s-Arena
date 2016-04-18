local Player = class('Player', Seibutsu)

function Player:initialize(t)
    t.solid = true

    t.components = {
        Friendly,
    }

    t.w = WIDTH_USAGI
    t.h = HEIGHT_USAGI

    t.img = img.usagi

    Seibutsu.initialize(self, t)

    self.hp = 1

    self.myShadow = self:addFrill(Shadow, {
        layer = 'shadow',
        offsetX = -2,
        offsetY = 14,
    })

    -- self:toKuma()
    -- self:toNeko()
    self:toUsagi(true)

    self.canTransform = true
end

function Player:toKuma()
    self.form = KUMA
    self.hp = 2

    self.maxSpeed = MAX_SPEED_KUMA
    self.acceleration = ACCELERATION_KUMA

    self.img = img.kuma
    self.animations = self.animationsKuma
    self:animationBugAfterTransformHack()

    self.img_offset_x = IMG_OFFSET_X_KUMA
    self.img_offset_y = IMG_OFFSET_Y_KUMA
    self.myShadow.offsetY = 14

    self:helpTransform()
end

function Player:toNeko()
    self.form = NEKO
    self.hp = 1

    self.maxSpeed = MAX_SPEED_NEKO
    self.acceleration = ACCELERATION_NEKO

    self.img = img.neko
    self.animations = self.animationsNeko
    self:animationBugAfterTransformHack()

    self.img_offset_x = IMG_OFFSET_X_NEKO
    self.img_offset_y = IMG_OFFSET_Y_NEKO
    self.offsetFireX = 28
    self.offsetFireY = 1.5
    self.myShadow.offsetY = 11

    self:helpTransform()
end

function Player:toUsagi(first)
    self.form = USAGI
    self.hp = 1

    self.maxSpeed = MAX_SPEED_USAGI
    self.acceleration = ACCELERATION_USAGI

    self.img = img.usagi
    self.animations = self.animationsUsagi

    self.img_offset_x = IMG_OFFSET_X_USAGI
    self.img_offset_y = IMG_OFFSET_Y_USAGI
    self.offsetFireX = 22
    self.offsetFireY = 1
    self.myShadow.offsetY = 14

    self:helpTransform(first)
end

function Player:helpTransform(first)
    if not first then
        Util.sound('playerTransform', 0.2)

        self.canTransform = false
        self.transformTimer = 0
        Timer.tween(3.5, self, {transformTimer = 1}, 'linear', function()
            Util.sound('playerCanTransform')
            self.canTransform = true
        end)
    end

    self.canAttack = true

    self:animationBugAfterTransformHack()
end

function Player:animationBugAfterTransformHack()
    self:setAnimation('walk')
    self:setAnimation('stand')
end

function Player:initializeSpriteSheet()
    self.airborne = false
    self.anim_cycle = 0

    local quads = img.kuma.quads
    self.animationsKuma = {
        stand = {
            quads[1],
        },
        walk = {
            frequency = 2,
            quads[2],
            quads[3],
            quads[4],
            quads[5],
            quads[6],
            quads[7],
        }
    }

    quads = img.usagi.quads
    self.animationsUsagi = {
        stand = {
            quads[1],
        },
        walk = {
            frequency = 2,
            quads[2],
            quads[3],
            quads[4],
            quads[5],
            quads[6],
            quads[7],
        }
    }

    quads = img.neko.quads
    self.animationsNeko = {
        stand = {
            quads[1],
        },
        walk = {
            frequency = 2,
            quads[2],
            quads[3],
            quads[4],
            quads[5],
            quads[6],
            quads[7],
        }
    }

    self.animations = self.animationsUsagi
end

function Player:update(dt)
    self:handleOutOfBounds()

    self:handleChangeForm(dt)
    self:handleWalking(dt)
    self:handleAttack(dt)

    Seibutsu.update(self, dt)
end

function Player:handleChangeForm()
    if not self.canTransform then
        return
    end

    if input:pressed(KUMA) and self.form ~= KUMA then
        self:toKuma()
    end
    if input:pressed(NEKO) and self.form ~= NEKO then
        self:toNeko()
    end
    if input:pressed(USAGI) and self.form ~= USAGI then
        self:toUsagi()
    end
end

function Player:handleWalking(dt)
    local x = 0
    local y = 0

    if input:down('left') then
        x = x - 1
    end
    if input:down('right') then
        x = x + 1
    end
    if input:down('up') then
        y = y - 1
    end
    if input:down('down') then
        y = y + 1
    end

    if x ~= 0 or y ~= 0 then
        self:setAnimation('walk')
    else
        self:setAnimation('stand')
    end

    local x, y = Vector.normalize(x, y)

    self:walk(x, y, dt)
end

function Player:walk(x, y, dt)
    local deltaSpeedX = x * dt * self.acceleration
    local deltaSpeedY = y * dt * self.acceleration

    -- Todo: it's possible to move sliiiightly faster than maxSpeed with this method.
    if (deltaSpeedX > 0 and self.speedX > self.maxSpeed) or (deltaSpeedX < 0 and self.speedX < self.maxSpeed * -1) then
        deltaSpeedX = 0
    end
    if (deltaSpeedY > 0 and self.speedY > self.maxSpeed) or (deltaSpeedY < 0 and self.speedY < self.maxSpeed * -1) then
        deltaSpeedY = 0
    end

    if (deltaSpeedX > 0 and self.speedX < 0) or (deltaSpeedX < 0 and self.speedX > 0) or (x == 0) or (math.abs(self.speedX) > self.maxSpeed) then
        self:dampenSpeedX(dt)
    end
    if (deltaSpeedY >= 0 and self.speedY < 0) or (deltaSpeedY < 0 and self.speedY > 0) or (y == 0) or (math.abs(self.speedY) > self.maxSpeed) then
        self:dampenSpeedY(dt)
    end

    -- Todo: speed limit should be normalized too, so that diagonal walking isn't faster
    self.speedX = self.speedX + deltaSpeedX
    self.speedY = self.speedY + deltaSpeedY
end

function Player:dampenSpeedX(dt)
    self.speedX = self.speedX * math.pow(WALK_DAMPEN_FACTOR, dt)

    if math.abs(self.speedX) < 1 then
        self.speedX = 0
    end
end

function Player:dampenSpeedY(dt)
    self.speedY = self.speedY * math.pow(WALK_DAMPEN_FACTOR, dt)

    if math.abs(self.speedY) < 1 then
        self.speedY = 0
    end
end

function Player:handleAttack()
    if self.canAttack == false or not input:down(ATTACK) then
        return
    end

    local x, y = self:getCenter()

    if self.form == KUMA then
        Util.sound('kumaAttack', 0.2)

        local t = {
            x = x,
            y = y,
            friendly = true,
            pierce = true,
            damage = BULLET_DAMAGE_KUMA,
            speed = BULLET_SPEED_KUMA,
            duration = KUMA_ATTACK_DURATION,
        }

        for i=1,2 do
            local t = Util.deepcopy(t)

            -- worst code every jfc
            local offsetx, offsety = 0, 0
            local mx, my = Util:mousePos()
            local targetOffsetX, targetOffsetY = Util.vectorBetween(x, y, mx, my, KUMA_ATTACK_RANGE)

            do
                local x, y = Vector.perpendicular(targetOffsetX, targetOffsetY)
                if i == 1 then
                    offsetx = targetOffsetX + x * KUMA_ATTACK_SPREAD_FACTOR
                    offsety = targetOffsetY + y * KUMA_ATTACK_SPREAD_FACTOR
                else
                    offsetx = targetOffsetX - x * KUMA_ATTACK_SPREAD_FACTOR
                    offsety = targetOffsetY - y * KUMA_ATTACK_SPREAD_FACTOR
                end
            end

            t.x = t.x + offsetx
            t.y = t.y + offsety
            t.target = {x = x + targetOffsetX, y = y + targetOffsetY}
            t.img = img.kumaAttack

            Bullet(t)
        end
        self:setAttackCooldown(ATTACK_COOLDOWN_KUMA)

    elseif self.form == NEKO then
        self:nekoFire()

    elseif self.form == USAGI then
        self:usagiFire(0)
        Timer.after(USAGI_BURST_TIME, function() self:usagiFire(1) end)
        Timer.after(USAGI_BURST_TIME * 2, function() self:usagiFire(2) end)
        self:setAttackCooldown(ATTACK_COOLDOWN_USAGI)
    end
end

function Player:nekoFire()
    Util.sound('rocketFire', 0.2)
    self:fireBullet({
        onHit = self:getNekoOnHitCallback(),
        onRemove = function()
            if player and player.form == NEKO then
                self:resetAttackCooldown()
            end
        end,
        damage = BULLET_DAMAGE_NEKO,
        speed = BULLET_SPEED_NEKO,
        img = img.bulletNeko,
    })
    self:setAttackCooldown(ATTACK_COOLDOWN_NEKO)
    self:nekoKnockback()
end

function Player:getNekoOnHitCallback()
    return function(x, y)
        Util.sound('rocketExplosion', 0.3)

        local count = 15
        for i=1, count do
            local t = {
                damage = 2,
                x = x,
                y = y,
                speed = BULLET_SPEED_USAGI + (BULLET_SPEED_USAGI * rng() - 0.5 * BULLET_SPEED_USAGI) * 0.7,
                direction = (i / count * 2) + (rng() * 1/count),
                duration = 0.25,
                friendly = true,
                img = img.bulletSmall,
                imgColorFilter = {255, 255, 255, 255},
            }
            Bullet(t)
            local t2 = {
                damage = 1,
                x = x,
                y = y,
                speed = BULLET_SPEED_USAGI + (BULLET_SPEED_USAGI * rng() - 0.5 * BULLET_SPEED_USAGI) * 0.7,
                direction = (i / count * 2) + (rng() * 1/count),
                duration = 0.25,
                friendly = true,
                img = img.bulletPlayer,
                imgColorFilter = {255, 255, 255, 255},
            }
            -- t.damage = 1
            -- t.img = img.bulletPlayer
            Bullet(t2)
        end
    end
end

function Player:usagiFire(spread_factor)
    if not player then
        return
    end

    Util.sound('playerShot')
    self:fireBullet({
        damage = BULLET_DAMAGE_USAGI,
        speed = BULLET_SPEED_USAGI,
        img = img.bulletPlayer,
        angle = USAGI_SPREAD * rng() * spread_factor - USAGI_SPREAD * 0.5 * spread_factor
    })
end

function Player:fireBullet(t)
    local x, y = self:getCenter()
    local mx, my = Util:mousePos()

    t.x = x + (self.img_mirror and (self.offsetFireX * -1) or self.offsetFireX)
    t.y = y + self.offsetFireY

    t.target = {x = mx, y = my}
    t.friendly = true

    Bullet(t)
end

function Player:resetAttackCooldown()
    self.canAttack = true

    if self.attackCooldownTimer then
        Timer.cancel(self.attackCooldownTimer)
    end
end

function Player:setAttackCooldown(cd)
    self.canAttack = false

    if self.attackCooldownTimer then
        Timer.cancel(self.attackCooldownTimer)
    end

    self.attackCooldownTimer = Timer.after(cd, function() self.canAttack = true end)
end

function Player:nekoKnockback()
    local x, y = self:getRect()
    local mx, my = Util:mousePos()
    self:setSpeed(Util.vectorBetween(x, y, mx, my, NEKO_KNOCKBACK_SPEED * -1))
end

function Player:handleOutOfBounds()
    local x, y = self:getRect()

    self:setPosAbs(
        Util.clamp(x, GAME_MIN_X, GAME_MAX_X),
        Util.clamp(y, GAME_MIN_Y, GAME_MAX_Y)
    )
end

function Player:draw()
    local x = self:getCenter()
    local mx = Util:mousePos()
    self.img_mirror = (mx < x)

    Seibutsu.draw(self)
end

function Player:remove()
    self.game:gameOver()

    Seibutsu.remove(self)

    player = nil
end

return Player
