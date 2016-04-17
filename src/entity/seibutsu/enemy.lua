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

    self:addFrill(Shadow, {
        layer = 'shadow',
        offsetX = 2,
        offsetY = 22,
    })

    self.canAttack = true
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

    Seibutsu.remove(self)
end

return Enemy
