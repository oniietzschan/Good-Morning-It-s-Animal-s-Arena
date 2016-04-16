local Room = class('Room')

function Room:initialize(tbl)
    self.world = tbl.world
    self.x = 0
    self.y = 0

    self:generate(tbl)
end

function Room:createEntity(t)
    t.x = self.x + t.x
    t.y = self.y + t.y

    return t.class(t)
end

return Room
