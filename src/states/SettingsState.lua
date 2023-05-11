--[[
    This state will contain some settings related to our game
]]
SettingsState = Class{__includes = BaseState}

require 'src/Util'

function SettingsState:init()
    --[[
        Options to toggle will be,
        BG music,
        Sound effects,
        vsync,
        za warudo
    ]]

    self.options = {
        ['Background Music'] = function() return self:ToggleBackgroundMusic() end,
        ['Sound Effects'] = function() return self:ToggleSoundEffects() end,
        ['Za Warudo'] = function() return self:ToggleZaWarudo() end,

        ['Vsync'] = function() return self:ToggleVysnc() end,
        ['Fullscreen'] = function() return self:toggleFullscreen() end,
    }
end

function SettingsState:enter(params)
    -- This will help tocycle through the given options
    self.highlighted = 1

    -- Params should contain a ball object and 2 paddle objects
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2

    -- Reset the ball & players
    self.ball:reset()
    self.player1:reset()
    self.player2:reset()

    -- Choose a random color for the title
    self.color = randomColor(TRANSITION_COLORS)
end

function SettingsState:exit()
end

function SettingsState:update(dt)

    -- The up and down keys for the player control
    local upKey = {
        PLAYER['1'].controls.up,
        PLAYER['2'].controls.up
    }
    local downKey = {
        PLAYER['1'].controls.down,
        PLAYER['2'].controls.down
    }

    -- If the user presses the ENTER or RETURN key, then transition accordinagly
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        -- play the confirm sound
        gSounds:stop('confirm')
        gSounds:play('confirm')

        if self.highlighted == 1 then
            -- Control Mapping state
            gStateMachine:change('control-mapping', {})

        if self.highlighted == 1 then
            -- Toggle Background music
            toggleBackgroundMusic()
            
        elseif self.highlighted == 2 then
            -- Toggle Sound effects
            toggleSoundEffects()

        elseif self.highlighted == 3 then
            -- Transition to the credits and tips
            gStateMachine:change('title', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end
    end

    -- We will cycle the value of self.highlighted between those two
    if love.keyboard.wasPressed(upKey[1]) or love.keyboard.wasPressed(upKey[2]) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted > 1) and self.highlighted - 1 or 3
    end

    if love.keyboard.wasPressed(downKey[1]) or love.keyboard.wasPressed(downKey[2]) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted < 3) and self.highlighted + 1 or 1
    end

    -- Updating the timer for our transition in colors
    Timer.update(dt)
end

function SettingsState:render()
    --[[
        Rendering the options that might be useful to change during or before,
        the gameplay
    ]]

    -- The game title
    love.graphics.setColor(self.color)
    love.graphics.setFont(gFonts['large'])

    love.graphics.printf("Settings", 0, VIRTUAL_HEIGHT/2 - 3*gFontSize['large'], VIRTUAL_WIDTH, 'center')

    -- Giving some options
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)

    if self.highlighted == 1 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 1
    local option = "Background Music: " .. (GAME.SETTINGS.BG_MUSIC and "ON" or "OFF")
    love.graphics.printf(option, 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*2, VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 2 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 2
    option = "Sound Effects: " .. (GAME.SETTINGS.SOUND_EFFECTS and "ON" or "OFF")
    love.graphics.printf(option, 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*4, VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 3 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 3
    love.graphics.printf('Main Menu', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*6, VIRTUAL_WIDTH, 'center')


    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)
end

