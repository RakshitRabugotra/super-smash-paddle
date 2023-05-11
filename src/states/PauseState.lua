--[[
    This is our state when the game is paused
]]
PauseState = Class{__includes = BaseState}

-- For utility functions
require 'src/Util'

function PauseState:init()
    if not GAME.SETTINGS.ZA_WARUDO then return end

    -- To keep track of how long the game has been paused
    self.seconds_since_paused = 0

    -- To disable the menu controls during any transition
    self.canChooseOption = false
    
    -- Colors in the UI of paused state
    self.paused_opacity = 0
    self.neutral_opacity = 0

    -- The menu highlight color
    self.highlighted = 1

    -- Set the global volume to half
    gSounds:setGlobalVolume(GAME.SETTINGS.PAUSED_MENU_VOLUME)

    Timer.tween(1, {
        -- Entering in the Pause state
        [self] = {
            paused_opacity = 1,
            neutral_opacity = 1
        }
    }):finish(function()
        -- We can choose the option now
        self.canChooseOption = true

        -- Start the pause menu timer
        Timer.every(1, function()
            self.seconds_since_paused = self.seconds_since_paused + 1
        end)

        -- Start the time-loop sound
        if GAME.SETTINGS.ZA_WARUDO then
            gSounds:get('za-warudo-20-sec-loop'):setLooping(true)
            gSounds:play('za-warudo-20-sec-loop')
        end
    end)


    -- Create the menu
    self.menu = Menu {
        {"Resume", function()
            -- Stop the music
            gSounds:stop('za-warudo-20-sec-loop')
            -- Reset the volume
            gSounds:setGlobalVolume(GAME.SETTINGS.SOUND_EFFECTS_VOLUME)
            -- Unpause the game
            self:unpause()
        end},

        {"Main Menu", function()
            -- Stop the music
            gSounds:stop('za-warudo-20-sec-loop')

            -- Also reset the player and ball
            self.player1:reset()
            self.player2:reset()
            self.ball:reset()
            
            -- Play the exit sound
            gSounds:play('za-warudo-20-sec-exit')
            
            -- Reset the volume
            gSounds:setGlobalVolume(GAME.SETTINGS.SOUND_EFFECTS_VOLUME)

            -- Back to the main menu
            gStateMachine:change('title', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end},
    }

end

function PauseState:enter(params)
    -- Was the background music on?
    self.wasBGMOn = GAME.SETTINGS.BG_MUSIC

    -- If the background music is playing then toggle it off
    if self.wasBGMOn then
        toggleBackgroundMusic()
    end

    if GAME.SETTINGS.ZA_WARUDO then
        -- Za-warudo
        gSounds:stop('za-warudo-20-sec-enter')
        gSounds:play('za-warudo-20-sec-enter')
    elseif GAME.SETTINGS.SOUND_EFFECTS then
        -- Play a boom sound
        gSounds:stop('pause-boom')
        gSounds:play('pause-boom')
    end

    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2
    self.game_mode = params.game_mode

    -- Fetching additional info from play state
    self.defensive_bonus = params.defensive_bonus
    self.corner_bonus = params.corner_bonus

    -- playstate class variable
    self.playstate_instance = params.playstate_instance
end

function PauseState:exit()
    if not GAME.SETTINGS.ZA_WARUDO and GAME.SETTINGS.SOUND_EFFECTS then
        -- Play a boom sound
        gSounds:stop('pause-boom')
        gSounds:play('pause-boom')
    end

    -- If the game music was on, then resume
    if self.wasBGMOn then
        toggleBackgroundMusic()
    end


    -- Loose the access to playstate instance
    self.playstate_instance = nil
end

function PauseState:update(dt)
    --[[
        If we press escape then exit
    ]]

    -- Updating the timer for wa-zarudo
    if GAME.SETTINGS.ZA_WARUDO then Timer.update(dt) end

    -- If the timer hasn't begun, then don't let the player move in the menu
    if not self.canChooseOption then
        return
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.canChooseOption = false
    end

    -- Update the menu controls
    self.menu:update(dt)
end

function PauseState:render()
    -- Rendering all the things same as playstate
    self.playstate_instance:render(COLORS.PAUSED_SCREEN_COLOR)

    -- Putting an overlay on top of it
    local menuActiveColor = {COLORS.PAUSED_MENU_CHOOSE.ACTIVE[1], COLORS.PAUSED_MENU_CHOOSE.ACTIVE[2], COLORS.PAUSED_MENU_CHOOSE.ACTIVE[3], self.paused_opacity}
    local menuInactiveColor = {COLORS.PAUSED_MENU_CHOOSE.INACTIVE[1], COLORS.PAUSED_MENU_CHOOSE.INACTIVE[2], COLORS.PAUSED_MENU_CHOOSE.INACTIVE[3], self.paused_opacity}

    --[[
        This is the pause menu
    ]]
    -- Displaying the seconds passed since we paused the game
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(GAME.SETTINGS.ZA_WARUDO and {COLORS.PAUSED[1], COLORS.PAUSED[2], COLORS.PAUSED[3], self.paused_opacity} or COLORS.PAUSED)
    love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT/2 - gFontSize['large']/2, VIRTUAL_WIDTH, 'center')

    if GAME.SETTINGS.ZA_WARUDO then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor({COLORS.NEUTRAL[1], COLORS.NEUTRAL[2], COLORS.NEUTRAL[3], self.neutral_opacity})
        love.graphics.printf(tostring(math.floor(self.seconds_since_paused)) .. " seconds has passed", 0, VIRTUAL_HEIGHT/2 + gFontSize['large']/2 + gFontSize['small']/2, VIRTUAL_WIDTH, 'center')
    end

    --[[
        The options
    ]]
    self.menu:render(VIRTUAL_HEIGHT/2 + gFontSize['medium'], 'medium', 2, menuActiveColor, menuInactiveColor)

    -- Revert to original colors
    love.graphics.setColor(COLORS.DEFAULT)
end

--[[
    Utility functions
]]
function PauseState:unpause()
    -- We will make a sweet transition
    paused_opacity = 1
    neutral_opacity = 1

    -- Play the exit sound
    gSounds:play('za-warudo-20-sec-exit')

    -- Transition the opacity
    Timer.tween(2, {
        [self] = {paused_opacity = 0, neutral_opacity = 0}
    }):finish(function()
        -- Unpause and revert to play state
        gStateMachine:change('play', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode,
    
            defensive_bonus = self.defensive_bonus,
            corner_bonus = self.corner_bonus,
        })
    end)

end