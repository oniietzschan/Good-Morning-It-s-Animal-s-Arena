local Particles = class('Particles', BaseFrill)

local defaultColors = {
    255, 255, 255, 255,
    255, 255, 255, 0,
}
local defaultAreaSpread = {'uniform', 0, 0}
local defaultTangentialAcceleration = {0, 0}

function Particles:initialize(t)
    t = t or {}

    self.ps = lg.newParticleSystem(t.image.image, 1024)
    self.ps:setQuads(unpack(t.quads or t.image.quads))
    self.ps:setColors(unpack(t.colors or defaultColors))

    self.ps:setEmissionRate(t.emissionRate or 0)
    self.ps:setParticleLifetime(unpack(t.particleLifetime))
    self.ps:setAreaSpread(unpack(t.areaSpread or defaultAreaSpread))

    self.ps:setSpeed(unpack(t.speed))
    self.ps:setDirection(t.direction or 0)
    self.ps:setSpread(t.spread or 0)
    self.ps:setTangentialAcceleration(unpack(t.tangentialAcceleration or defaultTangentialAcceleration))

    BaseFrill.initialize(self, t)
end

function Particles:remove()
    self.parent = nil

    print(self.layer)

    game:addEntity(self)

    -- self.ps:pause()

    -- Remove after all particles have disappeared
    local _, maxParticleLife = self.ps:getParticleLifetime()
    Timer.after(maxParticleLife, function() game:removeEntity(self) end)
end

function Particles:update(dt)
    if self.parent then
        local x, y = self.parent:getRect()
        self.ps:setPosition(x + self.offsetX, y + self.offsetY, 0)
    end

    self.ps:update(dt)
end

-- Todo: optimize
function Particles:isVisible()
    return true
end

function Particles:draw()
    lg.draw(self.ps, 0, 0)
end

return Particles
