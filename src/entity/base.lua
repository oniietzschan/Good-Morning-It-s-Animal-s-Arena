local Base = class('Base')

function Base:initialize(t)
    local x = t.x or 0
    local y = t.y or 0
    local w = t.w or 16
    local h = t.h or 16

    x = math.floor(x + 0.5)
    y = math.floor(y + 0.5)

    self.solid = t.solid or false

    self.layer = t.layer or 'entity'

    self.img = t.img or nil
    self.img_offset_x = t.img_offset_x or 0
    self.img_offset_y = t.img_offset_y or 0
    self.img_quad_w = t.img_quad_w or 16
    self.img_quad_h = t.img_quad_h or 16
    self.img_mirror = false
    self.imgColorFilter = t.imgColorFilter or {255, 255, 255, 255}

    self.frills = {}

    self:initializeSpriteSheet(t)

    self.game = game
    self.world = world
    self.obj = {
        entity = self,
        class = self.class.name,
        solid = self.solid,
    }
    self:add(x, y, w, h)

    self:initializeComponents(t.components)

    self.obj.living = self:hasComponent(Living)
end

function Base:add(x, y, w, h)
    self.world:add(self.obj, x, y, w, h)
    self.game:addEntity(self)
end

function Base:remove()
    self:removeFrill()

    self.world:remove(self.obj)
    self.game:removeEntity(self)
end

function Base:removeFrill()
    for _, frill in pairs(self.frills) do
        frill:remove()
    end
end

function Base:initializeComponents(components)
    self.components = {}

    if components == nil then
        return
    end

    for _, class in ipairs(components) do
        self:initComponent(class)
    end
end

function Base:initComponent(class, t)
    t = t or {}
    t.parent = self

    table.insert(self.components, class:new(t))
end

function Base:addFrill(class, t)
    t = t or {}
    t.parent = self

    local frill = class:new(t)
    table.insert(self.frills, frill)

    self.game.camera:addToLayer(frill.layer, frill)
end

function Base:initializeSpriteSheet(t)
    self.anim_curr_quad = t.quad or t.img.quads[1]
end

function Base:getRect()
    return self.world:getRect(self.obj)
end

function Base:setPosRel(relX, relY)
    local x, y = self:getRect()
    self.world:update(self.obj, relX + x, relY + y)
end

function Base:move(rel_x, rel_y)
    local x, y = self:getRect()

    local actualX, actualY, cols, len = self.world:move(self.obj, x + rel_x, y + rel_y, self.bumpFilter)

    for i = 1, len do
        self:handleComponentCollision(cols[i])
    end

    local actualRelativeX, actualRelativeY = actualX - x, actualY - y

    return actualRelativeX, actualRelativeY, cols, len
end

function Base.bumpFilter(this, other)
    if other.solid then
        return 'slide'
    else
        return 'cross'
    end
end

function Base:handleComponentCollision(col)
    for _,cmpt in ipairs(self.components) do
        if cmpt.handleCollision then
            cmpt:handleCollision(col)
        end
    end
end

function Base:queryCollision(filter)
    local x,y,w,h = self:getRect()

    return self.world:queryRect(x,y,w,h, filter)
end

function Base:update(dt)
    self:updateComponents(dt)
    self:updateFrill(dt)
end

function Base:updateComponents(dt)
    for _,cmpt in ipairs(self.components) do
        if cmpt.update then
            cmpt:update(dt)
        end
    end
end

function Base:updateFrill(dt)
    for _,f in pairs(self.frills) do
        if f.update then
            f:update(dt)
        end
    end
end

-- function Base:advanceAnimation(dt)
--     local frequency = self.anim_current.frequency or 1
--     self.anim_cycle = (self.anim_cycle + (frequency * dt)) % 1
--     local frame = math.floor(self.anim_cycle * #self.anim_current) + 1
--     self.anim_curr_quad = self.anim_current[frame]
-- end

function Base:isVisible(cam_x, cam_y, cam_w, cam_h)
    local self_x, self_y = self:getRect()
    local _, _, self_w, self_h = self.anim_curr_quad:getViewport()

    return (self_x + self_w) > cam_x
       and (self_y + self_h) > cam_y
       and self_x < cam_x + cam_w
       and self_y < cam_y + cam_h
end

function Base:draw()
    local x,y,w = self:getRect()
    local offset_x = self.img_offset_x
    local offset_y = self.img_offset_y
    local scale_x = 1

    if self.img_mirror then
        offset_x = w - offset_x
        scale_x = -1
    end

    lg.setColor(unpack(self.imgColorFilter))
    lg.draw(
        self.img.image,
        self.anim_curr_quad,
        math.floor(x + offset_x + 0.5),
        math.floor(y + offset_y + 0.5),
        0,
        scale_x,
        1
    )
    lg.setColor(255,255,255,255)
end

function Base:hasComponent(cmpt_class)
    for _,cmpt in ipairs(self.components) do
        if cmpt:isInstanceOf(cmpt_class) then
            return true
        end
    end

    return false
end

return Base
