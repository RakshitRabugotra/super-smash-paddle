--[[
    This is the ball class for handling the ball in game :)
]]
Ball = Class{}

function Ball:init()
    -- Ball dimensions
    self.x = VIRTUAL_WIDTH/2 - BALL.WIDTH/2
    self.y = VIRTUAL_HEIGHT/2 - BALL.HEIGHT/2

    self.dx = 0
    self.dy = 0

    self.width = BALL.WIDTH
    self.height = BALL.HEIGHT

    self.color = COLORS.NEUTRAL
end

function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Ball:update(dt)
    --[[
        Checking for collision with the wall
    ]]
    if self.y < 0 then
        self.y = 0
        self.dy = -self.dy
        
        -- Playing the wall hit sound
        gSounds:stop('wall_hit')
        gSounds:play('wall_hit')
    end
    if self.y + self.height > VIRTUAL_HEIGHT then
        self.y = VIRTUAL_HEIGHT - self.height
        self.dy = -self.dy
        
        -- Playing the wall hit sound
        gSounds:stop('wall_hit')
        gSounds:play('wall_hit')
    end

    --[[
        Changing the color of the ball accordingly to which 
        player is farther to it
    ]]
    self.color = (self.x + self.dx * dt < VIRTUAL_WIDTH/2) and COLORS.PLAYER_2 or COLORS.PLAYER_1

    --[[
        Lastly adding velocities to the position
    ]]
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset(dt)
    self.x = VIRTUAL_WIDTH/2 - BALL.WIDTH/2
    self.y = VIRTUAL_HEIGHT/2 - BALL.HEIGHT/2

    self.dx = 0
    self.dy = 0

    self.color = COLORS.NEUTRAL
end

function Ball:render(global_color)
    --[[
        Rendering the ball to the screen
    ]]
    love.graphics.setColor((global_color) and global_color or self.color)
    love.graphics.rectangle(
        'fill',
        self.x, self.y,
        self.width, self.height
    )
    love.graphics.setColor(COLORS.DEFAULT)
end