local Unfriendly = class('Unfriendly', Component)

function Unfriendly:update(dt)
    self:handleBulletCollision()
end

function Unfriendly:handleBulletCollision()
    local items, len = self.parent:queryCollision(function(other)
        return other.entity.friendly and other.entity:isInstanceOf(Bullet)
    end)

    for i,item in ipairs(items) do
        self.parent:takeDamage(item.entity.damage)
        self.parent.imgColorFilter = {96, 96, 96, 255}
        Timer.after(ONE_FRAME_30FPS, function() self.parent.imgColorFilter = {64, 64, 64, 255} end)

        item.entity:remove()
    end
end

return Unfriendly
