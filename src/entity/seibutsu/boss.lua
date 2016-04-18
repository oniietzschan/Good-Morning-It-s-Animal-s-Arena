local Boss = class('Boss', Seibutsu)

function Boss:initialize(t)
    self.hp = 200
    self.armor = 2
    self.speed = ENEMY_BOSS_SPEED

    t.solid = true

    t.components = {
        Unfriendly,
    }

    t.w = 68
    t.h = 57

    t.img = img.tank
    t.img_offset_x = -4
    t.img_offset_y = -17

    Seibutsu.initialize(self, t)

    self:initComponent(AiBoss)


    self.offsetFireX = 36
    self.offsetFireY = -14
end

function Boss:initializeSpriteSheet()
    self.anim_cycle = 0

    local quads = self.img.quads

    self.animations = {
        stand = {
            frequency = 1,
            quads[2],
            quads[1],
        },
        walk = {
            frequency = 1.15,
            quads[2],
            quads[3],
            quads[4],
            quads[5],
            quads[6],
            quads[7],
            quads[8],
            quads[9],
        }
    }
end

function Boss:remove()
    self.game:addScore(100)

    Seibutsu.remove(self)
end

return Boss
