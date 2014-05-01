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
-- if you call this function with x and y, then the volume of the sound will be affected by the distance of the pos to the avatars pos. (See $maps)
function audio.play (name, x, y)
  local a = files[name]:clone()
  local vol = 1
  if x then
    local dist = math.sqrt((x-avatar.x)*(x-avatar.x)+(y-avatar.y)*(y-avatar.y))
    vol = clamp(0, 1-math.sqrt(dist)/15, 1)
  end
  a:setVolume(vol * audio.svol)
  a:play()
end

audio._music = ""
---
-- name is the name of a loaded mp3 assets. (See #audio.load)
-- only one music can play at a time and will be looped.
-- you can change the volume even after starting to play with #audio.setMvol .
function audio.music (name)
  local old = files[audio._music]
  local new = files[name]
  audio._music = name

  if old then
    old:pause()
    old:setLooping(false)
    old:setVolume(1)
  end
  if new then
    new:setLooping(true)
    new:setVolume(audio.mvol*audio.mvol2)
    new:play()
  end
end

audio.mvol = 1
audio.mvol2 = 1
audio.svol = 1

---
-- vol is a number between 0 and 1.
function audio.setMVol (vol)
  local mus = files[audio._music]
  audio.mvol = vol
  if mus then
    mus:setVolume(audio.mvol*audio.mvol2)
  end
end

---
-- vol is a number between 0 and 1.
function audio.setMVol2 (vol)
  local mus = files[audio._music]
  audio.mvol2 = vol
  if mus then
    mus:setVolume(audio.mvol*audio.mvol2)
  end
end

---
-- vol is a number between 0 and 1. Only audio files played by audio.play after this call are affected.
function audio.setSVol (vol)
  audio.svol = vol
end

return audio
