--[[
    Class to handle sounds
]]
Sounds = Class{}

function Sounds:init(sounds)
    -- Copy all the sounds to a table
    self.sounds = sounds

    -- The volume of all the sounds
    self.volume = GAME.SETTINGS.SOUND_EFFECTS_VOLUME
end

function Sounds:setGlobalVolume(volume)
    -- Check if the volume is within 0 and 1
    if 0 <= volume and volume <= 1 then
        self.volume = volume
    end
end

function Sounds:getGlobalVolume()
    return self.volume
end

function Sounds:play(soundKey)
    if not GAME.SETTINGS.SOUND_EFFECTS and soundKey ~= 'bg-music' then return end
    -- Assert if the sound is in the sounds or not
    assert(self.sounds[soundKey])
    -- Set the volume
    self.sounds[soundKey]:setVolume(self.volume)
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
