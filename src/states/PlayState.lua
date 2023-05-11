--[[
    Making a play state
]]
PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- Set the defensive bonus variable
    self.defensive_bonus = 0

    -- Set the corner bonus
    self.corner_bonus = 0
end

function PlayState:enter(params)
    --[[
        Fetching the ball and players from the parameter
    ]]
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2
    self.game_mode = params.game_mode

    -- Set the defensive bonus variable // if defined in the params
    self.defensive_bonus = params.defensive_bonus or self.defensive_bonus

    -- Set the corner bonus // if defined in the params
    self.corner_bonus = params.corner_bonus or self.corner_bonus
end

function PlayState:update(dt)
    --[[
        The main game update logic here
    ]]
    --[[
        Checking for bonus defensive hit
    ]]
    local defense = math.max(self.player1.defensive_hit, self.player2.defensive_hit)
    local multiplier = GAME.WIN_SCORE/PADDLE.MAX_DEFENSE
    -- The defense bonus is
    self.defensive_bonus = multiplier * defense
    self.defensive_bonus = math.floor(self.defensive_bonus)

    --[[
        Checking if the ball collides a player   
    ]]
    self:checkAndPerformBallCollision()
    --[[
        Checking if a score has happened
    ]]
    self:checkAndIncrementScores()

    -- Checking if the game is over?
    self:onGameOver()

    --[[
        Checking keyboard bindings
    ]]
    -- For exiting the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- For pausing the game
    if love.keyboard.wasPressed(CONTROLS.PAUSE) then
        gStateMachine:change('pause', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode,
            -- Additional Info
            defensive_bonus = self.defensive_bonus,
            corner_bonus = self.corner_bonus,
            -- Passing in self for helping in rendering function of paused state
            playstate_instance = self,
        })
    end

    -- For reseting the game (debug only)
    if love.keyboard.wasPressed(DEBUG.HOTKEY) and DEBUG.IS_ON then
        gStateMachine:change('serve', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode
        })
    end

    -- update the ball
    self.ball:update(dt)

    -- update the players
    self.player1:update(dt)
    self.player2:update(dt)
end

function PlayState:render(global_color)
    --[[
        Rendering the main game
    ]]

    -- Draw a dashed line
    if not global_color then
        -- Drawing a dashed line only when we're not paused,
        -- i.e, global_color == nil
        love.graphics.drawDashedLine {
            start_ = {x = VIRTUAL_WIDTH/2, y=gFontSize['small']*2},
            end_ = {x = VIRTUAL_WIDTH/2, y=VIRTUAL_HEIGHT},
            step_ = 15,
            length_ = PADDLE.HEIGHT/4,
            width_ = 2,
            orient_ = 'vertical',
            color_ = COLORS.NEUTRAL
        }
    end

    -- display the defensive bonus
    love.graphics.setFont(gFonts['small'])
    -- changing the color when game is paused, i.e, global_color ~= nil
    love.graphics.setColor((global_color) and global_color or COLORS.DEFAULT)
    love.graphics.printf("Defensive bonus: +" .. tostring(self.defensive_bonus), 0, gFontSize['small']*0.2, VIRTUAL_WIDTH, 'center')

    -- display the game mode
    -- changing the color when game is paused, i.e, global_color ~= nil
    -- love.graphics.setColor((global_color) and global_color or COLORS.DEFAULT)
    -- love.graphics.printf(tostring(self.game_mode), 0, VIRTUAL_HEIGHT - gFontSize['small'], VIRTUAL_WIDTH, 'center')

    -- display the score
    displayPlayerStats(self.player1, self.player2, global_color)

    -- Debugging
    -- love.graphics.print("Miss shot   (P1): " .. tostring(self.player1.miss_shot), 16, 16)
    -- love.graphics.print("Miss pixels (P1): " .. tostring(self.player1.miss_pixels), 16, 32)

    -- love.graphics.print("Miss shot   (P2): " .. tostring(self.player2.miss_shot), 16, 64)
    -- love.graphics.print("Miss pixels (P2): " .. tostring(self.player2.miss_pixels), 16, 96)

    -- rendering the players to the screen
    self.player1:render(global_color)
    self.player2:render(global_color)

    -- rendering the ball
    self.ball:render(global_color)
