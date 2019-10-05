--- A class to manage loading and playback of sounds
-- @classmod core.soundmanager

local SoundManager = {}
SoundManager.__index = SoundManager

--- Constructor
-- @return A new SoundManager instance
function SoundManager.new()
	local instance = {}

	--- Collection of sounds
	instance.sounds = {
		['ui-move'] = love.audio.newSource('assets/audio/sfx/SFX_Blip06.ogg', 'stream'),
		['ui-select'] = love.audio.newSource('assets/audio/sfx/SFX_Blip04.ogg', 'stream'),
		['ui-back'] = love.audio.newSource('assets/audio/sfx/SFX_Lose08.ogg', 'stream'),
		['player-jump'] = love.audio.newSource('assets/audio/sfx/SFX_Jump04.ogg', 'stream')
	}

	--- Collection of music tracks
	instance.tracks = {
		['menu'] = love.audio.newSource('assets/audio/music/prologue.mp3', 'stream'),
		['level1'] = love.audio.newSource('assets/audio/music/level1.mp3', 'stream')
	}

	--- Volume of sound effects
	instance.effectVolume = 0.1

	--- Volume of music tracks
	instance.musicVolume = 0.5

	--- Current music track
	instance.np = nil

	setmetatable(instance, SoundManager)
	return instance
end

--- Play a sound
-- @param sound The name of the sound to be played
function SoundManager:play(sound)
	if self.sounds[sound] ~= nil then
		self.sounds[sound]:setVolume(Globals.config.masterVolume * self.effectVolume)
		self.sounds[sound]:play()
	end
end

--- Start a looping music track
-- @param track The name of the track to be played
function SoundManager:startTrack(track)
	if self.tracks[track] ~= nil then
		if self.np ~= nil then
			self.np:stop()
		end

		self.np = self.tracks[track]
		self.np:setVolume(Globals.config.masterVolume * self.musicVolume)
		self.np:setLooping(true)
		self.np:play()
	end
end

return SoundManager
