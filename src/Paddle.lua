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
