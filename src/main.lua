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
lf = love.filesystem
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
AiBase     = require 'entity.component.ai_base'
AiBoss     = require 'entity.component.ai_boss'
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
Boss    = require 'entity.seibutsu.boss'
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
    oneHundred = {'assets/100.png', 10, 6},
    oneThousand = {'assets/1000.png', 14, 6},
    bulletEnemy = {'assets/bullet_enemy.png', 7, 7},
    bulletNeko = {'assets/bullet_neko.png', 8, 8},
    bulletSmall = {'assets/bullet_small.png', 4, 4},
    bulletPlayer = {'assets/bullet_player.png', 5, 5},
    crosshair = {'assets/crosshair.png', 14, 14},
    enemy = {'assets/enemy.png', 38, 28},
    grass = {'assets/grass.png', 32, 32},
    heart = {'assets/heart.png', 7, 7},
    hitbox = {'assets/hitbox.png', 11, 15},
    kuma = {'assets/kuma.png', 29, 31},
    kumaAttack = {'assets/kuma_attack.png', 27, 15},
    neko = {'assets/neko.png', 44, 28},
    pixel = {'assets/pixel.png', 1, 1},
    shadow = {'assets/shadow.png', 16, 9},
    square = {'assets/square.png', 64, 64},
    tank = {'assets/tank.png', 81, 79},
    title = {'assets/title.png', 640, 360},
    transformReady = {'assets/transform_ready.png', 126, 12},
    usagi = {'assets/usagi.png', 29, 31},
}

local sounds = {
    bossDeath = {
        path = 'assets/sound/boss_death.wav',
        volume = 0.8,
    },
    enemyArmor = {
        path = 'assets/sound/enemy_armor.wav',
        volume = 0.35,
    },
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
        volume = 0.25,
    },
    enemyShootMedium = {
        path = 'assets/sound/enemy_shoot_medium.wav',
        volume = 0.2,
    },
    enemyShootLong = {
        path = 'assets/sound/enemy_shoot_long.wav',
        volume = 0.15,
    },
    kumaAttack = {
        path = 'assets/sound/kuma_attack.wav',
        volume = 0.6,
    },
    music = {
        path = 'assets/sound/music.mp3',
        volume = 0.9,
        stream = true,
    },
    playerHurt = {
        path = 'assets/sound/player_hurt.wav',
        volume = 1,
    },
    playerShot = {
        path = 'assets/sound/player_shot.wav',
        volume = 0.4,
    },
    playerCanTransform = {
        path = 'assets/sound/player_can_transform.wav',
        volume = 1,
    },
    playerTransform = {
        path = 'assets/sound/player_transform.wav',
        volume = 0.7,
    },
    rocketExplosion = {
        path = 'assets/sound/rocket_explosion.wav',
        volume = 0.55,
    },
    rocketFire = {
        path = 'assets/sound/rocket_fire.wav',
        volume = 0.75,
    },
}

local scenes = {}

local titleScreen

function love.load(arg)
    initInput()
    initGraphics()
    initSound()

    initScenes()
    -- titleScreen = true
end

function initInput()
    input = boipushy()

    local default_binds = {
        up = {'w', 'up', 'dpup'},
        down = {'s', 'down', 'dpdown'},
        left = {'a', 'left', 'dpleft'},
        right = {'d', 'right', 'dpright'},
        [FOCUS] = {'lshift', 'rshift', 'fleft'},
        [KUMA]  = {'q', '1', 'fleft'},
        [USAGI] = {'e', '2', 'fup'},
        [NEKO]  = {'r', '3', 'fright'},
        [ATTACK] = {'mouse1'},
        quit = {'escape', 'back', 'start'},
        [MUTE] = {'m'},
        [RESTART] = {'r'},
        plus = {'+', '=', 'kp+'},
        minus = {'-', '_', 'kp-'},
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
        local snd = la.newSource(t.path, t.stream and 'stream' or 'static')

        snd:setVolume(t.volume or 1)

        sound[name] = snd
    end

    -- play music
    sound.music:setLooping(true)
    la.play(sound.music)
end

function initScenes()
    table.insert(scenes, Game({ running = true, display = true}))
    table.insert(scenes, Ui({ running = true, display = true}))
end

function love.update(dt)
    Timer.update(dt)

    globalInput(dt)

    if titleScreen then
        if input:pressed(RESTART) then
            initScenes()
            titleScreen = false
        end

        return
    end

    for _,scene in pairs(scenes) do
        if scene:isRunning() then
            scene:update(dt)
        end
    end
end

function globalInput(dt)
    if input:pressed(MUTE) then
        if sound.music:getVolume() == 0 then
            sound.music:setVolume(1)
        else
            sound.music:setVolume(0)
        end
    end
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

    if titleScreen then
        lg.draw(img.title.image, 0, 0)
    end

    for _,scene in pairs(scenes) do
        if scene:isDisplay() then
            scene:draw()
        end
    end

    lg.setCanvas()
    lg.setColor(255, 255, 255)
    lg.draw(canvas, 0, 0, 0, _scale, _scale);
end
