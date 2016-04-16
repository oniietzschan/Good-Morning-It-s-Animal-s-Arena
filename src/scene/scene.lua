local Scene = class('Scene')

function Scene:initialize(t)
    t = t or {}

    self.display = t.display or false
    self.running = t.running or false
end

function Scene:isDisplay()
    return self.display
end

function Scene:setDisplay(val)
    self.display = val
end

function Scene:isRunning()
    return self.running
end

function Scene:setRunning(val)
    self.running = val
end

function Scene:draw()
end

function Scene:update()
end

return Scene
