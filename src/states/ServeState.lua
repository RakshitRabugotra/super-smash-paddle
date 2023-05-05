--[[
    Making a serve state
]]
ServeState = Class{__includes = BaseState}

function ServeState:init()
    self.servingPlayer = (math.random(2) == 1) and 1 or 2
end

function ServeState:enter(params)
    --[[
        Params is a table and it should contain
        - Ball object
        - 2 Paddle objects for both the players
        - The number dedicated to serving player
    ]]
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2
    self.game_mode = params.game_mode
    self.servingPlayer = params.servingPlayer or self.servingPlayer 

    -- Reseting the ball and players
    self.ball:reset()
    self.player1:reset()
    self.player2:reset()
end

function ServeState:update(dt)
    --[[
        Checking keyboard bindings
    ]]
    -- For exiting the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    --[[
        If the user presses the key 'space' then transition to plays-tate
    ]]
    if love.keyboard.wasPressed('space') then
        -- Give the ball a random velocity
        if self.servingPlayer == 1 then
            self.ball.dx = math.random(BALL.VELOCITY.MIN.X, BALL.VELOCITY.MAX.X)
        else
            self.ball.dx = math.random(-BALL.VELOCITY.MIN.X, -BALL.VELOCITY.MAX.X)
        end
        self.ball.dy = math.random(-BALL.VELOCITY.MAX.Y, BALL.VELOCITY.MAX.Y)

        -- Making the ball a little faster
        if math.abs(self.ball.dy) < BALL.VELOCITY.MIN.Y then
            -- Making the ball speed atleast the minimum speed
            self.ball.dy = (self.ball.dy < 0) and -BALL.VELOCITY.MIN.Y or BALL.VELOCITY.MIN.Y
        end

        -- gStateMachine is defined in main.lua
        gStateMachine:change('play', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode
        })
    end

    -- update the players only!
    if not(self.game_mode == GAME.MODES[3]) then
        self.player1:update(dt)
    end
    if self.game_mode == GAME.MODES[1] then
        self.player2:update(dt)
    end
end

function ServeState:render()
    -- Who's serving?
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Serve Player ' .. tostring((self.servingPlayer == 1 and 1 or 2)), 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*1.5, VIRTUAL_WIDTH, 'center')
    
    -- display the score
    displayPlayerStats(self.player1, self.player2)

    -- display the controls for each
    displayPlayerControls(self.player1, self.player2)

    -- Giving the user instruction to press SPACE to begin
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press SPACE to serve!', 0, VIRTUAL_HEIGHT/2 + gFontSize['small']*8, VIRTUAL_WIDTH, 'center')
    
    -- Render the ball and the paddles
    self.ball:render()
    self.player1:render()
    self.player2:render()
end