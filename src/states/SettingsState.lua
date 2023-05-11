--[[
    This state will contain some settings related to our game
]]
SettingsState = Class{__includes = BaseState}

require 'src/Util'

function SettingsState:init()
    --[[
        Options to toggle will be,
    ]]
    self.menu = Menu {
        {'Fullscreen', function()
            return toggleFullscreen() and "ON" or "OFF"
        end, (GAME.SETTINGS.FULLSCREEN) and "ON" or "OFF"},
        
        {'VSync', function()
            return toggleVysnc() and "ON" or "OFF"
        end, (GAME.SETTINGS.VSYNC and "ON" or "OFF")},

        {'Background Music', function()
            return toggleBackgroundMusic() and "ON" or "OFF" 
        end, (GAME.SETTINGS.BG_MUSIC) and "ON" or "OFF"},

        {'Sound Effects', function()
            return toggleSoundEffects() and "ON" or "OFF"
        end, (GAME.SETTINGS.SOUND_EFFECTS and "ON" or "OFF")},

        {'Main Menu', function()
            -- Transition to the credits and tips
            gStateMachine:change('title', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end}
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

    -- Update the menu
    self.menu:update(dt)

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

    -- Render the menu
    self.menu:render((VIRTUAL_HEIGHT/2)*0.85, 'medium')

    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)
end

