local MapFactory = class('MapFactory')

function MapFactory:initialize(tbl)
    self.world = tbl.world
end

function MapFactory:generateLevel()
    local room = StartingRoom({
        world = self.world,
    })

    self:postInitialize()
end

function MapFactory:postInitialize()
    for _,ent in pairs(game._entities) do
        if ent.postInitialize then
            ent:postInitialize()
        end
    end
end

return MapFactory
