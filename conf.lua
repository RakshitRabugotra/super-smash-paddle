--[[
    Configuration file for the game
]]
require 'src/constants'

function love.conf(t)
    t.title = GAME.TITLE    -- The title of the game
    t.version = "11.4"      -- The LOVE version this game was made for
    t.console = false       -- Attach a console (boolean, Windows only)
end
