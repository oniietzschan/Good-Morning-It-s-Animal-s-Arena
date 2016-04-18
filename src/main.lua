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
sound = nil
tiles = nil
world = nil

la = love.audio
lg = love.graphics
lm = love.mouse

local loveRng = love.math.newRandomGenerator(os.time())
rng = function(min, max) return loveRng:random(min, max) end

local boipushy = require 'lib.boipushy'
class = require 'lib.middleclass'
Serpent = require 'lib.serpent'
require "socket"
Timer = require "lib.hump.timer"
Vector = require "lib.hump.vector-light"
_ = require 'lib.moses'

require 'system.constants'
InfProt = require 'system.inf_prot'
TemplateParser = require 'system.template_parser'
util = require 'system.util'
Util = util

Image = require 'entity.image'

Base = require 'entity.base'

Component  = require 'entity.component.component'
AiEnemy    = require 'entity.component.ai_enemy'
Friendly   = require 'entity.component.friendly'
Living     = require 'entity.component.living'
Motion     = require 'entity.component.motion'
Unfriendly = require 'entity.component.unfriendly'

Bullet = require 'entity.bullet.bullet'

BaseFrill = require 'entity.frill.base_frill'
Frill     = require 'entity.frill.frill'
Particles = require 'entity.frill.particles'
Shadow    = require 'entity.frill.shadow'

Seibutsu = require 'entity.seibutsu.seibutsu'
Enemy    = require 'entity.seibutsu.enemy'
Player   = require 'entity.seibutsu.player'

Tile  = require 'entity.tiles.tile'
Grass = require 'entity.tiles.grass'

MapFactory = require 'map.map_factory'

Room         = require 'map.room.room'
StartingRoom = require 'map.room.starting_room'

Scene = require 'scene.scene'
Game  = require 'scene.game'
Ui    = require 'scene.ui'

local images = {
    bulletEnemy = {'assets/bullet_enemy.png', 5, 5},
    bulletNeko = {'assets/bullet_neko.png', 8, 8},
    bulletSmall = {'assets/bullet_small.png', 4, 4},
    bulletPlayer = {'assets/bullet_player.png', 5, 5},
    crosshair = {'assets/crosshair.png', 14, 14},
    enemy = {'assets/enemy.png', 38, 28},
    grass = {'assets/grass.png', 32, 32},
    kuma = {'assets/kuma.png', 29, 31},
    kumaAttack = {'assets/kuma_attack.png', 27, 15},
    neko = {'assets/neko.png', 33, 28},
    pixel = {'assets/pixel.png', 1, 1},
    shadow = {'assets/shadow.png', 16, 9},
    square = {'assets/square.png', 16, 16},
    transformReady = {'assets/transform_ready.png', 126, 12},
    usagi = {'assets/usagi.png', 29, 31},
}

local sounds = {
    enemyDeath = {
        path = 'assets/sound/enemy_death.wav',
        volume = 0.6,
    },
    enemyHurt = {
        path = 'assets/sound/enemy_hurt.wav',
        volume = 0.45,
    },
    enemyShootShort = {
        path = 'assets/sound/enemy_shoot_short.wav',
        volume = 0.35,
    },
    enemyShootMedium = {
        path = 'assets/sound/enemy_shoot_medium.wav',
        volume = 0.4,
    },
    enemyShootLong = {
        path = 'assets/sound/enemy_shoot_long.wav',
        volume = 0.5,
    },
    playerHurt = {
        path = 'assets/sound/player_hurt.wav',
        volume = 1,
    },
    playerShot = {
        path = 'assets/sound/player_shot.wav',
        volume = 0.7,
    },
    playerCanTransform = {
        path = 'assets/sound/player_can_transform.wav',
        volume = 0.85,
    },
    playerTransform = {
        path = 'assets/sound/player_transform.wav',
        volume = 0.7,
    },
    rocketExplosion = {
        path = 'assets/sound/rocket_explosion.wav',
        volume = 0.75,
    },
    rocketFire = {
        path = 'assets/sound/rocket_fire.wav',
        volume = 0.75,
    },
}

local scenes = {}

function love.load(arg)
    initInput()
    initGraphics()
    initSound()
    initScenes()
end

function initInput()
    input = boipushy()

    local default_binds = {
        up = {'w', 'up', 'dpup'},
        down = {'s', 'down', 'dpdown'},
        left = {'a', 'left', 'dpleft'},
        right = {'d', 'right', 'dpright'},
        -- confirm = {'z', 'fdown', 'space', 'enter'},
        -- cancel = {'x', 'fright'},
        [KUMA]  = {'q', '1', 'fleft'},
        [USAGI] = {'e', '2', 'fup'},
        [NEKO]  = {'r', '3', 'fright'},
        [ATTACK] = {'mouse1'},
        -- focus = {'lshift', 'rshift', 'fleft'},
        quit = {'escape', 'back', 'start'},
        [RESTART] = {'r'},
        f1  = {'f1'},
        -- f2  = {'f2'},
        -- f3  = {'f3'},
        -- f4  = {'4', 'f4'},
        -- f5  = {'5', 'f5'},
        -- f6  = {'6', 'f6'},
        -- f7  = {'7', 'f7'},
        -- f8  = {'8', 'f8'},
        -- f9  = {'9', 'f9'},
        -- f10 = {'0', 'f10'},
        -- f11 = {'f11'},
        -- f12 = {'f12'},
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

    lg.setBackgroundColor(0, 0, 0)
    lg.setDefaultFilter('nearest', 'nearest')
    lg.setLineStyle('rough')

    canvas       = lg.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)
    canvas_debug = lg.newCanvas(CAMERA_WIDTH, CAMERA_HEIGHT)

    img = {}
    for name,t in pairs(images) do
        local path, quad_w, quad_h = unpack(t)
        img[name] = Image(path, quad_w, quad_h)
    end
    tiles = require 'system/tiles'
end

function initSound()
    sound = {}
    for name, t in pairs(sounds) do
        local snd = la.newSource(t.path, "static")

        snd:setVolume(t.volume or 1)

        sound[name] = snd
    end
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
    lg.setCanvas(canvas)

    for _,scene in pairs(scenes) do
        if scene:isDisplay() then
            scene:draw()
        end
    end

    lg.setCanvas()
    lg.setColor(255, 255, 255)
    lg.draw(canvas, 0, 0, 0, _scale, _scale);
end
