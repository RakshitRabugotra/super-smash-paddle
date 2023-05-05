--[[
    This is our win state when we win the game lol:)
]]
WinState = Class{__includes = BaseState}

function WinState:init()
end

function WinState:enter(params)
    self.ball = params.ball
    self.player1 = params.player1
    self.player2 = params.player2

    -- highlighted option
    self.highlighted = 1

    self.winner = (math.max(self.player1.score, self.player2.score) == self.player1.score) and self.player1 or self.player2
end

function WinState:update(dt)
    --[[
        Checking keyboard bindings
    ]]
    -- For exiting the game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    --[[
        Choose between replay and quit
    ]]
    if love.keyboard.wasPressed(PLAYER['1'].controls.up) or love.keyboard.wasPressed(PLAYER['2'].controls.up) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted > 1) and 1 or 2
    elseif love.keyboard.wasPressed(PLAYER['1'].controls.down) or love.keyboard.wasPressed(PLAYER['2'].controls.down) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted < 2) and 2 or 1
    end

    --[[
        Confirm choice by pressing return or enter
    ]]
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        
        -- Play the confirm sound
        gSounds:stop('confirm')
        gSounds:play('confirm')

        self.player1.score = 0
        self.player2.score = 0

        if self.highlighted == 1 then
            -- Quit the game with ease
            gStateMachine:change('serve', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2,
                game_mode = GAME.MODES[1]
            })
        elseif self.highlighted == 2 then
            gStateMachine:change('title', {
                ball = self.ball,
                player1 = self.player1,
                player2 = self.player2
            })
        end

    end
end

function WinState:render()
    -- display the score
    displayPlayerStats(self.player1, self.player2)

    -- displaying the winner
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(self.winner.color)
    love.graphics.printf(
        self.winner.name .. ' Wins!',
        0, VIRTUAL_HEIGHT/2 - gFontSize['large']/2,
        VIRTUAL_WIDTH,
        'center'
    )
    love.graphics.setColor(COLORS.DEFAULT)

    -- Choose the option between quiting and replaying
    love.graphics.setFont(gFonts['medium'])
    
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 1 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    love.graphics.printf("Replay", 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*2, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setColor(COLORS.MENU_CHOOSE.INACTIVE)
    if self.highlighted == 2 then
        love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE)
    end
    love.graphics.printf("Main Menu", 0, VIRTUAL_HEIGHT/2 + gFontSize['medium']*4, VIRTUAL_WIDTH, 'center')

    -- Reverting back to default color
    love.graphics.setColor(COLORS.DEFAULT)

    -- rendering the winner to the screen only
    self.winner:render()
end