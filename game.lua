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
pausemenu = require "pausemenu"

require "levelscripts"

hud_objs = {}
local g = love.graphics
tw = 20

game = {}
bubbles = {}

pressed = {}
function game.keypressed (self, e)  pressed[e] = true  end
function game.keyreleased (self, e) pressed[e] = false end

function game.load (self)
  -- init
  font = g.newFont(16)
  g.setFont(font)

  -- load libs
  tiled.load(tw)

  return game
end

function game.draw(self, dt)
  g.push()
    g.scale(camera.zoom, camera.zoom)
    g.translate(cam_min_x-camera.x, cam_min_y-camera.y)

    tiled.draw_layers(transient, persistence[transient.name].pool)
    if DEBUGupdate then DEBUGupdate(self, dt, true) DEBUGupdate = false end

    draw_weather()
  g.pop()

  g.setCanvas(asd)

  g.setBlendMode("alpha")
  g.setColor(0,0,0,200)
  g.rectangle("fill",0,0,w,h)

  g.setColor(255,255,255,255)

  g.setBlendMode("additive")
  local z = 6.5*camera.zoom
  g.draw(light, w/2-light:getWidth()/2*z,h/2-light:getHeight()/2*z, 0, z, z)

  g.setCanvas()
  g.setBlendMode("multiplicative")
  g.draw(asd, 0, 0)

  g.setBlendMode("alpha")

  g.push()
    g.scale(camera.zoom, camera.zoom)
    for i,o in pairs(hud_objs) do
      local sx = o.r==math.huge and o.facing or 1
      local r = o.r==math.huge and 0 or o.r
      g.setColor(255, 255, 255, (o.alpha or 255)/4*3)
      g.draw(tiled.tileset, tiled.quads[sprites_indexOf[o.type]],
        o.x,o.y, r, sx,1, o.ix,o.iy)
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
    if level[transient.name] then level[transient.name].update() end

    if quit then quit() quit=nil end

    if pressed.escape then
      pressed.escape = false
      push_app_state(pausemenu.pausemenu())
    end
  elseif not from_draw and DEBUG then
    DEBUGupdate = game.update
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

  s = s .. "fps: " .. floor(fps)

--  s = s .. "\naudio.lua:"
--  for id, channel in pairs(audio.channels) do
--    s = s .. "\n  [" .. id .. "] " .. tostring(channel.name) .. " : " .. channel.vol
--  end

  if DEBUG then
    s = s .. "\nx: " .. floor(avatar.x)
    s = s .. "\ny: " .. floor(avatar.y)
    s = s .. "\n"
    s = s .. "\ncollisions: " .. floor(collisions)
    s = s .. "\nobjs: " .. floor(objs)
    s = s .. "\n"

    for i,o in ipairs(persistence[transient.name].pool) do
      if table.anykey(types.REMOVED, function(x) return o==x end) then
        g.setColor(255, 255, 0, 100)
      else
        g.setColor(255, 255, 255, 100)
      end
      g.print("  " .. math.floor(o.x) ..",".. math.floor(o.y) .." ".. o.type, 26, 115+(8+i)*15)
    end

--    for i,o in ipairs(app_states) do
--      s = s .. "\n" .. (o.draw == menu.app.draw and "menu" or o.draw == game.draw and "game" or "?")
--    end
  end


  g.setColor(255, 255, 255, 100)
  g.print(s, 26, 115);
  s = ""

  g.setColor(255, 255, 255, 255)
  local z
  if persistence.vars.health == 2 then
    z = 2+math.sin(now/200)*0.5

  elseif persistence[transient.name].vars.health == 1 then
    z = 2+math.sin(now/100)*1

  else
    z = 2
  end

  for i = 1, persistence.vars.hearts*2, 2 do
    local tile_idx =
      i+1 <= persistence.vars.health and sprites_indexOf.HEART or
      i == persistence.vars.health   and sprites_indexOf.HEART_HALF or
                               sprites_indexOf.HEART_EMPTY

    g.draw(tiled.tileset, tiled.quads[tile_idx], 15*i+20, 10+20, 0, z, z, 10, 10)
  end

  if persistence.vars.rubies~=0 then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.RUBY1], 14, 50-2, 0, 2, 2)
    g.print(persistence.vars.rubies, 14+30, 50+20)
  end

  if persistence.vars.keys~=0 then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.KEY], 61, 50+2, 0, 2, 2)
    g.print(persistence.vars.keys, 61+30, 50+20)
  end

  if persistence.vars.bow then
    g.draw(tiled.tileset, tiled.quads[sprites_indexOf.ARROW], 109+tw, 50+2+tw, math.pi/2, 2, 2, tw/2, tw/2)
    g.print(persistence.vars.arrows or 0, 109+30, 50+20)
  end

  g.pop()
  textbubbles()
end

function textbubbles ()
  g.setFont(font)
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
  bubbles = {}
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
end

--lightningtimer = 100

snow = {}
for i=1, 50 do table.insert(snow, {x=math.random()*w,y=0,vx=math.random()*5-5,vy=math.random()*10+10}) end

asd = g.newCanvas(w, h)
light = g.newImage("assets/light.png")

function draw_weather ()
--    lightningtimer = lightningtimer - 1
--    g.setColor(255,255,255,255*lightningtimer/100)
--    if math.random() > lightningtimer/10 then
--      lightningtimer = 100
--      audio.play "hit"
--    end
--    g.rectangle("fill", 0,0,w,h)

  for i,s in ipairs(snow) do
    g.setColor(200, 200, 255, 50)
    g.line(s.x, s.y, s.x+s.vx, s.y+s.vy)
    s.x = s.x + s.vx
    s.y = s.y + s.vy

    if s.x < camera.x-cam_min_x then s.x = camera.x+cam_min_x end
    if s.x > camera.x+cam_min_x then s.x = camera.x-cam_min_x end
    if s.y < camera.y-cam_min_y then s.y = camera.y+cam_min_y end
    if s.y > camera.y+cam_min_y then s.y = camera.y-cam_min_y end
  end
end
