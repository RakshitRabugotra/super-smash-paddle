--[[
    This is a class to handle Menu
]]
Menu = Class{}

function Menu:init(options)
    --[[
        The 'options' will be a table of tables
        -- The inner table will contain three values
           -- The 'first' value would be the name of the option
           -- The 'second' value would be the action of the option
           -- The 'third' value would be a boolean, 
              -- nil if the option is NOT a toggle option (ON/OFF)
              -- else, the default state of the toggle can be given as string

    ]]
    self.options = options

    -- The highlighted option
    self.highlighted = 1
    -- The maximum our selection can reach
    self.max = #self.options

    -- The control keys
    self.upKey = {PLAYER['1'].controls.up, PLAYER['2'].controls.up}
    self.downKey = {PLAYER['1'].controls.down, PLAYER['2'].controls.down}

    -- Go through the options and modify the toggle options' name
    for i, pair in ipairs(self.options) do
        local originalName = pair[1]
        local action = pair[2]
        local toggleState = pair[3]

        -- If the option is not a toggle then skip
        if toggleState == nil then goto continue end

        -- Else we will check the state of the toggle
        self.options[i] = {originalName .. ": " .. tostring(toggleState), action, toggleState, originalName}

        ::continue::
    end
end

function Menu:update(dt)

    -- Cycle through the menu
    if love.keyboard.wasPressed(self.upKey[1]) or love.keyboard.wasPressed(self.upKey[2]) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted <= 1) and self.max or self.highlighted - 1
    elseif love.keyboard.wasPressed(self.downKey[1]) or love.keyboard.wasPressed(self.downKey[2]) then
        -- Play the select sound
        gSounds:stop('select')
        gSounds:play('select')
        self.highlighted = (self.highlighted >= self.max) and 1 or self.highlighted + 1
    end

    -- Choose the confirmed option
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        -- Play the confirm sound
        gSounds:stop('confirm')
        gSounds:play('confirm')

        for i, pair in ipairs(self.options) do
            local action = pair[2]
            local toggleState = pair[3]

            -- If the action is direct and not a toggle
            if i == self.highlighted and toggleState == nil then
                action()
                break
            end

            -- If the action is toggle, then execute the toggle function
            -- and rename the option-name accordingly
            if i == self.highlighted and toggleState ~= nil then
                local newState = action()
                local originalName = pair[4]
                self.options[i] = {originalName .. ": " .. tostring(newState), action, toggleState, originalName}
            end
        end
    end

end

function Menu:render(offsetY, fontSize, spacingFactor, activeColor, inactiveColor)
    -- We will render the menu in the middle of the screen

    activeColor = activeColor or COLORS.MENU_CHOOSE.ACTIVE
    inactiveColor = inactiveColor or COLORS.MENU_CHOOSE.INACTIVE

    -- If the spacing factor is not given then
    spacingFactor = spacingFactor or 1.5
    
    -- Giving some options
    love.graphics.setFont(gFonts[fontSize])

    for i, pair in ipairs(self.options) do
        -- The name of the action
        local name = pair[1]

        love.graphics.setColor(inactiveColor)
        -- If we've selected the current option, then give it a highlighted color
        if(i == self.highlighted) then
            love.graphics.setColor(activeColor)
        end
        -- Print the option
        love.graphics.printf(tostring(name), 0, offsetY + spacingFactor*i*gFontSize[fontSize], VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setColor(COLORS.DEFAULT)
end