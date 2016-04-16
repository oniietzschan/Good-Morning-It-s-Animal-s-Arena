local Player = class('Player', Seibutsu)

function Player:initialize(t)
    self.hp = 9
    self.walk_speed_max = PLAYER_WALK_SPEED
    self.walk_acceleration = PLAYER_WALK_ACCELERATION

    t.img = img.square

    Seibutsu.initialize(self, t)
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
    self:handleWalking(dt)

    Seibutsu.update(self, dt)
end

function Player:handleWalking(dt)
    if input:down('left') then
        self:walk(true, dt)
    elseif input:down('right') then
        self:walk(false, dt)
    else
        self:dampenXSpeed(dt)
    end
end

function Player:walk(left, dt)
    self.img_mirror = left

    local rel_x_speed = self.walk_acceleration * dt
    if left then
        rel_x_speed = rel_x_speed * -1
    end

    self.speedX = self.speedX + rel_x_speed

    -- -- If switching directions, then damping can help us reverse
    -- if (rel_x_speed < 0 and self.speedX > 0) or (rel_x_speed > 0 and self.speedX < 0) then
    --     self:dampenXSpeed(dt)
    -- end

    local max_speed = PLAYER_RUN_SPEED

    if math.abs(self.speedX) > max_speed then
        local sign = util.choose(self.speedX > 0, 1, -1)
        self.speedX = self.walk_speed_max * sign
    end
end

function Player:dampenXSpeed(dt)
    self.speedX = self.speedX * math.pow(WALK_DAMPEN_FACTOR, dt)

    if math.abs(self.speedX) < 1 then
        self.speedX = 0
    end
end

return Player
