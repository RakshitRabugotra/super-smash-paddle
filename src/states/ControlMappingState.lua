--[[
    The state to change the controls
]]

ControlMappingState = Class{__includes = BaseState}

function ControlMappingState:init()
    -- The options in this state
    self.menu = Menu {
        {'Fullscreen', function()
            self:getControl('FULLSCREEN')
            return CONTROLS.FULLSCREEN
        end, CONTROLS.FULLSCREEN},

        {'Pause Menu', function()
            self:getControl('PAUSE')
            return CONTROLS.PAUSE
        end, CONTROLS.PAUSE},

        {'PLAYER 1 - UP', function()
            self:getControl('PLAYER1_UP')
            return CONTROLS.PLAYER1_UP
        end, CONTROLS.PLAYER1_UP},

        {'PLAYER 1 - DOWN', function()
            self:getControl('PLAYER1_DOWN')
            return CONTROLS.PLAYER1_DOWN
        end, CONTROLS.PLAYER1_DOWN},

        {'PLAYER 2 - UP', function()
            self:getControl('PLAYER2_UP')
            return CONTROLS.PLAYER2_UP
        end, CONTROLS.PLAYER2_UP},

        {'PLAYER 2 - DOWN', function()
            self:getControl('PLAYER2_DOWN')
            return CONTROLS.PLAYER2_DOWN
        end, CONTROLS.PLAYER2_DOWN},

        {'Back to Settings', function()
            -- Refersh the player controls
            self:refreshPlayerControls()
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
    self.menu:render((VIRTUAL_HEIGHT/2)*0.4, 'medium')

    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)

end


function ControlMappingState:getControl(controlName)
    -- Transition to the get control input state
    gStateMachine:change('get-control-input', {
        ball = self.ball,
        player1 = self.player1,
        player2 = self.player2,
        -- The reference to this instance
        controlMappingStateRef = self,
        control = controlName
    })
end

function ControlMappingState:refreshPlayerControls()
    --[[
        Initializing the two players
    ]]
    PLAYER['1'].controls = {
        up = CONTROLS.PLAYER1_UP,
        down = CONTROLS.PLAYER1_DOWN
    }
    PLAYER['2'].controls = {
        up = CONTROLS.PLAYER2_UP,
        down = CONTROLS.PLAYER2_DOWN
    }

    self.player1 = Paddle {
        name = 'Player 1',
        player = PLAYER['1'],
        score = 0
    }

    self.player2 = Paddle {
        name = 'Player 2',
        player = PLAYER['2'],
        score = 0
    }
end