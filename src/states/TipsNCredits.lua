--[[
    This is a state for the credits and tips in the game
]]
TipsNCredits = Class{__includes = BaseState}

function TipsNCredits:init()
    self.credits = {
        "Idea: Harvard University's CS50 team\n",
        "Music: RETRO Game Background Instrumental | Royalty Free Music Loop\n\tYoutube channel - 'Lion Free Music'\n"
    }

    self.tips = {
        "Try to defend more as you'll get bonus for that\n",
        "But, Also you'll lose your size on every " .. tostring(PADDLE.DECREMENT_ON_HIT) .. " hits\n",
        -- "Hitting any corner within " .. tostring(CORNER_THRESHOLD) .. " pixels\nincrements the scores by " .. tostring(CORNER_INCREMENT) .. '\n'
    }

    -- colors we'll use to change the title text
    self.colors = {COLORS.MENU_CHOOSE.ACTIVE, COLORS.MENU_CHOOSE.ACTIVE_INVERTED}

    -- time for a color change if it's been half a second
    self.colorTimer = Timer.every(0.5, function()
        
        -- shift every color to the next, looping the last to front
        -- assign it to 0 so the loop below moves it to 1, default start
        self.colors[0] = self.colors[#self.colors]

        for i = #self.colors, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    self.option_color = randomColor(TRANSITION_COLORS)
end

function TipsNCredits:enter(params)
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2
end

function TipsNCredits:update(dt)
    --[[
        Key for only going back to title menu
    ]]
    -- user tries to navigate play the select sound
    if love.keyboard.wasPressed(self.player1.controls.up) or love.keyboard.wasPressed(self.player1.controls.down) or
        love.keyboard.wasPressed(self.player2.controls.up) or love.keyboard.wasPressed(self.player2.controls.down) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
    end
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('backspace') or
        love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')
    then
        -- Play the confirm sound
        gSounds:stop('confirm')
        gSounds:play('confirm')
        gStateMachine:change('title', {
            ball = self.ball,
            player1 = self.player1,
            player2 = self.player2
        })
    end

    -- Update the timer for animation
    Timer.update(dt)
end

function TipsNCredits:render()
    --[[
        Rendering our screen
    ]]
    -- Rendering the credits
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(COLORS.PLAYER_1)
    love.graphics.printf("Credits", gFontSize['large']*1.5, gFontSize['large'], VIRTUAL_WIDTH, 'left')

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(self.option_color)
    for k, v in pairs(self.credits) do
        love.graphics.print('[.] ' .. tostring(v), gFontSize['large']*1.5, gFontSize['large']*2 + gFontSize['small']*tonumber(k))
    end


    -- Rendering the tips
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(COLORS.PLAYER_2)
    love.graphics.printf("Tips", 0, gFontSize['large'] * (#self.tips + 2), VIRTUAL_WIDTH-gFontSize['large']*1.5, 'right')

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(self.option_color)
    for k, v in pairs(self.tips) do
        love.graphics.printf('[.] ' .. tostring(v), 0, gFontSize['large'] * (#self.tips + 3) + gFontSize['small'] * tonumber(k), VIRTUAL_WIDTH-gFontSize['large']*1.5, 'right')
    end

    -- Rendering the back to main menu option
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(self.colors[1])
    love.graphics.printf("Press enter to go back", 0, gFontSize['small']*1.5, VIRTUAL_WIDTH-gFontSize['small']*3.5, 'right')

    -- reverting back to default color
    love.graphics.setColor(COLORS.DEFAULT)

end