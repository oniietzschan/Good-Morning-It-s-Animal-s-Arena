local Motion = class('Motion', Component)

function Motion:initialize(t)
    Component.initialize(self, t)

    self.parent.speedX = 0
    self.parent.speedY = 0
end

function Motion:update(dt)
    if self.parent.speedX == 0 and self.parent.speedY == 0 then
        return
    end

    local relX, relY = self.parent.speedX * dt, self.parent.speedY * dt

    local actualX, actualY, cols, len = self.parent:move(relX, relY)

    if len >= 1 then
        if not Util.floatsEqual(actualX, relX) and Util.sameSign(relX, self.parent.speedX) then
            self.parent.speedX = 0
        end
        if not Util.floatsEqual(actualY, relY) and Util.sameSign(relY, self.parent.speedY) then
            self.parent.speedY = 0
        end
    end

    self:removeIfOffScreen()
end

function Motion:removeIfOffScreen(x, y)
    -- local x, y = self.parent:getRect()
    -- if y > DEATH_LINE then
    --     self:remove('fell to her death. :(')
    -- elseif x < DEATH_LINE_X_MIN then
    --     self:remove('went too far west. :(')
    -- elseif x > DEATH_LINE_X_MAX then
    --     self:remove('went too far east. :(')
    -- end
end

function Motion:remove(msg)
    print(self.parent.class.name .. ' ' .. msg)

    self.parent:remove()
end

return Motion