end

--[[
    More functions for ease in update method
]]

function PlayState:checkAndPerformBallCollision()
    if self.ball:collides(player1) then
        self.player1.defensive_hit = self.player1.defensive_hit + 1

        -- Checking the defensive hits of the paddle
        if self.player1.defensive_hit % PADDLE.DECREMENT_ON_HIT == 0 and self.player1.defensive_hit ~= 0 then
            self.player1.height = player1.height - PADDLE.HEIGHT_DECREMENT
        end

        self.ball.dx = -self.ball.dx * (1 + BALL.SPEED_INCREMENT_PRECENTAGE/100)
        self.ball.x = self.player1.x + self.player1.width
        -- Play the sound cue
        if GAME.SETTINGS.SOUND_EFFECTS then gSounds:play('paddle_hit') end

    elseif self.ball:collides(player2) then
        self.player2.defensive_hit = self.player2.defensive_hit + 1

        -- Checking the defensive hits of the paddle
        if self.player2.defensive_hit % PADDLE.DECREMENT_ON_HIT == 0 and self.player2.defensive_hit ~= 0 then
            self.player2.height = self.player2.height - PADDLE.HEIGHT_DECREMENT
        end

        self.ball.dx = -self.ball.dx * (1 + BALL.SPEED_INCREMENT_PRECENTAGE/100)
        self.ball.x = self.player2.x - self.ball.width
        -- Play the sound cue
        if GAME.SETTINGS.SOUND_EFFECTS then gSounds:play('paddle_hit') end
    end
end

function PlayState:checkAndIncrementScores()
    -- Score checking for player-1
    if self.ball.x + self.ball.width > VIRTUAL_WIDTH then
        --[[
            Checking for corner hit
        ]]
        if self.ball.y >= 0 and self.ball.y + self.ball.width <= GAME.CORNER_THRESHOLD then
            self.corner_bonus = GAME.CORNER_INCREMENT
        end     

        -- add the defense bonus to the actual score and score increment
        self.player1.score = self.player1.score + GAME.SCORE_INCREMENT + self.defensive_bonus + self.corner_bonus

        -- Reseting corner bonus
        self.corner_bonus = 0

        -- Change the game-state to serve
        gStateMachine:change('serve', {
            servingPlayer = 2,
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode
        })
        -- Play the sound cue
        if GAME.SETTINGS.SOUND_EFFECTS then gSounds:play('score') end
    end
    -- Score checking for player-2
    if self.ball.x < 0 then
        --[[
            Checking for corner hit
        ]]
        if self.ball.y >= 0 and self.ball.y + self.ball.width <= GAME.CORNER_THRESHOLD then
            self.corner_bonus = GAME.CORNER_INCREMENT
        end

        -- add the defense bonus to the actual score and score increment
        self.player2.score = self.player2.score + GAME.SCORE_INCREMENT + self.defensive_bonus + self.corner_bonus

        -- Reseting corner bonus
        self.corner_bonus = 0

        -- Change the game-state to serve
        gStateMachine:change('serve', {
            servingPlayer = 1,
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2,
            game_mode = self.game_mode
        })
        -- Play the sound cue
        if GAME.SETTINGS.SOUND_EFFECTS then gSounds:play('score') end
    end
end

function PlayState:onGameOver()
    if self.player1.score >= GAME.WIN_SCORE or self.player2.score >= GAME.WIN_SCORE then
        gStateMachine:change('win', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2
        })
        -- Play the winning sound
        if GAME.SETTINGS.SOUND_EFFECTS then gSounds:play('victory') end
    end
end