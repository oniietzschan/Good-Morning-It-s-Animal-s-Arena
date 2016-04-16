local Living = class('Living', Component)

function Living:initialize(t)
    Component.initialize(self, t)

    self.parent.hp = self.parent.hp or 1
    self.invuln_timer = 0
end

function Living:update(dt)
    if self.invuln_timer > 0 then
        self.invuln_timer = self.invuln_timer - dt

        self.parent.imgColorFilter = {255, 255, 255, 128} -- dim sprite during invulnerability

        if self.invuln_timer <= 0 then
            self.invuln_timer = 0
            self.parent.imgColorFilter = {255, 255, 255, 255}
        end
    end
end

function Living:listen(event, t)
    if event == EVENT_TAKE_DAMAGE then
        self:takeDamage(t)
    end
end

function Living:takeDamage(t)
    if t.damage == nil then
        print('missing damage!')
        return
    end


    if self.invuln_timer > 0 then
        return
    end

    self.parent.hp = self.parent.hp - t.damage
    self.invuln_timer = 1

    if self.parent.hp <= 0 then
        self.parent:remove()
    end
end

return Living
