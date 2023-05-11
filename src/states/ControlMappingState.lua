--[[
    The state to change the controls
]]

ControlMappingState = Class{__includes = BaseState}

function ControlMappingState:init()
    -- The options in this state
    self.menu = Menu {
        {'Fullscreen', function()
            -- Transition to the get control input state
            gStateMachine:change('get-control-input', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2,
                -- The reference to this instance
                controlMappingStateRef = self,
                control = 'FULLSCREEN'
            })
            return CONTROLS.FULLSCREEN
        end, CONTROLS.FULLSCREEN},

        {'Pause Menu', function()
            -- Transition to the get control input state
            gStateMachine:change('get-control-input', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2,
                -- The reference to this instance
                controlMappingStateRef = self,
                control = 'PAUSE'
            })
            return CONTROLS.PAUSE
        end, CONTROLS.PAUSE},

        {'Back to Settings', function()
            -- Transition back to the settings
            gStateMachine:change('settings', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end}
    }

    -- To disable movement in the menu
    self.disableMenuMovement = false
end

function ControlMappingState:enter(params)
    -- Just to carry back to the setting state
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2

    -- Choose a random color for the title
    self.color = randomColor(TRANSITION_COLORS)
end

function ControlMappingState:exit()
end

function ControlMappingState:update(dt)
    -- Update the menu
    self.menu:update(dt, self.disableMenuMovement)
end

function ControlMappingState:render()
    -- Render the Title and menu

    -- The state title
    love.graphics.setColor(self.color)
    love.graphics.setFont(gFonts['large'])

    love.graphics.printf("Controls", 0, VIRTUAL_HEIGHT/2 - 3*gFontSize['large'], VIRTUAL_WIDTH, 'center')

    -- Render the menu
    self.menu:render((VIRTUAL_HEIGHT/2)*0.85, 'medium')

    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)

end
