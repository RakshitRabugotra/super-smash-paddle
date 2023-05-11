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

    -- Initialize the menu
    self.menu = Menu {
        {'Start Game', function()
            gStateMachine:change('serve', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end},
        {'Settings', function()
            -- Transition to the settings state
            gStateMachine:change('settings', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end},
        {'Tips & Credits', function()
            -- Transition to the credits and tips
            gStateMachine:change('tips-credits', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end},
        {'Exit Game', function()
            -- Quit the game with ease
            love.event.quit()
        end}, 
    }

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
    -- The menu we've created
    self.menu:update(dt)
    
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
    love.graphics.setColor(self.colors[1])
    -- The font of the Title
    love.graphics.setFont(gFonts['large'])
    -- The game title
    love.graphics.printf(GAME.TITLE, 0, VIRTUAL_HEIGHT/2 - 3*gFontSize['large'], VIRTUAL_WIDTH, 'center')
    
    -- The menu we request
    self.menu:render(VIRTUAL_HEIGHT/2, 'medium')

    -- Set the color to default
    love.graphics.setColor(COLORS.DEFAULT)
end