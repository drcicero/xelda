--- Audio
-- Play sounds and music.
--
-- Tutorial: Put all audio files inside the folder assets, they must be in a three character
-- format to be found. Call audio.load before playing any audio file.
--
-- Now you can use $effects.audio#audio.play and $effects.audio#audio.music to play them using their filename
-- without the format as a string.

local clamp = require "clamp"

local audio = {}

local files = {}
audio.files = files

--- Load audio assets.
--
-- Search for files inside the folder assets/ .
-- and make them available to the other functions.
function audio.load ()
  for i, name in ipairs(love.filesystem.getDirectoryItems("assets")) do
    if name:sub(-4) == ".mp3" then
      local file = love.audio.newSource("assets/" .. name, "stream")
      files[name:sub(1, #name-4)] = file
    end
  end
end

--- play the audio file 'name'. 'x', 'y', 'vol', and 'pitch' are optional
--
-- 'x', 'y' : affect the volume by the distance to avatar
--
-- 'vol' : a factor for volume
--
-- 'pitch' : see https://love2d.org/wiki/Source:setPitch
function audio.play (name, x, y, vol, pitch)
  local a = files[name]:clone()

  pitch = pitch or 1
  vol = vol or 1

  if x then
    local dx = x-avatar.x
    local dy = y-avatar.y
    vol = clamp(0, (1 - math.sqrt(math.sqrt(dx*dx + dy*dy)) / 15) * vol, 1)
  end
  a:setVolume(vol * audio.svol)
  a:setPitch(pitch)
  a:play()
end

audio.mvol = 1
audio.svol = 1

audio.channels = {}
--- Play and loop the music 'name'.
--
-- 'channel' : the default is '"default"', create new channels
-- by passing new strings. setting a new music for a channel will overwrite this channels music.
--
-- You can change the music master volume with $effects.audio#audio.setMvol .
-- See also $audio.effects#audio.setVol and $audio.effects#audio.setPitch.
function audio.music (name, channelid)
  channelid = channelid or "default"
  local channel = audio.channels[channelid]
  if channel then
    channel.sample:pause()
    channel.name = name
  else
    channel = {vol=1, pitch=1, name=name}
    audio.channels[channelid] = channel
  end

  local template = files[name]
  if not template then
    if not name == nil then
      print("warning: no audio '" .. tostring(name) .. "'")
    end

  else
    local sample = template:clone()
    channel.sample = sample
    sample:setLooping(true)
    sample:setPitch(channel.pitch)
    sample:setVolume(channel.vol * audio.mvol)
    sample:play()
  end
end

--- Change the pitch of a music channel.
function audio.setPitch (pitch, channelid)
  local channel = audio.channels[channelid]
  if channel then
    channel.pitch = pitch
    channel.sample:setPitch(pitch)
  end
end

--- Change the volume of a music channel.
function audio.setVol (vol, channelid)
  local channel = audio.channels[channelid]
  if channel then
    channel.vol = vol
    channel.sample:setVolume(vol * audio.mvol)
  end
end

--- Set music master volume (affects all channels, but no sounds.)
function audio.setMVol (vol)
  local mus = files[audio._music]
  audio.mvol = vol
  for id, channel in pairs(audio.channels) do
    channel.sample:setVolume(channel.vol * vol)
  end
end

--- Set sound master volume. Only sound playing after this call are affected.
function audio.setSVol (vol)
  audio.svol = vol
end

return audio
