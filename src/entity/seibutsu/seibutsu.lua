local Seibutsu = class('Seibutsu', Base)

function Seibutsu:initialize(t)
    t.components = t.components or {}
    Util.tableConcat(t.components, {
        Living,
        Motion,
    })

    Base.initialize(self, t)
end

function Seibutsu:update(dt)
    -- self:animate(dt)

    Base.update(self, dt)
end

-- function Seibutsu:animate(dt)
--     if self.climbing then
--         self:setAnimation('stand')
--     elseif self:onGround() then
--         if self.speedX == 0 then
--             self:setAnimation('stand')
--         else
--             self:setAnimation('walk')
--         end
--     else
--         self:setAnimation('air')
--     end

--     self:advanceAnimation(dt)
-- end

-- function Seibutsu:setAnimation(anim)
--     if self.anim_current_name ~= anim and self.animations[anim] ~= nil then
--         self.anim_current_name = anim
--         self.anim_current = self.animations[anim]
--         self.anim_cycle = 0
--     end
-- end

function Seibutsu:takeDamage(damage)
    self:event(EVENT_TAKE_DAMAGE, {damage = damage})
end

function Seibutsu:event(event, t)
    for _,cmpt in ipairs(self.components) do
        if cmpt.listen ~= nil then
            cmpt:listen(event, t)
        end
    end
end

return Seibutsu
