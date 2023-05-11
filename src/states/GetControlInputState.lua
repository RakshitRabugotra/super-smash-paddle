--[[
    To get the control
]]

GetControlInputState = Class{__includes = BaseState}

function GetControlInputState:init()
end

function GetControlInputState:enter(params)
    -- Just to carry back to the setting state
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2

    -- Reference to the control mapping state
    self.controlMappingStateRef = params.controlMappingStateRef

    -- The variable we want to change
    self.control = params.control

    -- Choose a random color for the title
    self.color = randomColor(TRANSITION_COLORS)
end

function GetControlInputState:exit()
    -- Clear the reference
    self.controlMappingStateRef = nil
end

function GetControlInputState:update(dt)
    -- Fetch the input from the user
    -- As soon as the user presses a valid key, we will transition back to the
    -- control mapping state
    for i, key in ipairs(CONTROLS.VALID_KEYS) do
        -- If the user presses a valid key, then map that
        if love.keyboard.wasPressed(key) then
            -- Set the control to this key
            CONTROLS[self.control] = key

            -- Transition back to the contorl mapping state
            gStateMachine:change('control-mapping', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2,
            })
            break
        end
    end
end

function GetControlInputState:render()

    love.graphics.setColor(COLORS.PAUSED_MENU_CHOOSE.INACTIVE)
    -- Display a rectangle
    local width = VIRTUAL_WIDTH/1.8
    local height = VIRTUAL_HEIGHT/1.8
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH-width)/2, (VIRTUAL_HEIGHT-height)/2, width, height)

    -- Display the text on it
    love.graphics.setColor(COLORS.PAUSED_MENU_CHOOSE.ACTIVE)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press a key to map for:\n" .. tostring(self.control), 0, VIRTUAL_HEIGHT/2 - gFontSize['medium']/2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(COLORS.DEFAULT)
end