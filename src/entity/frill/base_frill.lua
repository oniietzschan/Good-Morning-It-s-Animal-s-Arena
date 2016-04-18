local BaseFrill = class('BaseFrill')

function BaseFrill:initialize(t)
    t = t or {}

    self.layer = t.layer or 'entity'

    if t.parent then
        self.parent = t.parent
        self.game = self.parent.game
    else
        self.ps:setPosition(t.x, t.y)
        self.ps:emit(t.emitCount)
        self:remove()
    end

    self.offsetX = t.offsetX or 0
    self.offsetY = t.offsetY or 0
    self.imgColorFilter = t.imgColorFilter or COLOR_QT
end

return BaseFrill
