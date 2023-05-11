--[[
    This is a Utility file for handling different operations
]]

-- For Drawing dashed line
function love.graphics.drawDashedLine(params)
    
    -- Fetching params for ease
    local start_ = params.start_
    local end_ = params.end_
    local step_ = params.step_
    local length_ = params.length_
    local width_ = params.width_
    local orient_ = params.orient_
    local color_ = params.color_ or COLORS.DEFAULT
    
    -- -- Exiting pre-maturely if the parameter is not right
    -- if params.orient_ ~= 'horizontal' or params.orient_ ~= 'vertical' then return end
    -- Setting the demanded color
    love.graphics.setColor(color_)
    
    -- Our starting position
    x, y = start_.x, start_.y
    
    if orient_ == 'horizontal' then
        while (x < end_.x) do
            -- Draw a rectangle
            love.graphics.rectangle('fill', x, start_.y, width_, length_)
            -- Take a step forward
            x = x + length_ + step_
        end
    elseif orient_ == 'vertical' then
        while (y < end_.y) do
            -- Draw a rectangle
            love.graphics.rectangle('fill', start_.x, y, width_, length_)
            -- Take a step forward
            y = y + length_ + step_
        end
    end

    -- Set color back to default
    love.graphics.setColor(COLORS.DEFAULT)
end

-- For raycasting in direction of an object
-- When position and velocity at a moment is given
function seed_raycast(initial_x, initial_y, vel_x, vel_y, dt)
    iter_x, iter_y = initial_x, initial_y
    break_points = {}
    
    -- Setting up our goal and conditon for continuing
    -- Checking what's the end goal
    -- i.e, x = 0 or VIRTUAL_WIDTH?
    goal = (initial_x < VIRTUAL_WIDTH/2) and VIRTUAL_WIDTH or 0
    condition = (initial_x < VIRTUAL_WIDTH/2) and iter_x < goal or goal < iter_x

    -- Setting or vel_x in order to reach the goal
    vel_x = (iter_x < VIRTUAL_WIDTH/2) and math.abs(vel_x) or -math.abs(vel_x)

    -- Fetching the path
    counter = 1

    break_points[counter] = {
        x = initial_x,
        y = initial_y
    }
    counter = counter + 1

    print("GOAL: " .. tostring(goal))

    while (((initial_x < VIRTUAL_WIDTH/2) and (iter_x < VIRTUAL_WIDTH)) or ((initial_x > VIRTUAL_WIDTH/2) and (iter_x > 0))) do
        -- Adding the points in the end
        iter_x = math.floor(iter_x + vel_x)
        iter_y = math.floor(iter_y + vel_y)

        print("X: "..tostring(iter_x)..", Y: "..tostring(iter_y), "VEL_X: "..tostring(vel_x)..", VEL_Y: "..tostring(vel_y))

        -- Checking if we've hit a Vertical boundary, then
        -- add the coordinates to breakpoint
        if iter_y <= 0 or iter_y >= VIRTUAL_HEIGHT then
            iter_y = (iter_y <= 0) and 0 or VIRTUAL_HEIGHT
            -- vel_y = (iter_y <= 0) and math.abs(vel_y) or -math.abs(vel_y)
            vel_y = -vel_y

            break_points[counter] = {
                x = iter_x,
                y = iter_y
            }
            counter = counter + 1
        end
    end

    -- Doing one more iteration
    iter_x = math.floor(iter_x + vel_x * dt)
    iter_y = math.floor(iter_y + vel_y * dt)

    break_points[counter] = {
        x = iter_x,
        y = iter_y
    }


    print("Break Points are: " )
    rPrint(break_points, nil, "Junk")

    -- returning the breakpoints
    return break_points
end

