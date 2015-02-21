local audio = require "audio"

local objs = require "map.objs"
local camera = require "map.camera"

local M = {}

function M.music(name)
  audio.music(name)
end

function M.hurtplayer (x, y)
  audio.play "hit"
  M.spawn_feuerwerk(x, y, nil, 125, 125, 0, 3)
end

function M.hitground (x, y, strength)
  audio.play("hit", x, y, strength==1 and .2 or .8)
  M.spawn_feuerwerk(x, y, 1*strength, 50, 100, 10, 3*strength)
end

function M.jump (x, y, strength)
  audio.play "jump"
  M.spawn_feuerwerk(x, y, 1, 255, 255, 0, 4)
end

function M.getitem (x, y)
  audio.play("schwupp")
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 3)
end

function M.getruby (x, y)
  audio.play("ding")
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 3)
end

function M.getheart (x, y)
  audio.play("gluck")
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 3)
end

function M.getkey (x, y)
  audio.play("tadadi")
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 3)
end

function M.unlock (x, y)
  audio.play("unlock", x, y)
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 3)
end

function M.openchest (x, y)
  audio.play "Triumph"
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 20)
end

function M.drawsword(x, y)
  audio.play "hah"
  M.spawn_feuerwerk(x, y, nil, 255, 255, 0, 2)
end

function M.enemyboost (x, y)
  audio.play("boost", x, y, 0.8)
--  audio.play(snd or "electro2", x, y)
  M.spawn_feuerwerk(x, y, nil, 255, 0, 0, 7)
end

function M.hurtenemy (x, y)
  audio.play("hit", x, y)
  M.spawn_feuerwerk(x, y, nil, 255, 0, 255, 5)
end

function M.grasscut (x, y)
  audio.play("hit", x, y)
  M.spawn_feuerwerk(x, y, nil, 0, 200, 100, 5)
end

function M.hitboss (x, y)
  audio.play("explosion", nil, nil, nil, math.random()*1+2)
  M.spawn_feuerwerk(x, y, nil, 255, 0, 255, 20)
end

function M.killenemy (x, y)
  audio.play "hit"
--  audio.play(snd or "electro2", x, y)
  M.spawn_feuerwerk(x, y, 3, 255, 0, 255, 10)
end

function M.abled (x, y)
  audio.play("hit", x, y)
  M.spawn_feuerwerk(x, y, nil, 50, 100, 200, 10)
end

function M.spawn_feuerwerk (x, y, shake, red, green, blue, count)
---[[
  if shake then
    local dx, dy = avatar.x-x, avatar.y-y
    shake = shake * math.sqrt(dx*dx + dy*dy)/100
    camera.x = camera.x + (math.random()-.5) * shake
    camera.y = camera.y + (math.random()-.5) * shake
  end
--]]

  for i = 1, (count or 10) do
    local p = objs.spawn("PUFF", x + math.random()*2-1, y + math.random()*2-1)
    p.iy = 10
    p.properties.zstart = 1 * count/15
    p.properties.zend   = 2 * count/15
    p.red=red*(.9+math.random()*.1) p.green=green*(.9+math.random()*.1) p.blue=blue*(.9+math.random()*.1)
    p.properties.ghost = true
    p.properties.dur = 20 + math.random() * 20
    p.vx = math.random()*2-1
    p.vy = math.random()*1-.5
  end
end

return M
