--[[
    This is our constants file
]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 429
VIRTUAL_HEIGHT = 262
    
-- Our game settings and booleans
GAME = {
    TITLE = 'Super Smash Paddle',
    MODES = {
        'P1 v P2',
        'P1 v COM',
        'COM v COM'
    },
    SETTINGS = {
        BG_MUSIC = true,
        ZA_WARUDO = true,
        SOUND_EFFECTS = true,
        VSYNC = true,
        FULLSCREEN = false,
        RESIZABLE = true,
    },
    WIN_SCORE = 10,
    SCORE_INCREMENT = 1,
    CORNER_INCREMENT = 3,
    CORNER_THRESHOLD = 10,
    PAUSED = false,
}

TRANSITION_COLORS = {
    [1] = {217/255, 87/255, 99/255, 1},
    [2] = {95/255, 205/255, 228/255, 1},
    [3] = {251/255, 242/255, 54/255, 1},
    [4] = {118/255, 66/255, 138/255, 1},
    [5] = {153/255, 229/255, 80/255, 1},
    [6] = {223/255, 113/255, 38/255, 1}
}

-- Colors used in the game
COLORS = {
    DEBUG = {212/255, 175/255, 55/255, 1},  -- Color used in debug console
    DEFAULT = {1, 1, 1, 1},                 -- White
    NEUTRAL = {0.5, 0.5, 0.5, 0.5},         -- Grey with 0.5 alpha
    PAUSED = {8/255, 89/255, 11/255, 1},    -- Dull Green
    PAUSED_SCREEN_COLOR = {1, 1, 0, 0.2},   -- Redish
    PAUSED_MENU_CHOOSE = {
        ACTIVE = {48/255, 242/255, 41/255, 1},      -- Bright Green
        INACTIVE = {28/255, 105/255, 49/255, 0.2},  -- Dark Green
    },
    PLAYER_1 = TRANSITION_COLORS[math.random(1, 6)],                -- Random color for our player
    PLAYER_2 = TRANSITION_COLORS[math.random(1, 6)],                -- Random color for our player
    MENU_CHOOSE = {
        ACTIVE = {3/255, 252/255, 115/255, 1},      -- Active menu color
        ACTIVE_INVERTED = {252/255, 3/255, 140/255, 1},
        INACTIVE = {252/255, 3/255, 140/255, 0.5}   -- Inactive menu color
    }
}

-- Our configuration of the ball
BALL = {
    WIDTH = 4,
    HEIGHT = 4,
    SPEED_INCREMENT_PRECENTAGE = 0.5,
    VELOCITY = {
        MAX = {
            X = 200,
            Y = 200
        },
        MIN = {
            X = 100,
            Y = 50
        }
    }
}
-- Our paddle and ball properties
PADDLE = {
    SPEED = 275,
    WIDTH = 5,
    HEIGHT = 40,
    HEIGHT_DECREMENT = 2,
    DECREMENT_ON_HIT = 2,
}
-- The max defense possible given paddle's height
PADDLE.MAX_DEFENSE = PADDLE.DECREMENT_ON_HIT * (PADDLE.HEIGHT/PADDLE.HEIGHT_DECREMENT) + 1
-- AI configuration for our paddle
PADDLE.AI = {
    INACCURACY = 3,                 -- This means AI will tend to miss every 1 shot out of 5
    MISS_SHOT_BY = {                -- This means AI will tend to miss the shot by margin of 'min' to 'max' pixels
        MIN = math.max(PADDLE.WIDTH/2, PADDLE.HEIGHT/2) + 1,
        MAX = math.max(PADDLE.WIDTH/2, PADDLE.HEIGHT/2) * 1.5
    },
    SPEED_DECREMENT_PERCENTAGE = 85 -- This means AI will be this percent slower than usual player
}

-- For debug purposes
DEBUG_MODE = false

-- Key mappings
PLAYER = {
    ['1'] = {
        controls = {
            up = 'w',
            down = 's'
        },
        color = COLORS.PLAYER_1,
        x_constraint = 0,
        y_position = VIRTUAL_HEIGHT/2 - PADDLE.HEIGHT/2
    },
    ['2'] = {
        controls = {
            up = 'up',
            down = 'down'
        },
        color = COLORS.PLAYER_2,
        x_constraint = VIRTUAL_WIDTH - PADDLE.WIDTH,
        y_position = VIRTUAL_HEIGHT/2 - PADDLE.HEIGHT/2
    }
}