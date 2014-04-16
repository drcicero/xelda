local audio = {}

local files = {}
audio.files = files

function audio.load ()
  for i, name in ipairs(love.filesystem.getDirectoryItems("assets")) do
    if name:sub(-4) == ".mp3" then
      print("assets/" .. name)
      local file = love.audio.newSource("assets/" .. name, "static")
      files[name:sub(1, #name-4)] = file
    end
  end
end

function audio.play (name)
  print("play", name)
  files[name]:clone():play()
end

audio._music = ""
function audio.music (name)
  local old = files[audio._music]
  local new = files[name]
  audio._music = name

  if old then
    old:pause()
    old:setLooping(false)
  end
  if new then
    new:setLooping(true)
    new:play()
  end
end

return audio
