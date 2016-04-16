-- Camera
CAMERA_WIDTH = 640
CAMERA_HEIGHT = 360
CAMERA_MIN_X = 0
CAMERA_MIN_Y = 0
CAMERA_MAX_X = 0
CAMERA_MAX_Y = 0

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
local player_max_speed = 96
local time_to_stop = 0.225
local dampen_cutoff_speed = 1

PLAYER_MAX_SPEED = player_max_speed
PLAYER_ACCELERATION = PLAYER_MAX_SPEED * 8
WALK_DAMPEN_FACTOR = math.pow(10, (math.log10(dampen_cutoff_speed / player_max_speed) / time_to_stop))

-- Forms
USAGI = 'usagi'
KUMA = 'kuma'

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

-- Events
EVENT_TAKE_DAMAGE = 'takeDamage'

ONE_FRAME_30FPS = 0.03333
