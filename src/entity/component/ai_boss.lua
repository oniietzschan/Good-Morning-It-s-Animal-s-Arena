local AiBoss = class('AiBoss', AiBase)

AiBoss.behaviours = {
    {o = 1,    v = 'towardsPlayer'},
}

function AiBoss:towardsPlayer()
    self.parent:setAnimation('walk')

    local x, y = self.parent:getCenter()
    local player = game:getPlayerPos()
    self.parent:setSpeed(Util.vectorBetween(x, y, player.x, player.y, self.parent.speed))

    self:nextActionIn(0.15 + rng() * 0.2)
end

return AiBoss
