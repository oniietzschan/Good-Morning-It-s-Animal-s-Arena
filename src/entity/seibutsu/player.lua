local Player = class('Player', Seibutsu)

function Player:initialize(t)
    self.hp = 9
    self.maxSpeed = PLAYER_MAX_SPEED
    self.acceleration = PLAYER_ACCELERATION

    t.img = img.square

    Seibutsu.initialize(self, t)

    self:toUsagi()
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

    Seibutsu.update(self, dt)
end

function Player:handleChangeForm()
    if input:down('square') then
        self:toUsagi()
    end
    if input:down('triangle') then
        self:toKuma()
    end
end

function Player:toUsagi()
    self.form = USAGI

    self.imgColorFilter = {127, 127, 255, 255}
end

function Player:toKuma()
    self.form = KUMA

    self.imgColorFilter = {255, 127, 127, 255}
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

    self.speedX = Util.clamp(self.speedX, PLAYER_MAX_SPEED * -1, PLAYER_MAX_SPEED)
    self.speedY = Util.clamp(self.speedY, PLAYER_MAX_SPEED * -1, PLAYER_MAX_SPEED)
    if math.abs(self.speedX) > PLAYER_MAX_SPEED then
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

return Player
