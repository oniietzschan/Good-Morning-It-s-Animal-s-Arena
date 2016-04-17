local Player = class('Player', Seibutsu)

function Player:initialize(t)
    self.hp = 1

    t.components = {
        Friendly,
    }

    t.w = WIDTH_USAGI
    t.h = HEIGHT_USAGI
    t.img_offset_x = IMG_OFFSET_X_USAGI
    t.img_offset_y = IMG_OFFSET_Y_USAGI

    t.img = img.usagi

    Seibutsu.initialize(self, t)

    self.canAttack = true

    -- self:toKuma()
    -- self:toNeko()
    self:toUsagi()

    self:addFrill(Shadow, {
        layer = 'shadow',
        offsetX = -2,
        offsetY = 14,
    })
end

function Player:toKuma()
    self.form = KUMA
    self.hp = 2

    self.maxSpeed = MAX_SPEED_KUMA
    self.acceleration = ACCELERATION_KUMA

    self.imgColorFilter = {255, 127, 127, 255}
end

function Player:toNeko()
    self.form = NEKO
    self.hp = 1

    self.maxSpeed = MAX_SPEED_NEKO
    self.acceleration = ACCELERATION_NEKO

    self.imgColorFilter = {127, 255, 127, 255}
end


function Player:toUsagi()
    self.form = USAGI
    self.hp = 1

    self.maxSpeed = MAX_SPEED_USAGI
    self.acceleration = ACCELERATION_USAGI

    self.imgColorFilter = COLOR_QT
end

function Player:initializeSpriteSheet()
    self.airborne = false
    self.anim_cycle = 0

    local quads = self.img.quads

    self.animations = {
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
end

function Player:remove()
    Seibutsu.remove(self)
    player = nil
end

function Player:update(dt)
    self:handleOutOfBounds()

    self:handleChangeForm(dt)
    self:handleWalking(dt)
    self:handleAttack(dt)

    Seibutsu.update(self, dt)
end

function Player:handleChangeForm()
    if input:down(KUMA) then
        self:toKuma()
    end
    if input:down(NEKO) then
        self:toNeko()
    end
    if input:down(USAGI) then
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
    local mx, my = Util:mousePos()
    local t = {
        x = x,
        y = y,
        target = {x = mx, y = my},
        friendly = true,
        imgColorFilter = {255, 255, 255, 255},
    }

    if self.form == KUMA then
        for i=1,2 do
            local t = Util.deepcopy(t)

            -- worst code every jfc
            local offsetx, offsety = 0, 0
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
            t.pierce = true
            t.damage = BULLET_DAMAGE_KUMA
            t.target = {x = x + targetOffsetX, y = y + targetOffsetY}
            -- t.angle = i - 0.5
            t.speed = BULLET_SPEED_KUMA
            t.duration = KUMA_ATTACK_DURATION
            t.img = img.kumaAttack

            Bullet(t)
        end
        self:setAttackCooldown(ATTACK_COOLDOWN_KUMA)

    elseif self.form == NEKO then
        t.onHit = self:getNekoOnHitCallback()
        t.damage = BULLET_DAMAGE_NEKO
        t.speed = BULLET_SPEED_NEKO
        t.img = img.bulletNeko
        Bullet(t)
        self:setAttackCooldown(ATTACK_COOLDOWN_NEKO)
        self:nekoKnockback()

    elseif self.form == USAGI then
        t.damage = BULLET_DAMAGE_USAGI
        t.speed = BULLET_SPEED_USAGI
        t.img = img.bulletPlayer
        Bullet(t)
        self:setAttackCooldown(ATTACK_COOLDOWN_USAGI)
    end
end

function Player:setAttackCooldown(cd)
    self.canAttack = false
    Timer.after(cd, function() self.canAttack = true end)
end

function Player:getNekoOnHitCallback()
    return function(x, y)
        for i=1,26 do
            Bullet({
                x = x,
                y = y,
                speed = BULLET_SPEED_USAGI,
                direction = i / 13,
                duration = 0.5,
                friendly = true,
                img = img.bulletSmall,
                imgColorFilter = {255, 255, 255, 255},
            })
        end
    end
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

return Player
