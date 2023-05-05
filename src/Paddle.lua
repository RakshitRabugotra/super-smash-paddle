--[[
    This is our paddle class,
    for the players to control
]]
Paddle = Class{}

function Paddle:init(properties)
    -- name of the player
    self.name = properties.name
    self.player = properties.player
    
    -- For fixing the paddle's x position
    self.x = self.player.x_constraint
    self.y = self.player.y_position
    -- controls will contain the key for up and down
    self.controls = self.player.controls

    -- dimensions
    self.width, self.height = PADDLE.WIDTH, PADDLE.HEIGHT

    -- Paddle speed
    self.dy = PADDLE.SPEED

    -- render color
    self.color = self.player.color
    -- setting the score
    self.score = properties.score
    -- Keeping track of defensive hit
    self.defensive_hit = 0

    -- is this player controlled by computer/AI?
    self.is_controlled_by_AI = false

    self.miss_shot = math.random(PADDLE.AI.INACCURACY) == 1
    self.miss_pixels = math.random(PADDLE.AI.MISS_SHOT_BY.MIN, PADDLE.AI.MISS_SHOT_BY.MAX)

    -- Player's court
    self.__court_area = (self.color == COLORS.PLAYER_1) and 1 or 2

    -- For raycasting
    self.raycast_breakpoints = nil
    self.raycast_showtime = 2
    self.raycast_time = 0

    self.raycast_timer = Timer.every(10, function()
        self.raycast_breakpoints = nil
    end)
end

function Paddle:reset()
    self.defensive_hit = 0
    self.height = PADDLE.HEIGHT
    
    if self.is_controlled_by_AI then
        self.miss_shot = math.random(PADDLE.AI.INACCURACY) == 1
        self.miss_pixels = math.random(PADDLE.AI.MISS_SHOT_BY.MIN, PADDLE.AI.MISS_SHOT_BY.MAX)
    end
end

function Paddle:update(dt)
    --[[
        Here are the paddle's control
    ]]

    --[[
        The Paddle is being operated by the human-player
    ]]
    if not self.is_controlled_by_AI then

        -- Clamping the movement to stay within the given space
        if love.keyboard.isDown(self.controls.up) then
            self.y = self.y - self.dy * dt
        end

        if love.keyboard.isDown(self.controls.down) then
            self.y = self.y + self.dy * dt
        end
        -- Clamping the value of y in between the screen visiable range
        self.y = clamp {
            number = self.y,
            min = 0,
            max = VIRTUAL_HEIGHT - self.height
        }
        -- Return early to avoid AI control
        return
    end
    
    --[[
        The player is being controlled by AI
        Here we will implement the logic for our AI
    ]]
    self:AI_takes_control(dt)

    Timer.update(dt)
end

function Paddle:render(global_color)
    --[[
        Rendering the paddle to the screen
    ]]
    love.graphics.setColor((global_color) and global_color or self.color)

    -- Drawing the paddle rectangle
    love.graphics.rectangle(
        'fill',
        self.x, self.y,
        self.width, self.height
    )
    -- Drawing raycast if breakpoints are defined
    -- print('Raycast time: ' .. tostring(self.raycast_time))
    if self.raycast_breakpoints then
        -- print("True in raycast render")
        rPrint(self.raycast_breakpoints ,nil, "Junk")

        -- love.event.quit()
        render_raycast(self.raycast_breakpoints)
    end

    love.graphics.setColor(COLORS.DEFAULT)
end


function Paddle:AI_takes_control(dt)
    --[[
        If the ball collides with the either paddle,
        then reset the chances of missing a shot
    ]]
    if self.ball:collides(self) then
        self.miss_shot = (math.random(PADDLE.AI.INACCURACY) == 1)
        self.miss_pixels = math.random(PADDLE.AI.MISS_SHOT_BY.MIN, PADDLE.AI.MISS_SHOT_BY.MAX)
        -- Seed the raycast
        local vel_x = -self.ball.dx * (1 + BALL.SPEED_INCREMENT_PRECENTAGE/100)
        self.raycast_breakpoints = seed_raycast(self.ball.x, self.ball.y, 100, 100, dt)
        -- self.raycast_breakpoints = seed_raycast(self.ball.x, self.ball.y, self.ball.dx, self.ball.dy)
        print(self.raycast_breakpoints)
    end
    -- the ball is in player's court then
    -- Paddle speed
    self.dy = PADDLE.SPEED * PADDLE.AI.SPEED_DECREMENT_PERCENTAGE/100

    if self.__court_area == 1 and ((self.ball.x < VIRTUAL_WIDTH * 0.75) or self.miss_shot) then
        -- If the ball is leaving the court then do nothing
        if not self.miss_shot then
            if self.ball.dx > 0 then return end
        end
        -- move the paddle accordingly
        self:AI_move_paddle(dt)

    elseif self.__court_area == 2 and ((self.ball.x > VIRTUAL_WIDTH * 0.25) or self.miss_shot) then
        -- If the ball is leaving the court then do nothing
        if not self.miss_shot then
            if self.ball.dx < 0 then return end
        end
        -- move the paddle accordingly
        self:AI_move_paddle(dt)  
    end

    -- Clampping the values of y accordingly
    self.y = clamp {
        number = self.y,
        min = self.miss_shot and self.miss_pixels or 0,
        max = self.miss_shot and VIRTUAL_HEIGHT-self.height-self.miss_pixels or VIRTUAL_HEIGHT-self.height
    }
end

function Paddle:AI_move_paddle(dt)
    -- For missing a random shot
    -- Miss the shot by random amounts of pixels
    if self.miss_shot then
        
        -- if the ball is below the player
        if self.ball.y > self.y + self.width then
            self.y =  self.ball.y - ((self.height < self.miss_pixels) and self.miss_pixels or self.height)
        end

        -- if the ball is above the player
        if self.ball.y < self.y then
            self.y = self.ball.y + self.miss_pixels
        end

        -- Returning early to avoid control
        return
    end

    -- If we're not missing the shot then

    -- If the ball is below the player,
    if self.ball.y > self.y + self.width/2 then
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy*dt)
    end
    -- Elseif the ball is above the player,
    if self.ball.y < self.y + self.width/2 then
        self.y = math.max(0, self.y - self.dy * dt)
    end
end
