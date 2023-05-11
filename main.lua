--[[
    This is recreation of the class game 'Pong'
]]
require 'src/Dependencies'

function love.load()
    --[[
        Set the default filter
    ]]
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seed the RNG
    math.randomseed(os.time())

    --[[
        Make the player color constants different
    ]]
    makePlayerColorDifferent()

    --[[
        Load the fonts
    ]]
    gFontSize = {
        ['small'] = 8,
        ['medium'] = 16,
        ['large'] = 32,
        ['huge'] = 56
    }
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', gFontSize['small']),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', gFontSize['medium']),
        ['large'] = love.graphics.newFont('fonts/font.ttf', gFontSize['large']),
        ['huge'] = love.graphics.newFont('fonts/font.ttf', gFontSize['huge'])
    }


    -- Set the title
    love.window.setTitle(GAME.TITLE)

    -- Setting up game state machine
    gameState = 'start'

    --[[
        Set up the screen
    ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = VSYNC,
        fullscreen = FULLSCREEN,
        resizable = RESIZABLE
    })

    --[[
        Load the sounds and music
    ]]
    gSounds = Sounds {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['pause-boom'] = love.audio.newSource('sounds/pause_boom.wav', 'static'),
        --[[
            SFX
        ]]
        -- Za-Warudo
        ['za-warudo-enter-voice'] = love.audio.newSource('sounds/SFX/za_warudo_enter_voice.mp3', 'static'), -- 4 seconds
        ['za-warudo-exit-voice'] = love.audio.newSource('sounds/SFX/za_warudo_exit_voice.mp3', 'static'), -- 3 seconds
        ['za-warudo-20-sec-enter'] = love.audio.newSource('sounds/SFX/za_warudo_20_seconds_enter.mp3', 'static'), -- 2 seconds
        ['za-warudo-20-sec-loop'] = love.audio.newSource('sounds/SFX/za_warudo_20_seconds_loop.mp3', 'static'), -- 9 seconds
        ['za-warudo-20-sec-exit'] = love.audio.newSource('sounds/SFX/za_warudo_20_seconds_exit.mp3', 'static'), -- 3 seconds
        -- Winning Music
        ['victory'] = love.audio.newSource('sounds/SFX/victory.mp3', 'stream'),

        --[[
            Music
        ]]
        -- Background Music
        ['bg-music'] = love.audio.newSource('sounds/music/background_music.wav', 'stream'),
    }
    -- kick off music
    gSounds:get('bg-music'):setLooping(true)
    gSounds:play('bg-music')

    --[[
        Initialize the ball
    ]]
    ball = Ball()

    --[[
        Initializing the two players
    ]]
    player1 = Paddle {
        name = 'Player 1',
        player = PLAYER['1'],
        score = 0
    }

    player2 = Paddle {
        name = 'Player 2',
        player = PLAYER['2'],
        score = 0
    }

    --[[
        Initializing a state machine to transition in between states
    ]]
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end
        ['win'] = function() return WinState() end,
        
        --[[
            Functionality states
        ]]
        ['settings'] = function() return SettingsState() end,
        ['choose-game-mode'] = function() return ChooseGameModeState() end,
        ['tips-credits'] = function() return TipsNCredits() end,
        ['control-mapping'] = function() return ControlMappingState() end,
    }
    gStateMachine:change('title', {
        ball = ball,
        player1 = player1,
        player2 = player2
    })

    --[[
        Setting up the keysPressed and .wasPressed methods
        for love.keyboard, to handle input outside the main file
    ]]
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    --[[
        This function will update the entities on the screen,
    ]]
    -- Updating the current state
    gStateMachine:update(dt)
    
    -- Empty the table so as to avoid unnecessary repetition
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    --[[
        This function will handle the keyspressed
    ]]
    -- For enterting debug mode
    if key == 'f3' then
        DEBUG_MODE = not DEBUG_MODE
    end
    -- For toggling fullscreen
    if key == 'f' or key == 'f11' then
        FULLSCREEN = not FULLSCREEN
        toggleFullscreen(FULLSCREEN)
    end

    -- Registering the key pressed
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    --[[
        Here we will render the objects on the screen
    ]]
    push:apply('start')

    -- For the original attari background color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Display debug information
    if DEBUG_MODE then
        -- Display the FPS
        displayFPS()
        -- Display other info
        displayDebugConsole()
    end

    -- Render the current state
    gStateMachine:render()

    -- If the game is paused then let the user know
    if PAUSED then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT/2 - gFontSize['large']/2, VIRTUAL_WIDTH, 'center')
    end

    -- Set the color back to defaults
    love.graphics.setColor(COLORS.DEFAULT)

    push:apply('end')
end
