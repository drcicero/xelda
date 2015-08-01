--- Collection of Special Effects
-- a wrapper for sound and particles.
-- instead of using sound and particles, declare a new special effect here,
-- and use that. so all special effects can be easily managed.
local audio = require "audio"

local objs = require "pool"
local camera = require "map.camera"

local M = {}

function M.music(name)
  audio.music(name)
end

function M.shake (x,y, strength)
  local dx, dy = avatar.x-x, avatar.y-y
  strength = strength or 1
  strength = strength * math.sqrt(dx*dx + dy*dy)/100
  transient.levelclock.add {dur=strength, f=function(t)
    t = 1 - t
    camera.x = camera.x + (math.random()-.5) * strength * t
    camera.y = camera.y + (math.random()-.5) * strength * t
  end}
end

function M.spawn_fluff (x,y, red,green,blue, size)
  local p = objs.spawn("PUFF",
    x + math.random()*2-1,
    y + math.random()*2-1
  )
  p.iy = 10

  p.properties.zstart = 1 * size/15
  p.properties.zend   = 2 * size/15

  p.red   = red   * (.9+math.random()*.1)
  p.green = green * (.9+math.random()*.1)
  p.blue  = blue  * (.9+math.random()*.1)

  p.properties.ghost = true
  p.properties.dur = size + math.random() * 20

  p.vx = math.random()*2-1
  p.vy = math.random()*1-.5
end

local function spawn_feuerwerk (x,y, red,green,blue, size)
  for i = 1,10 do
    M.spawn_fluff(x,y, red,green,blue, size)
  end
end
M.spawn_feuerwerk = spawn_feuerwerk


function M.hurtplayer (x, y)
  audio.play "hit"
  spawn_feuerwerk(x,y, 125,125,0, 3)
end
function M.hitground (x, y, strength)
  audio.play("hit", x,y, strength==1 and .2 or .8)
  M.shake(x,y, strength)
  spawn_feuerwerk(x,y, 50,100,10, 3*strength)
end
function M.jump (x, y, strength)
  audio.play "jump"
  spawn_feuerwerk(x,y, 255,255,0, 4)
end
function M.getitem (x, y)
  audio.play("schwupp")
  spawn_feuerwerk(x,y, 255,255,0, 3)
end
function M.getruby (x, y)
  audio.play("ding")
  spawn_feuerwerk(x,y, 255,255,0, 3)
end
function M.getheart (x, y)
  audio.play("gluck")
  spawn_feuerwerk(x,y, 255,255,0, 3)
end
function M.getkey (x, y)
  audio.play("tadadi")
  spawn_feuerwerk(x,y, 255,255,0, 3)
end
function M.unlock (x, y)
  audio.play("unlock", x, y)
  spawn_feuerwerk(x,y, 255,255,0, 3)
end
function M.openchest (x, y)
  audio.play "Triumph"
  spawn_feuerwerk(x,y, 255,255,0, 20)
end
function M.drawsword(x, y)
  audio.play "hah"
  spawn_feuerwerk(x,y, 255,255,0, 2)
end
function M.enemyboost (x, y)
  audio.play("boost", x, y, 0.8)
--  audio.play(snd or "electro2", x, y)
  spawn_feuerwerk(x,y, 255,0,0, 7)
end
function M.hurtenemy (x, y)
  audio.play("hit", x, y)
  spawn_feuerwerk(x,y, 255,0,255, 5)
end
function M.grasscut (x, y)
  audio.play("hit", x, y)
  spawn_feuerwerk(x,y, 0,200,100, 5)
end
function M.hitboss (x, y)
  audio.play("explosion", nil, nil, nil, math.random()*1+2)
  M.shake(x,y, 3)
  spawn_feuerwerk(x,y, 255,0,255, 20)
end
function M.killenemy (x, y)
  audio.play "hit"
--  audio.play(snd or "electro2", x, y)
  M.shake(x,y, 3)
  spawn_feuerwerk(x,y, 255,0,255, 10)
end
function M.abled (x, y)
  audio.play("hit", x, y)
  spawn_feuerwerk(x,y, 50,100,200, 10)
end

return M
