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
    t.img_offset_x = -6
    t.img_offset_y = -17

    Seibutsu.initialize(self, t)

    self:initComponent(AiBoss)


    self.offsetFireX = 33
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
    self.game:addScore(1000)

    local x, y = self:getCenter()

    Seibutsu.remove(self)

    if player == nil then
        return
    end

    Util.sound('bossDeath')

    Particles({
        layer = 'particles',
        image = img.square,
        colors = {
            26, 61, 50, 255,
            26, 61, 50, 255,
            26, 61, 50, 0
        },
        x = x,
        y = y,
        emitCount = 500,
        particleLifetime = {0.35, 0.75},
        speed = {10, 175},
        spread = math.pi * 2,
    })

    Particles({
        layer = 'points',
        image = img.oneThousand,
        colors = {
            255, 255, 255, 255,
            255, 255, 255, 255,
            255, 255, 255, 255,
            255, 255, 255, 0
        },
        x = x,
        y = y,
        emitCount = 1,
        particleLifetime = {1.25, 1.25},
        speed = {50, 50},
        direction = math.pi * 1.5
    })
end

return Boss
