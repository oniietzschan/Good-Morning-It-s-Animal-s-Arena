io.stdout:setvbuf("no") -- console output to Sublime

function love.conf(t)
    _scale = 2
    _game_width = 640
    _game_height = 360
    _draw_offset_x = 0
    _draw_offset_y = 0

    t.window.title = "Good Morning! It's Animal's Arena! v1.0.0"
    t.window.icon = 'assets/icon.png'

    t.window.width = _game_width * _scale
    t.window.height = _game_height * _scale
    t.window.minwidth = _game_width
    t.window.minheight = _game_height
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"

    t.window.vsync = false
    t.window.msaa = 0
    t.window.highdpi = false

    t.version = "0.10.1"
    t.console = false
    t.identity = 'animals_arena_save'
    t.accelerometerjoystick = false
    t.gammacorrect = false

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = false
    t.modules.thread = false
    t.modules.timer = true
    t.modules.touch = false
    t.modules.video = false
    t.modules.window = true
end
