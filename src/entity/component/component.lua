local Component = class('Component')

function Component:initialize(t)
    self.parent = t.parent
end

return Component
