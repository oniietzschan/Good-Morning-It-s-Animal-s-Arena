local Boss = class('Boss', Seibutsu)

function Boss:initialize(t)
    t.solid = true

    t.components = {
        AiBoss,
        Unfriendly,
    }

    t.w = 64
    t.h = 64

    t.img = img.square
    t.img_offset_x = 0
    t.img_offset_y = 0

    Seibutsu.initialize(self, t)

    self.hp = 500
    self.armor = 2
    self.speed = 40

    -- self.offsetFireX = 28
    -- self.offsetFireY = 3

    -- self:addFrill(Shadow, {
    --     layer = 'shadow',
    --     offsetX = 2,
    --     offsetY = 22,
    -- })
end

function Boss:initializeSpriteSheet()
    self.anim_cycle = 0

    local quads = self.img.quads

    self.animations = {
        stand = {
            quads[1],
        },
        walk = {
            frequency = 1,
            quads[1],
            -- quads[2],
            -- quads[3],
            -- quads[4],
            -- quads[5],
            -- quads[6],
            -- quads[7],
        }
    }
end

function Boss:remove()
    self.game:addScore(100)

    Seibutsu.remove(self)
end

return Boss
