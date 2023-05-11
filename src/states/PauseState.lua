--[[
    This is our state when the game is paused
]]
PauseState = Class{__includes = BaseState}

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

end

function PauseState:enter(params)
    -- Stop the bg-music
    gSounds:pause('bg-music')

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

    if GAME.SETTINGS.BG_MUSIC then
        -- Resume the bg-music
        gSounds:play('bg-music')
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

    -- --[[
    --     If we press 'p' then unpause the game
    -- ]]
    -- if love.keyboard.wasPressed('p') then
    --     self:unpause()
    -- end

    -- If the timer hasn't begun, then don't let the player move in the menu
    if not self.canChooseOption then
        return
    end

    -- If the user presses the ENTER or RETURN key, then transition accordinagly
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        -- So that we can't change the option midway our transition
        self.canChooseOption = false

        -- Stop the time-loop sound
        gSounds:stop('za-warudo-20-sec-loop')
        -- Play the exit sound
        gSounds:play('za-warudo-20-sec-exit')

        if self.highlighted == 1 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            self:unpause()

        elseif self.highlighted == 2 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            -- Back to the main menu
            gStateMachine:change('title', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end
    end
    
    -- We will cycle the value of self.highlighted between those two
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted > 1) and self.highlighted - 1 or 2
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted < 2) and self.highlighted + 1 or 1
    end
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
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(menuInactiveColor)

    if self.highlighted == 1 then
        love.graphics.setColor(menuActiveColor)
    end
    -- Printing option 1
    love.graphics.printf("Resume", 0, VIRTUAL_HEIGHT/2 + 4*gFontSize['medium'], VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(menuInactiveColor)
    if self.highlighted == 2 then
        love.graphics.setColor(menuActiveColor)
    end
    -- Printing option 2
    love.graphics.printf("Main Menu", 0, VIRTUAL_HEIGHT/2 + 6*gFontSize['medium'], VIRTUAL_WIDTH, 'center')

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