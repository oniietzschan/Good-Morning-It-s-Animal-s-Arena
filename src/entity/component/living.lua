local Living = class('Living', Component)

function Living:initialize(t)
    Component.initialize(self, t)

    self.parent.hp = self.parent.hp or 1
end

function Living:listen(event, t)
    if event == EVENT_TAKE_DAMAGE then
        self:takeDamage(t)
    end
end

function Living:takeDamage(t)
    if t.damage == nil then
        error('missing damage!')
    end

    self.parent.hp = self.parent.hp - t.damage

    if self.parent.hp <= 0 then
        self.parent:remove()
    end
end

return Living
