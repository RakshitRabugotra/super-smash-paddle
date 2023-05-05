--[[
    Class to handle sounds
]]
Sounds = Class{}

function Sounds:init(sounds)
    -- Copy all the sounds to a table
    self.sounds = sounds
end

function Sounds:play(soundKey)
    if not GAME.SETTINGS.SOUND_EFFECTS and soundKey ~= 'bg-music' then return end
    -- Assert if the sound is in the sounds or not
    assert(self.sounds[soundKey])
    -- Play the sound
    self.sounds[soundKey]:play()
end

function Sounds:pause(soundKey)
    -- if not GAME.SETTINGS.SOUND_EFFECTS then return end
    -- Assert if the sound is in the sounds or not
    assert(self.sounds[soundKey])
    -- Pause the sound
    self.sounds[soundKey]:pause()
end

function Sounds:stop(soundKey)
    if not GAME.SETTINGS.SOUND_EFFECTS and soundKey ~= 'bg-music' then return end
    -- Assert if the sound is in the sounds or not
    assert(self.sounds[soundKey])
    -- Stop the sound
    self.sounds[soundKey]:stop()
end

function Sounds:get(soundKey)
    -- Assert if the sound exists
    assert(self.sounds[soundKey])
    return self.sounds[soundKey]
end
