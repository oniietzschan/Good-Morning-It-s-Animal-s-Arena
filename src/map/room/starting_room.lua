local StartingRoom = class('StartingRoom', Room)

DIST = 80
SPAWN_POSITIONS = {
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.25}, -- 2:30
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.50}, -- 3:00
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.75}, -- 3:30
    {x = 0          - DIST, y = GAME_MAX_Y * 0.25}, -- 9:30
    {x = 0          - DIST, y = GAME_MAX_Y * 0.50}, -- 9:00
    {x = 0          - DIST, y = GAME_MAX_Y * 0.75}, -- 8:30
    {x = GAME_MAX_X * 0.17, y = GAME_MAX_Y + DIST}, -- 4:00
    {x = GAME_MAX_X * 0.33, y = GAME_MAX_Y + DIST}, -- 5:00
    {x = GAME_MAX_X * 0.50, y = GAME_MAX_Y + DIST}, -- 6:00
    {x = GAME_MAX_X * 0.67, y = GAME_MAX_Y + DIST}, -- 7:00
    {x = GAME_MAX_X * 0.83, y = GAME_MAX_Y + DIST}, -- 8:00
    {x = GAME_MAX_X * 0.17, y = 0          - DIST}, -- 10:00
    {x = GAME_MAX_X * 0.33, y = 0          - DIST}, -- 11:00
    {x = GAME_MAX_X * 0.50, y = 0          - DIST}, -- 12:00
    {x = GAME_MAX_X * 0.67, y = 0          - DIST}, --  1:00
    {x = GAME_MAX_X * 0.83, y = 0          - DIST}, --  2:00
}
PACK_DIST = 48

function StartingRoom:generate()
    player = self:createEntity({
        x = 160,
        y = 160,
        class = Player,
    })

    -- self:test()
    self:startSpawns()
end

function StartingRoom:startSpawns()
    self:spawnSomething()
    self:spawnSomething()

    self.spawnPeriod = 6
    self:spawnCycle()
end

function StartingRoom:spawnCycle()
    Timer.after(self.spawnPeriod, function()
        self:spawnSomething()

        -- reduce time between spawns
        if self.spawnPeriod > 3 then
            self.spawnPeriod = self.spawnPeriod - 0.2
            print(self.spawnPeriod)
        end

        if game:isPlayerAlive() then
            self:spawnCycle()
        end
    end)
end

function StartingRoom:spawnSomething()
    local size = math.floor(rng() * 3) + 3 -- 3-5
    local pos = Util.sample(SPAWN_POSITIONS)
    self:spawnGroupAt(pos.x, pos.y, size)
end

function StartingRoom:spawnGroupAt(x, y, number)
    local relx, rely = Vector.rotate(math.pi * rng() * 2, PACK_DIST, 0)

    for i = 1, number do
        relx, rely = Vector.rotate(math.pi * 2 / number, relx, rely)
        self:createEntity({
            x = x + relx,
            y = y + rely,
            class = Enemy,
        })

    end
end

function StartingRoom:test()
    self:createEntity({
        x = 320,
        y = 200,
        class = Enemy,
    })
    self:createEntity({
        x = 321,
        y = 201,
        class = Enemy,
    })
end

return StartingRoom
