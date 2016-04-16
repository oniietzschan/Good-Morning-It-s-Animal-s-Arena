local BaseFrill = class('BaseFrill')

function BaseFrill:initialize(t)
    t = t or {}

    self.parent = t.parent
    self.game = self.parent.game

    self.layer = t.layer or 'entity'

    self.offsetX = t.offsetX or 0
    self.offsetY = t.offsetY or 0
end

return BaseFrill
