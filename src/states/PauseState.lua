--[[
    This is our state when the game is paused
]]
PauseState = Class{__includes = BaseState}

function PauseState:init()
    if not GAME.SETTINGS.ZA_WARUDO then return end

    self.wait_time = 0
    self.seconds_since_paused = 0
    
    -- Colors in the UI of paused state
    self.paused_opacity = 0
    self.neutral_opacity = 0

    -- Interval of 1 second
    self.interval = 1

    -- Exit when this many seconds have passed
    self.exit_seconds = 9

    Timer.tween(2, {
        -- tween bird's X to endX over bird.rate seconds
        [self] = {
            wait_time = 3,
            paused_opacity = 1,
            neutral_opacity = 1
        }
    }):finish(function()
        -- Now show the timer
        self.show_timer = true
        self.wait_timer = 0

        Timer.tween(self.exit_seconds, {
            [self] = {seconds_since_paused = self.exit_seconds}
        }):finish(function()
            -- Just making sure we're on the same page
            paused_opacity = 1
            neutral_opacity = 1

            Timer.tween(2, {
                [self] = {paused_opacity = 0, neutral_opacity = 0}
            }):finish(function() self:unpause() end)

        end)
        
        if GAME.SETTINGS.ZA_WARUDO then
            gSounds:stop('za-warudo-20-sec-loop')
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

    -- Loss the access to playstate instance
    self.playstate_instance = nil
end

function PauseState:update(dt)
    --[[
        If we press escape then exit
    ]]
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    --[[
        If we press 'p' then unpause the game
    ]]
    if love.keyboard.wasPressed('p') then
        self:unpause()
    end

    -- Updating the timer for wa-zarudo
    if GAME.SETTINGS.ZA_WARUDO then Timer.update(dt) end
end

function PauseState:render()
    -- Rendering all the things same as playstate
    self.playstate_instance:render(COLORS.PAUSED_SCREEN_COLOR)

    -- Putting an overlay on top of it
    --[[
        This can be a pause menu in future
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

    -- Revert to original colors
    love.graphics.setColor(COLORS.DEFAULT)
end

--[[
    Utility functions
]]
function PauseState:unpause()
    -- Unpause and revert to play state
    gStateMachine:change('play', {
        ball = self.ball,
        player1 = self.player1,
        player2 = self.player2,
        game_mode = self.game_mode,

        defensive_bonus = self.defensive_bonus,
        corner_bonus = self.corner_bonus,

        -- We're entering the game from paused state
        from_paused = true
    })
end