--[[
    Making a title scren state
]]
TitleState = Class{__includes = BaseState}

function TitleState:init()
    -- Title will loop thorugh these colors
    -- colors we'll use to change the title text
    self.colors = TRANSITION_COLORS

    -- time for a color change if it's been half a second
    self.colorTimer = Timer.every(1, function()
        
        -- shift every color to the next, looping the last to front
        -- assign it to 0 so the loop below moves it to 1, default start
        self.colors[0] = self.colors[6]

        for i = #self.colors, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)
end

function TitleState:enter(params)
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
end

function TitleState:update(dt)
    -- For choosing between different options

    -- If the user presses the ENTER or RETURN key, then transition accordinagly
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.highlighted == 1 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            -- Transition to the play state
            -- gStateMachine:change('choose-game-mode', {
            --     ball = self.ball,
            --     player1 = self.player1,
            --     player2 = self.player2
            -- })
            gStateMachine:change('serve', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
            
        elseif self.highlighted == 2 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            -- Transition to the settings state
            gStateMachine:change('settings', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })

        elseif self.highlighted == 3 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            -- Transition to the credits and tips
            gStateMachine:change('tips-credits', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        elseif self.highlighted == 4 then
            -- play the confirm sound
            gSounds:stop('confirm')
            gSounds:play('confirm')
            -- Quit the game with ease
            love.event.quit()
        end
    end
    
    -- We will cycle the value of self.highlighted between those two
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted > 1) and self.highlighted - 1 or 4
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted < 4) and self.highlighted + 1 or 1
    end
    --[[
        Checking keyboard bindings
    ]]
    -- For exiting the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end


    -- Updating the timer for our transition in colors
    Timer.update(dt)
end

function TitleState:render()
    --[[
        Rendering our title screen
    ]]
    -- The game title
    love.graphics.setColor(self.colors[1])
    love.graphics.setFont(gFonts['large'])

    love.graphics.printf(GAME.TITLE, 0, VIRTUAL_HEIGHT/2 - 3*gFontSize['large'], VIRTUAL_WIDTH, 'center')

    -- Giving some options
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)

    if self.highlighted == 1 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 1
    love.graphics.printf('Start Game', 0, VIRTUAL_HEIGHT/2 - gFontSize['medium'], VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 2 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 2
    love.graphics.printf('Settings', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium'], VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 3 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 2
    love.graphics.printf('Tips & Credits', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*3, VIRTUAL_WIDTH, 'center')

    -- Set the color to inactive
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 4 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    -- Printing option 3
    love.graphics.printf('Exit Game', 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*5, VIRTUAL_WIDTH, 'center')


    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)
end