local StartingRoom = class('StartingRoom', Room)

function StartingRoom:generate()
    -- self:createRect({x = 13, y = 18, w = 3}, {class = Grass})
    -- self:createRect({x = 12, y = 19, w = 5}, {class = Grass})
    -- self:createRect({x = 11, y = 20, w = 7}, {class = Grass})
    -- self:createRect({x = 10, y = 21, w = 10}, {class = Grass})

    player = self:createEntity({
        x = 10,
        y = 10,
        class = Player
    })

    self:createEntity({x = 20, y = 5, class = Enemy})
    self:createEntity({x = 20, y = 10, class = Enemy})
    self:createEntity({x = 20, y = 15, class = Enemy})
end

return StartingRoom
