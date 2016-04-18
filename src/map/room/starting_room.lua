local StartingRoom = class('StartingRoom', Room)

DIST = 120
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
BOSS_SPAWN_POSITIONS = {
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.35}, -- 2:30
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.50}, -- 3:00
    {x = GAME_MAX_X + DIST, y = GAME_MAX_Y * 0.65}, -- 3:30
    {x = 0          - DIST, y = GAME_MAX_Y * 0.35}, -- 9:30
    {x = 0          - DIST, y = GAME_MAX_Y * 0.50}, -- 9:00
    {x = 0          - DIST, y = GAME_MAX_Y * 0.65}, -- 8:30
}
PACK_DIST = 72

function StartingRoom:generate()
    player = self:createEntity({
        x = 160,
        y = 160,
        class = Player,
    })

    self:startSpawns()
    -- self:test()
end

function StartingRoom:startSpawns()
    self:createSpawnDeck()

    self:spawnSomething()

    self.spawnPeriod = 4.6
    self:spawnCycle()
end

function StartingRoom:createSpawnDeck()
    self.spawnDeckIndex = 1
    self.spawnDeck = {
        {
            {class = Boss,  size = 1},
        },
        {
            {class = Enemy, size = 3},
            {class = Enemy, size = 3},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
        },
        {
            {class = Enemy, size = 3},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Boss,  size = 1},
        },
        {
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
        },
        {
            {class = Boss,  size = 1},
        },
        {
            {class = Enemy, size = 3},
            {class = Enemy, size = 3},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
        },
        {
            {class = Enemy, size = 2},
            {class = Enemy, size = 3},
            {class = Boss,  size = 1},
            {class = Boss,  size = 1},
        },
        {
            {class = Enemy, size = 2},
            {class = Enemy, size = 2},
            {class = Enemy, size = 3},
            {class = Enemy, size = 3},
        },
        {
            {class = Enemy, size = 10},
        },
        {
            {class = Boss,  size = 1},
        },
        {
            {class = Enemy, size = 8},
            {class = Enemy, size = 8},
        },
        {
            {class = Enemy, size = 3},
            {class = Enemy, size = 3},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
        },
        {
            {class = Enemy, size = 3},
            {class = Enemy, size = 3},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 4},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
            {class = Enemy, size = 5},
        },
        -- {
        --     {class = Enemy, size = 3},
        --     {class = Enemy, size = 5},
        -- },
    }
end

function StartingRoom:spawnCycle()
    Timer.after(self.spawnPeriod, function()
        self:spawnSomething()

        -- reduce time between spawns
        if self.spawnPeriod > 3.8 then
            self.spawnPeriod = self.spawnPeriod - 0.05
            print(self.spawnPeriod)
        end

        if game:isPlayerAlive() then
            self:spawnCycle()
        end
    end)
end

function StartingRoom:spawnSomething()
    local currentDeck = self.spawnDeck[self.spawnDeckIndex]

    local leftInDeck =_.countf(currentDeck, function(i, card) return not card.used end)
    if leftInDeck == 0 then
        self.spawnDeckIndex = self.spawnDeckIndex + 1
        currentDeck = self.spawnDeck[self.spawnDeckIndex]
        print('moving to spawnDeckIndex' .. self.spawnDeckIndex)
    end

    -- This is fucking terrible lmao
    if currentDeck == nil then
        print('DECK EXHAUSTED')
        currentDeck = Util.rngSelect({
            {o = 7, v = {{class = Enemy, size = 6}}},
            {o = 1, v = {{class = Boss, size = 1}}},
        })
        self.spawnDeck[self.spawnDeckIndex] = currentDeck
    end

    local card = Util.sampleValidate(currentDeck, function(card) return not card.used end)
    card.used = true

    -- local size = math.floor(rng() * 3) + 3 -- 3-5
    local possiblePositions = (card.class == Boss) and BOSS_SPAWN_POSITIONS or SPAWN_POSITIONS
    local pos = Util.sample(possiblePositions)

    self:spawnGroupAt(pos.x, pos.y, card.class, card.size)
end

function StartingRoom:spawnGroupAt(x, y, class, number)
    local relx, rely = Vector.rotate(math.pi * rng() * 2, PACK_DIST, 0)

    for i = 1, number do
        relx, rely = Vector.rotate(math.pi * 2 / number, relx, rely)
        self:createEntity({
            x = x + relx,
            y = y + rely,
            class = class,
        })

    end
end

function StartingRoom:test()
    self:createEntity({
        x = -100,
        y = 201,
        class = Boss,
    })
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
