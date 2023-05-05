--[[
    This is the state machine, which will handle,
    the transition between different states
]]
StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        enter = function() end,
        exit = function() end,
        update = function() end,
        render = function() end
    }
    self.states = states or {} -- Checks if states in parameters are defined or not
    self.stateName = 'empty'
    self.current = self.empty  -- Starting with an empty state function
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) -- Checks if the 'stateName' exits in the 'states' table
    self.current:exit()
    self.current = self.states[stateName]()
    self.stateName = stateName
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end