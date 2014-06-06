--- Audio
-- Play sounds and music

local audio = {}

local files = {}
audio.files = files

---
-- Call this function at loading, it will search for files matching 'assets/NAME.mp3'.
-- These will the be callable by the string NAME with the other functions.
function audio.load ()
  for i, name in ipairs(love.filesystem.getDirectoryItems("assets")) do
    if name:sub(-4) == ".mp3" then
      local file = love.audio.newSource("assets/" .. name, "stream")
      files[name:sub(1, #name-4)] = file
    end
  end
end

---
-- name is the name of a loaded mp3 assets. (See #audio.load)
-- if you call this function with x and y, then the volume of the sound will be affected by the distance of the pos to the avatar's pos multiplied with vol times #audio.svol. (See $maps)
function audio.play (name, x, y, vol, pitch)
  local a = files[name]:clone()

  pitch = pitch or 1
  vol = vol or 1

  if x then
    local dist = math.sqrt((x-avatar.x)*(x-avatar.x)+(y-avatar.y)*(y-avatar.y))
    vol = clamp(0, (1-math.sqrt(dist)/15) * vol, 1)
  end
  a:setVolume(vol * audio.svol)
  a:setPitch(pitch)
  a:play()
end

audio.mvol = 1
audio.svol = 1

audio.channels = {}
---
-- name is the name of a loaded mp3 assets. (See #audio.load)
-- only one music can play at a time and will be looped.
-- you can change the volume even after starting to play with #audio.setMvol .
function audio.music (name, channelid)
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

function audio.setPitch (pitch, channel)
  local channel = audio.channels[channel]
  if channel then
    channel.pitch = pitch
    channel.sample:setPitch(pitch)
  end
end

function audio.setVol (vol, channelid)
  local channel = audio.channels[channelid]
  if channel then
    channel.vol = vol
    channel.sample:setVolume(vol * audio.mvol)
  end
end

---
-- channel master volume
function audio.setMVol (vol)
  local mus = files[audio._music]
  audio.mvol = vol
  for id, channel in pairs(audio.channels) do
    channel.sample:setVolume(channel.vol * vol)
  end
end

---
-- vol is a number between 0 and 1. Only audio files played by audio.play after this call are affected.
function audio.setSVol (vol)
  audio.svol = vol
end

return audio
