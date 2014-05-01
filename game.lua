floor = math.floor
require "audio"
require "clamp"
require "switchs"
require "setType"
require "collision"
require "update"
audio = require "audio"
tiled = require "tiled"
require "maps"

local g = love.graphics
tw = 20

game = {}

pressed = {}
function game.keypressed (self, e)  pressed[e] = true  end
function game.keyreleased (self, e) pressed[e] = false end

function game.load (self)
  -- init
  font = g.newFont(16)
  g.setFont(font)

  -- load libs
  tiled.load(tw)

  -- the player
  player = {health=6, hearts=3, keys=0, rubies=0}

  return game
end

snow = {}
for i=1, 100 do table.insert(snow, {x=math.random()*w,y=0,vy=math.random()*5+1}) end

--lightningtimer = 100

function game.draw(self, dt)
  g.clear()
  g.push()
    g.scale(camera.zoom, camera.zoom)
    g.translate(cam_min_x-camera.x, cam_min_y-camera.y)

    tiled.draw_layers(map, state.pool)
    if DEBUG then game.update(self, dt, true) end

--    lightningtimer = lightningtimer - 1
--    g.setColor(255,255,255,255*lightningtimer/100)
--    if math.random() > lightningtimer/10 then
--      lightningtimer = 100
--      audio.play "hit"
--    end
--    g.rectangle("fill", 0,0,w,h)

    for i,s in ipairs(snow) do
      g.setColor(255,255,255,100)
      g.rectangle("fill", s.x-2, s.y-2, 4, 4)
      s.y = s.y + s.vy
      if s.y > h then
        s.y = 0
      end
    end
  g.pop()

  draw_hud()
end

function game.update (self, dt, from_draw)
  if from_draw or not DEBUG then
    calc_fps()

    change_level_timer = change_level_timer-1

    control()
    update_layers()

    if quit then quit() quit=nil end
  end
end

now = love.timer.getTime()
local last_frame = now
local fps = 0
function calc_fps ()
  now = love.timer.getTime()*1000
  local dt = now - last_frame
  fps = (59 * fps + 1000 / dt) / 60
  last_frame = now

  collisions = 0
  objs = 0
  bubbles = {}
end

s = ""
function draw_hud ()
  local x = math.max(0, w/2-400)
  local y = math.max(0, h/2-200)

--  g.setColor(0, 0, 0, 255*0.25)
--  g.rectangle("fill", 0, 0, x, h)
--  g.rectangle("fill", w-x, 0, x, h)
--  g.rectangle("fill", x, 0, w-2*x, y)
--  g.rectangle("fill", x, h-y, w-2*x, y)

  g.push()
  g.translate(x, y)

  g.setColor(255, 255, 255, 255)
  g.print(s, 26, 115);
  s = ""
  s = s .. "fps: " .. floor(fps)
  if DEBUG then
    s = s .. "\nx: " .. floor(avatar.x)
    s = s .. "\ny: " .. floor(avatar.y)
    s = s .. "\n"
    s = s .. "\ncollisions: " .. floor(collisions)
    s = s .. "\nobjs: " .. floor(objs)
  end

  for i = 1, player.hearts*2, 2 do
    local tile_idx =
      i+1 <= player.health and sprites_indexOf.HEART or
      i == player.health   and sprites_indexOf.HEART_HALF or
                               sprites_indexOf.HEART_EMPTY

    g.draw(tiled.tileset, tiled.quads[tile_idx], 15*i-2, 10, 0, 2, 2)
  end

  if player.rubies~=0 then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.RUBY1], 14, 50-2, 0, 2, 2)
    g.print(player.rubies, 14+30, 50+20)
  end

  if player.keys~=0 then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.KEY], 61, 50+2, 0, 2, 2)
    g.print(player.keys, 61+30, 50+20)
  end

  if player.bow then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.ARROW], 109+tw, 50+2+tw, math.pi/2, 2, 2, tw/2, tw/2)
    g.print(player.arrows or 0, 109+30, 50+20)
  end

  g.pop()
  textbubbles()
end

function textbubbles ()
  for i,o in ipairs(bubbles) do
    local text = o.text:gsub("\\n", "\n") or "ERROR MISSING TEXT"
    local width, height = font:getWrap(text, w/3)
    height = font:getHeight()*height
    local x = (o.x + cam_min_x-camera.x)*camera.zoom - width/2
    local y = (o.y + cam_min_y-camera.y - tw*2) *camera.zoom - height

    g.setColor(0, 0, 0, 0.66 * (o.alpha or 255))
    g.rectangle("fill", x-10, y-10, width+20, height+20)

    g.setColor(255, 255, 255, o.alpha or 255)
    g.printf(text, x, y, width, "center")
  end
end

tmp = game.update
function game.focus (self, e)
  if e then
    love.update = tmp
  else
    tmp, love.update = love.update, calc_fps
  end
end

function game.quit (self)
  if map.name ~= "mainmenu" then
    print("quitting")
    save_slot(slotname)
  end
end

