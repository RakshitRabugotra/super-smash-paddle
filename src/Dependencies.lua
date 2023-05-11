--[[
    This is the file containig all the dependencies for our project
]]
-- Import the constants
require 'src/constants'

Class = require 'lib/class'
push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'

-- For utlity functions
require 'src/Util'
require 'src/Sounds'
require 'src/Menu'

-- Import the paddle and ball class
require 'src/Paddle'
require 'src/Ball'

-- For state machine
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/TitleState'
require 'src/states/TipsNCredits'
require 'src/states/ChooseGameModeState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/WinState'
require 'src/states/PauseState'
require 'src/states/SettingsState'
require 'src/states/ControlMappingState'
require 'src/states/GetControlInputState'
