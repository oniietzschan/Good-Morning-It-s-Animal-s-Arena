local Grass = class('Grass', Tile)

function Grass:initialize(t)
    t.solid = true

    t.img = img.square

    Tile.initialize(self, t)
end

return Grass
