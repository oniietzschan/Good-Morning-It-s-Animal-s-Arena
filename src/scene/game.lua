local bump = require 'lib.bump'

local Camera = require 'entity.camera'

local Game = class('Game', Scene)

function Game:initialize(t)
    t = t or {}

    game = self

    Scene.initialize(self, t)

    self.highScore = 0

    self:initCamera()
    self:startGame()
end

function Game:initCamera()
    self.camera = Camera(self)

    -- self.camera:newLayer('background')
    self.camera:newLayer('shadow')
    self.camera:newLayer('entity')
    -- self.camera:newLayer('player')
    self.camera:newLayer('particles')
    self.camera:newLayer('bulletPlayer')
    self.camera:newLayer('bulletEnemy')
    -- self.camera:newLayer('debug', 1, 1, function(camX, camY) self:drawDebug(camX, camY) end)

    self.drawDebug = false
end

function Game:drawDebug(camX, camY)
    if self.drawDebug == false then
        return
    end

    -- Select debug canvas
    local prev_canvas = lg.getCanvas()
    lg.setCanvas(canvas_debug)
    lg.clear()

    -- Draw bounding boxes
    local camPosX, camPosY = self.camera:getPosScaled(1, 1)
    for _,item in ipairs(world:getItems()) do
        if item.entity:isVisible(camPosX, camPosY, CAMERA_WIDTH, CAMERA_HEIGHT) then
            lg.setColor(
                (item.entity.solid) and {0, 0, 255} or {255, 0, 0}
            )
            local x, y, w, h = world:getRect(item)
            -- subtract (w - 1) and (h - 1) to draw inner border only.
            lg.rectangle('line', math.floor(x + 1.5), math.floor(y + 1.5), w - 1, h - 1)
        end
    end

    -- Switch to primary canvas and draw debug canvas overtop
    local cameraTransPosX, cameraTransPosY = self.camera:getPosForTranslation(1, 1)
    lg.setCanvas(prev_canvas)
    lg.setColor(255, 255, 255, 128)
    lg.draw(canvas_debug, -cameraTransPosX, -cameraTransPosY)

    lg.setColor(255, 255, 255, 255)
end

function Game:startGame()
    self._entities = {}
    self.nextId = 1

    self.score = 0
    self.isGameOver = false

    world = bump.newWorld(16)

    local factory = MapFactory({world = world})
    factory:generateLevel()
end

function Game:update(dt)
    -- Game pauses execution during window drag, so limit frame time to 30FPS.
    dt = math.min(dt, ONE_FRAME_30FPS)

    self:input(dt)
    self:updateEntities(dt)
end

function Game:input(dt)
    if input:pressed('f1') then
        self.drawDebug = not self.drawDebug
    end
    if self.isGameOver and input:released(RESTART) then
        self:restartGame()
    end
end

function Game:restartGame()
    for i,ent in pairs(self._entities) do
        ent:remove()
    end
    collectgarbage()
    Timer.clear()

    self:startGame()
end

function Game:updateEntities(dt)
    self:cache()

    for i,ent in pairs(self._entities) do
        ent:update(dt)
    end
end

function Game:cache()
    if player then
        local x, y = player:getRect()
        self.playerPos = {
            x = x + PLAYER_W / 2,
            y = y + PLAYER_H / 2,
        }
    end
end

function Game:draw()
    self:drawBackground()

    self.camera:draw()
end

function Game:drawBackground()
    lg.setColor(COLOR_QT)
    for y = 0, math.floor(GAME_MAX_Y / 32) + 1 do
        for x = 0, math.floor(GAME_MAX_X / 32) + 1 do
            lg.draw(img.grass.image, x * 32, y * 32)
        end
    end
end

function Game:addEntity(ent)
    self:addIdIfMissing(ent)

    self._entities[ent.id] = ent

    self.camera:addToLayer(ent.layer, ent)
end

function Game:addIdIfMissing(ent)
    if ent.id then
        return
    end

    ent.id = self.nextId
    self.nextId = self.nextId + 1
end

function Game:removeEntity(ent)
    self._entities[ent.id] = nil

    self.camera:removeFromLayer(ent.layer, ent)
end

function Game:getPlayerPos()
    return self.playerPos
end

function Game:isPlayerAlive()
    return player ~= nil
end

function Game:addScore(i)
    if not self.isGameOver then
        self.score = self.score + i
    end
end

function Game:gameOver()
    self.isGameOver = true

    if self.score > self.highScore then
        self.highScore = self.score
    end
end

return Game
