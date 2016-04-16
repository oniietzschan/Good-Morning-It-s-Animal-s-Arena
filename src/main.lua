require 'lib/strict'

-- Declare Globals
canvas = nil
canvas_debug = nil
font = nil
game = nil
img = nil
input = nil
new = nil -- boipushy's fault, not mine!!
player = nil
tiles = nil
world = nil

lg = love.graphics

local loveRng = love.math.newRandomGenerator(os.time())
rng = function(min, max) return loveRng:random(min, max) end

local boipushy = require 'lib.boipushy'
class = require 'lib.middleclass'
Serpent = require 'lib.serpent'
require "socket"
Timer = require "lib.hump.timer"
_ = require 'lib.moses'

require 'system.constants'
InfProt = require 'system.inf_prot'
TemplateParser = require 'system.template_parser'
util = require 'system.util'
Util = util

Image = require 'entity.image'

Base   = require 'entity.base'

Component         = require 'entity.component.component'
Living            = require 'entity.component.living'
Motion            = require 'entity.component.motion'

BaseFrill = require 'entity.frill.base_frill'
Frill     = require 'entity.frill.frill'
Particles = require 'entity.frill.particles'

Seibutsu = require 'entity.seibutsu.seibutsu'
Player   = require 'entity.seibutsu.player'

Tile           = require 'entity.tiles.tile'
Grass          = require 'entity.tiles.grass'

MapFactory     = require 'map.map_factory'

Room         = require 'map.room.room'
StartingRoom = require 'map.room.starting_room'

Scene = require 'scene.scene'
Game  = require 'scene.game'
Ui    = require 'scene.ui'

local images = {
    pixel = {'assets/pixel.png', 1, 1},
    square = {'assets/square.png', 16, 16},
}

local scenes = {}

function love.load(arg)
    initInput()
    initGraphics()
    initScenes()
end

function initInput()
    input = boipushy()

    local default_binds = {
        up = {'up', 'dpup'},
        down = {'down', 'dpdown'},
        left = {'left', 'dpleft'},
        right = {'right', 'dpright'},
        confirm = {'z', 'fdown', 'space', 'enter'},
        cancel = {'x', 'fright'},
        square = {'a', 'fleft'},
        triangle = {'s', 'fup'},
        focus = {'lshift', 'rshift', 'fleft'},
        quit = {'escape', 'back', 'start'},
        f1  = {'1', 'f1'},
        f2  = {'2', 'f2'},
        f3  = {'3', 'f3'},
        f4  = {'4', 'f4'},
        f5  = {'5', 'f5'},
        f6  = {'6', 'f6'},
        f7  = {'7', 'f7'},
        f8  = {'8', 'f8'},
        f9  = {'9', 'f9'},
        f10 = {'0', 'f10'},
        f11 = {'f11'},
        f12 = {'f12'},
        plus = {'+', '='},
        minus = {'-', '_'},
    }

    for action, binds in pairs(default_binds) do
        for i, bind in pairs(binds) do
            input:bind(bind, action)
        end
    end
end

function initGraphics()
    love.mouse.setVisible(false)

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    canvas       = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)
    canvas_debug = love.graphics.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    img = {}
    for name,t in pairs(images) do
        local path, quad_w, quad_h = unpack(t)
        img[name] = Image(path, quad_w, quad_h)
    end
    tiles = require 'system/tiles'
end

function initScenes()
    table.insert(scenes, Game({ running = true, display = true}))
    table.insert(scenes, Ui({ running = true, display = true}))
end

function love.update(dt)
    Timer.update(dt)

    globalInput(dt)

    for _,scene in pairs(scenes) do
        if scene:isRunning() then
            scene:update(dt)
        end
    end
end

function globalInput(dt)
    if input:pressed('quit') then
        love.event.push('quit')
    end
    if input:pressed('plus') then
        setScale(_scale + 1)
    end
    if input:pressed('minus') then
        setScale(_scale - 1)
    end
end

function setScale(val)
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    if val <= 0 or (_game_width * val > desktop_w) or (_game_height * val > desktop_h) then
        return
    end

    _scale = val

    love.window.setMode(_game_width * _scale, _game_height * _scale)
end

function love.draw()
    love.graphics.setCanvas(canvas)

    for _,scene in pairs(scenes) do
        if scene:isDisplay() then
            scene:draw()
        end
    end

    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(canvas, 0, 0, 0, _scale, _scale);
end
