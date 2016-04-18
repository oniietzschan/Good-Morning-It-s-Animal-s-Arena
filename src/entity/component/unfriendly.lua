local Unfriendly = class('Unfriendly', Component)

function Unfriendly:update(dt)
    self:handleBulletCollision()
end

function Unfriendly:handleBulletCollision()
    local items, len = self.parent:queryCollision(function(other)
        return other.entity.friendly and other.entity:isInstanceOf(Bullet)
    end)

    for i,item in ipairs(items) do
        -- print('Unfriendly ' .. self.parent.id .. ' hit bullet ' .. item.entity.id)

        if self.parent.hp <= 0 then
            return
        end

        local damage = item.entity.damage
        if self.parent.armor then
            damage = damage - self.parent.armor
            if damage <= 0 then
                Util.sound('enemyArmor')
                item.entity:hitTarget()
                return
            end
        end

        if self.parent.hp >= 2 then
            Util.sound('enemyHurt')
        else
            Util.sound('enemyDeath')
        end


        self.parent:takeDamage(damage)
        self.parent.imgColorFilter = COLOR_ONHIT
        Timer.after(ONE_FRAME_30FPS, function() self.parent.imgColorFilter = COLOR_QT end)

        item.entity:hitTarget()
    end
end

return Unfriendly
