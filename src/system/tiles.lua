local tile_data = {
    -- block = 4,
    -- grass_7 = 9,
    -- grass_8 = 10,
    -- grass_9 = 11,
}

local tiles = {}
for name,quad_num in pairs(tile_data) do
    tiles[name] = img.tiles.quads[quad_num]
end

return tiles
