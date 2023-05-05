--[[
    This state will be us to choose a game mode
    between
    P1 v P2
    P1 v COM
    COM v COM   :) Because why not
]]
ChooseGameModeState = Class{__includes = BaseState}

function ChooseGameModeState:init()
    self.highlighted = 1
    self.game_mode = GAME.MODES[self.highlighted]
    self.option_color = randomColor(TRANSITION_COLORS)
end

function ChooseGameModeState:enter(params)
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2
end

function ChooseGameModeState:update(dt)
    -- For choosing between different options

    -- If the user presses the ENTER or RETURN key, then transition accordinagly
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.game_mode = GAME.MODES[self.highlighted]
        -- play the confirm sound
        gSounds:stop('confirm')
        gSounds:play('confirm')

        -- Checking the game mode and assigning AI accordingly
        if self.highlighted == 2 or self.highlighted == 3 then
            -- Player 2 will be controlled by AI
            self.player2.is_controlled_by_AI = true
            self.player2.ball = ball
        end

        if self.highlighted == 3 then
            -- Player 1 will be controlled by AI
            self.player1.is_controlled_by_AI = true
            self.player1.ball = ball
        end

        -- Transition to the play state
        gStateMachine:change('serve', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode
        })
    end
    
    -- Becuase there will be only 2 options intially
    -- We will cycle the value of self.highlighted between those two
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted > 1) and self.highlighted - 1 or 3
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted < 3) and self.highlighted + 1 or 1
    end
    --[[
        Checking keyboard bindings
    ]]
    -- For exiting the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ChooseGameModeState:render()
    --[[
        Message saying choose your game mode
    ]]
    love.graphics.setColor(self.option_color)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Choose your Game', 0, gFontSize['huge'], VIRTUAL_WIDTH, 'center')

    -- Giving some options
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)

    if self.highlighted == 1 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 1
    love.graphics.printf('P1 v P2', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*2, VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 2 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 2
    love.graphics.printf('P1 v COM', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*4, VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 3 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 3
    love.graphics.printf('COM v COM', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*6, VIRTUAL_WIDTH, 'center')


    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)
end