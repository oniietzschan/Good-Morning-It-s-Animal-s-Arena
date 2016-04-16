local Enemy = class('Enemy', Seibutsu)

function Enemy:initialize(t)
    self.hp = 7
    self.speed = ENEMY_NORMAL_SPEED

    t.components = t.components or {}
    Util.tableConcat(t.components, {
        AiEnemy,
        Unfriendly,
    })

    t.img = img.square
    t.imgColorFilter = {64, 64, 64, 255}

    Seibutsu.initialize(self, t)

    self.canAttack = true
end

return Enemy
