local Enemy = class('Enemy', Seibutsu)

function Enemy:initialize(t)
    self.hp = 7
    self.speed = ENEMY_NORMAL_SPEED

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        AiEnemy,
        Unfriendly,
    })

    t.w = 16
    t.h = 28

    t.img = img.enemy
    t.img_offset_x = -6
    t.img_offset_y = 0

    Seibutsu.initialize(self, t)

    self.offsetFireX = 28
    self.offsetFireY = 3

    self:addFrill(Shadow, {
        layer = 'shadow',
        offsetX = 2,
        offsetY = 22,
    })
end

function Enemy:initializeSpriteSheet()
    self.anim_cycle = 0

    local quads = self.img.quads

    self.animations = {
        stand = {
            quads[1],
        },
        walk = {
            frequency = 1,
            quads[2],
            quads[3],
            quads[4],
            quads[5],
            quads[6],
            quads[7],
        }
    }
end

function Enemy:remove()
    self.game:addScore(100)

    local x, y = self:getCenter()

    Seibutsu.remove(self)

    if player == nil then
        return
    end

    Particles({
        layer = 'particles',
        image = img.square,
        colors = {
            72,  148, 111, 255,
            72,  148, 111, 255,
            72,  148, 111, 0
        },
        x = x,
        y = y,
        emitCount = 200,
        particleLifetime = {0.25, 0.5},
        speed = {25, 100},
        spread = math.pi * 2,
    })

    Particles({
        layer = 'points',
        image = img.oneHundred,
        colors = {
            255, 255, 255, 255,
            255, 255, 255, 255,
            255, 255, 255, 255,
            255, 255, 255, 0
        },
        x = x,
        y = y,
        emitCount = 1,
        particleLifetime = {1, 1},
        speed = {50, 50},
        direction = math.pi * 1.5
    })
end

return Enemy
