--[[
    This is the base state which will be inherited by other states
]]
BaseState = Class{}

function BaseState:init() end
function BaseState:enter(params) end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end