function render_raycast(break_points)
    print("Length of breakpoints: " .. tostring(#break_points))
    rPrint(break_points ,nil, "Junk")
    -- love.event.quit()
    love.graphics.setColor(COLORS.PAUSED)

    -- Using the break_points to draw line
    for i = 1, #break_points - 1 do
        love.graphics.line(break_points[i].x, break_points[i].y, break_points[i+1].x, break_points[i+1].y)
        print("Drew: (" .. tostring(break_points[i].x) .. ", " .. tostring(break_points[i].y) .. ") to (" .. tostring(break_points[i+1].x) .. ", " .. tostring(break_points[i+1].y) .. ")")
    end
    -- love.graphics.line(break_points[1].x, break_points[1].y, break_points[#break_points].x, break_points[#break_points].y)

    love.graphics.setColor(COLORS.DEFAULT)
end

-- For displaying scores
function displayPlayerStats(p1, p2, global_color)
    -- display the name of both players in small
    love.graphics.setColor((global_color) and global_color or COLORS.NEUTRAL)      -- It Shouldn't attract much attnetion
    love.graphics.setFont(gFonts['small'])
    love.graphics.print(p1.name, VIRTUAL_WIDTH/2 - gFontSize['small'] * string.len(p1.name), VIRTUAL_HEIGHT/6 - gFontSize['small']*2)
    love.graphics.print(p2.name, VIRTUAL_WIDTH/2 + 32, VIRTUAL_HEIGHT/6 - gFontSize['small']*2)

    -- set the font accordingly
    love.graphics.setFont(gFonts['large'])
    -- displaying the score of both the players
    love.graphics.setColor((global_color) and global_color or COLORS.PLAYER_1)
    love.graphics.print(tostring(p1.score), VIRTUAL_WIDTH/2 - 32 -(gFontSize['large'])/2, VIRTUAL_HEIGHT/6)
    love.graphics.setColor((global_color) and global_color or COLORS.PLAYER_2)
    love.graphics.print(tostring(p2.score), VIRTUAL_WIDTH/2 + 32, VIRTUAL_HEIGHT/6)

    -- displaying the defensive hits
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(COLORS.NEUTRAL)
    love.graphics.print(tostring(p1.defensive_hit), VIRTUAL_WIDTH/2 - 32 -(gFontSize['small'])/2, VIRTUAL_HEIGHT/6 + gFontSize['small']*4)
    love.graphics.print(tostring(p2.defensive_hit), VIRTUAL_WIDTH/2 + 32, VIRTUAL_HEIGHT/6 + gFontSize['small']*4)

    -- Revert to normal color
    love.graphics.setColor(COLORS.DEFAULT)
end

-- For displaying controls over the screen
function displayPlayerControls(p1, p2)
    --[[
        Showing the controls for both the players
    ]]
    love.graphics.setFont(gFonts['medium'])
    -- Printing the info for player 1
    love.graphics.setColor(COLORS.MENU_CHOOSE.ACTIVE_INVERTED)
    love.graphics.print(p1.controls.up, p1.width + gFontSize['medium'] * (#p1.controls.up), p1.y)
    love.graphics.print(p1.controls.down, p1.width + gFontSize['medium'] * (#p1.controls.down), p1.y + p1.height - gFontSize['medium'])

    -- Printing the info for player 2
    love.graphics.print(p2.controls.up, VIRTUAL_WIDTH - p2.width - gFontSize['medium'] * (#p2.controls.up), p2.y)
    love.graphics.print(p2.controls.down, VIRTUAL_WIDTH - p2.width - gFontSize['medium'] * (#p2.controls.down - 1), p2.y + p2.height - gFontSize['medium'])

    love.graphics.setColor(COLORS.DEFAULT)
end

--[[
    Utility functions
]]
-- Clamping a number between some range
function clamp(params)
    return math.min(math.max(params.number, params.min), params.max);
end

-- For displaying the FPS
function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(COLORS.DEBUG)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 4, 4)
    love.graphics.setColor(COLORS.DEFAULT)
end
-- For toggling fullscreen
function toggleFullscreen()
    GAME.SETTINGS.FULLSCREEN = not GAME.SETTINGS.FULLSCREEN
    love.window.setFullscreen(GAME.SETTINGS.FULLSCREEN, 'desktop')
    love.resize(love.graphics.getDimensions())
    return GAME.SETTINGS.FULLSCREEN
end
-- For changing BackgroundMusic
function toggleBackgroundMusic()
    GAME.SETTINGS.BG_MUSIC = not GAME.SETTINGS.BG_MUSIC
    -- If the BG_MUSIC is turned off then stop the music
    if GAME.SETTINGS.BG_MUSIC then
        gSounds:get('bg-music'):setVolume(GAME.SETTINGS.BG_MUSIC_VOLUME)
        gSounds:get('bg-music'):setLooping(true)
        gSounds:get('bg-music'):play()
    else
        gSounds:stop('bg-music')
    end
    return GAME.SETTINGS.BG_MUSIC
end
-- For changing SoundEffects
function toggleSoundEffects()
    GAME.SETTINGS.SOUND_EFFECTS = not GAME.SETTINGS.SOUND_EFFECTS
    return GAME.SETTINGS.SOUND_EFFECTS
end
-- For changing Vysnc
function toggleVysnc()
    GAME.SETTINGS.VSYNC = not GAME.SETTINGS.VSYNC
    return GAME.SETTINGS.VSYNC
end
-- For changing ZaWarudo
function toggleZaWarudo()
    GAME.SETTINGS.ZA_WARUDO = not GAME.SETTINGS.ZA_WARUDO
    return GAME.SETTINGS.ZA_WARUDO
end

function displayDebugConsole()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(COLORS.DEBUG)
    love.graphics.print("Player 1 (H): " .. tostring(player1.height), 4, 20)
    love.graphics.print("Player 2 (H): " .. tostring(player2.height), 4, 30)
    love.graphics.print("Paddle Speed: " .. tostring(PADDLE.SPEED), 4, 40)
    love.graphics.print("Ball Speed++: " .. tostring(BALL.SPEED_INCREMENT_PRECENTAGE), 4, 50)
    love.graphics.setColor(COLORS.DEFAULT)


    -- Drawing green boxes on the corner to notify player
    -- that htting the ball there gives extra score
    -- love.graphics.setColor(50/255, 168/255, 82/255, 1)
    -- love.graphics.rectangle('fill', 0, 0, CORNER_THRESHOLD, CORNER_THRESHOLD)
    -- love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT-CORNER_THRESHOLD, CORNER_THRESHOLD, CORNER_THRESHOLD)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH-CORNER_THRESHOLD, 0, CORNER_THRESHOLD, CORNER_THRESHOLD)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH-CORNER_THRESHOLD, VIRTUAL_HEIGHT-CORNER_THRESHOLD, CORNER_THRESHOLD, CORNER_THRESHOLD)
    -- love.graphics.setColor(1, 1, 1, 1)
end

--[[
    For checking if two tables are equal
]]
function table.areEqual(table1, table2)
    if table1 == table2 then return true end

    for k, v in pairs(table1) do
        if table1[k] ~= table2[k] then
            return false
        end
    end

    return true
end

--[[
    Checking if the two player's color are the same
]]
function makePlayerColorDifferent()
    while table.areEqual(COLORS.PLAYER_1, COLORS.PLAYER_2) do
        COLORS.PLAYER_1 = TRANSITION_COLORS[math.random(1, #TRANSITION_COLORS)]
        COLORS.PLAYER_2 = TRANSITION_COLORS[math.random(1, #TRANSITION_COLORS)]
    end

    PLAYER['1'].color = COLORS.PLAYER_1
    PLAYER['2'].color = COLORS.PLAYER_2
end

--[[
    Making sure we don't get the same colors as the two players
]]
function randomColor(colors)
    local random_color = colors[math.random(1, #colors)]
    -- To ensure we don't same color as other players
    while random_color == COLORS.PLAYER_1 or random_color == COLORS.PLAYER_2 do
        random_color = colors[math.random(1, #colors)]
    end
    return random_color
end






--[[ rPrint(struct, [limit], [indent])   Recursively print arbitrary data. 
	Set limit (default 100) to stanch infinite loops.
	Indents tables as [KEY] VALUE, nested tables as [KEY] [KEY]...[KEY] VALUE
	Set indent ("") to prefix each line:    Mytable [KEY] [KEY]...[KEY] VALUE
--]]
function rPrint(s, l, i) -- recursive Print (structure, limit, indent)
	l = (l) or 100; i = i or "";	-- default item limit, indent string
	if (l<1) then print "ERROR: Item limit reached."; return l-1 end;
	local ts = type(s);
	if (ts ~= "table") then print (i,ts,s); return l-1 end
	print (i,ts);           -- print "table"
	for k,v in pairs(s) do  -- print "[KEY] VALUE"
		l = rPrint(v, l, i.."\t["..tostring(k).."]");
		if (l < 0) then break end
	end
	return l
end