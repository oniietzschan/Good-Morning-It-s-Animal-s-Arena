local Player = class('Player', Seibutsu)

function Player:initialize(t)
    self.hp = 9

    t.w = PLAYER_W
    t.h = PLAYER_H

    t.img = img.square

    Seibutsu.initialize(self, t)

    self.canAttack = true

    self:toUsagi()
end

function Player:toUsagi()
    self.form = USAGI

    self.maxSpeed = MAX_SPEED_USAGI
    self.acceleration = ACCELERATION_USAGI

    self.imgColorFilter = {127, 127, 255, 255}
end

function Player:toKuma()
    self.form = KUMA

    self.maxSpeed = MAX_SPEED_KUMA
    self.acceleration = ACCELERATION_KUMA

    self.imgColorFilter = {255, 127, 127, 255}
end

-- function Player:initializeSpriteSheet()
--     self.airborne = false
--     self.anim_cycle = 0

--     local quads = self.img.quads

--     self.animations = {
--         air = {
--             quads[15], -- quads[6],
--         },
--         stand = {
--             quads[7],
--         },
--         walk = {
--             frequency = 1.9, -- 1.65,
--             quads[1],
--             quads[2],
--             quads[3],
--             quads[4],
--             quads[5],
--         }
--     }
-- end

function Player:remove()
    Seibutsu.remove(self)
    player = nil
end

function Player:update(dt)
    self:handleChangeForm(dt)
    self:handleWalking(dt)
    self:handleAttack(dt)

    Seibutsu.update(self, dt)

    self:handleOutOfBounds()
end

function Player:handleChangeForm()
    if input:down('square') then
        self:toUsagi()
    end
    if input:down('triangle') then
        self:toKuma()
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

    local x, y = Vector.normalize(x, y)

    self:walk(x, y, dt)

    if x == 0 then
        self:dampenXSpeed(dt)
    end
    if y == 0 then
        self:dampenYSpeed(dt)
    end
end

function Player:walk(x, y, dt)
    -- self.img_mirror = left

    local deltaSpeedX = x * dt * self.acceleration
    local deltaSpeedY = y * dt * self.acceleration

    self.speedX = self.speedX + deltaSpeedX
    self.speedY = self.speedY + deltaSpeedY

    -- -- If switching directions, then damping can help us reverse
    -- self:dampenSpeed(dt)

    self.speedX = Util.clamp(self.speedX, self.maxSpeed * -1, self.maxSpeed)
    self.speedY = Util.clamp(self.speedY, self.maxSpeed * -1, self.maxSpeed)
    if math.abs(self.speedX) > self.maxSpeed then
        local sign = Util.choose(self.speedX > 0, 1, -1)
        self.speedX = self.maxSpeed * sign
    end
end

function Player:dampenXSpeed(dt)
    self.speedX = self.speedX * math.pow(WALK_DAMPEN_FACTOR, dt)

    if math.abs(self.speedX) < 1 then
        self.speedX = 0
    end
end

function Player:dampenYSpeed(dt)
    self.speedY = self.speedY * math.pow(WALK_DAMPEN_FACTOR, dt)

    if math.abs(self.speedY) < 1 then
        self.speedY = 0
    end
end

function Player:handleAttack()
    if self.canAttack == false then
        return
    end

    local x, y, w, h = self:getRect()
    if self.form == USAGI then
        if input:down(ATTACK) then
            Bullet({
                x = x + w / 2 - 2,
                y = y + h / 2 - 2,
                friendly = true,
            })
            self:setAttackCooldown(ATTACK_COOLDOWN_USAGI)
        end
    end
end

function Player:setAttackCooldown(cd)
    self.canAttack = false
    Timer.after(cd, function() self.canAttack = true end)
end

function Player:handleOutOfBounds()
    local x, y = self:getRect()

    self:setPosAbs(
        Util.clamp(x, GAME_MIN_X, GAME_MAX_X),
        Util.clamp(y, GAME_MIN_Y, GAME_MAX_Y)
    )
end

return Player
