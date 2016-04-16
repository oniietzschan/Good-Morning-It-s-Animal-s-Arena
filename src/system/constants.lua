-- Camera
CAMERA_WIDTH = 640
CAMERA_HEIGHT = 360
CAMERA_MIN_X = 0
CAMERA_MIN_Y = 0
CAMERA_MAX_X = 0
CAMERA_MAX_Y = 0

-- Game
PLAYER_W = 16
PLAYER_H = 16
GAME_MIN_X = 0
GAME_MIN_Y = 0
GAME_MAX_X = 640 - PLAYER_W
GAME_MAX_Y = 360 - PLAYER_H

BULLET_PLAYER_SPEED = 350

-- Forms
KUMA = 'kuma'
USAGI = 'usagi'
MAX_SPEED_USAGI = 128
MAX_SPEED_KUMA = 64
ACCELERATION_USAGI = MAX_SPEED_USAGI * 8
ACCELERATION_KUMA = MAX_SPEED_KUMA * 8
ATTACK_COOLDOWN_USAGI = 0.1

-- To Calculate: Walk Dampen Factor
-- 1 = 96 * x ** 0.3
-- 1/96 = x ** 0.3
-- log(x, 1/96) = 0.3
-- log10(1/96) / log10(x) = 0.3
-- log10(1/96) = 0.3 * log10(x)
-- log10(1/96) = 0.3 * log10(x)
-- log10(1/96) / 0.3 = log10(x)
-- 10 ** (log10(1/96) / 0.3) = x
-- 0.000000246847 = x
local time_to_stop = 0.225
local dampen_cutoff_speed = 1

WALK_DAMPEN_FACTOR = math.pow(10, (math.log10(dampen_cutoff_speed / MAX_SPEED_USAGI) / time_to_stop))

-- Input
ATTACK = 'attack'

-- Colors
COLOR_BLACK = {0, 0, 0}
COLOR_BLUE = {0, 0, 255}
COLOR_DARK_BLUE = {0, 0, 128}
COLOR_DARK_GREEN = {0, 128, 0}
COLOR_DARK_GREY = {64, 64, 64}
COLOR_DARK_RED = {128, 0, 0}
COLOR_GREEN = {0, 255, 0}
COLOR_RED = {255, 0, 0}
COLOR_WHITE = {255, 255, 255}
COLOR_QT = {255, 255, 255, 255}

-- Events
EVENT_TAKE_DAMAGE = 'takeDamage'

ONE_FRAME_30FPS = 0.03333
