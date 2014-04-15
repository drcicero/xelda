require "math"
floor = math.floor
local g = love.graphics

local tiled, tw, tileset, projectiles, solidmap, watermap, player, quads
local DEBUG = true

function clamp (min, x, max)
  if x < min then return min
  elseif x > max then return max
  else return x end
end

local types = {}
local empty = {}
function setType (o, type)
  local old_type = types[o.type]
  if old_type ~= nil then
    for i = 1, #old_type do
      if old_type[i] == o then
        old_type[i] = empty
        break
      end
    end
  end

  o.type = type
  local need_new = true
  for i = 1, #types do
    if types[i] == empty then
      need_new = false
      types[i] = o
      break
    end
  end
  if need_new then table.insert(types[type], o) end

  return o
end

function love.load ()
  tiled = require "puzzle"
  tw = tiled.tilewidth
  solidmap = false
  watermap = false
  player = {health=6, hearts=3, keys=0, rubies=0, arrows=0}

  tileset = love.graphics.newImage "tileset.png"

  quads = {}
  local setw = tileset:getWidth()
  local seth = tileset:getHeight()
  local sw = setw / tw
  for i = 0, setw/tw * seth/tw do
    local quad = g.newQuad((i%sw)*tw, floor(i/sw)*tw, tw, tw, setw, seth)
    table.insert(quads, quad)
  end

  sprites = {
    "XELDA", "XELDA_WALK", "XELDA_SHIELD", "XELDA_HOLD", "XELDA_ATTACK", "XELDA_ATTACK2", "XELDA_BOW", "?",
    "RINK", "RINK_WALK", "RINK_SHIELD", "RINK_HOLD", "RINK_ATTACK2", "RINK_ATTACK", "RINK_BOW", "?",
    "SLIME", "ESLIME", "PIG", "SKELETON", "BAT1", "BAT2", "BAT_SIT", "GHOST",
    "HASH", "LAMP", "GLOVE", "BOW", "CONTAINER", "KEY", "?", "?",
    "BIGKEY", "BLOCK", "BOMB1", "BOMB2", "YELLOW", "CYAN", "MAGENTA", "?",
    "HEART_EMPTY", "HEART_HALF", "HEART", "RUBY", "RUBY5", "RUBY10", "RUBY50", "RUBY100",
    "ARROWS", "?", "?", "?", "DUMMY", "BOMB", "ARROW", "NUT",
    "?", "?", "?", "?", "?", "?", "?", "LOCK",
    "?", "?", "?", "?", "?", "?", "?", "HOLE",
    "?", "?", "SWITCH", "SWITCH2", "?", "?", "?", "CHEST",
    "?", "?", "?", "TABLET", "SHIELD", "?", "GRASS", "GRID",
    "?", "?", "TRIGGER", "TRIGGER2", "?", "?", "?", "?",
    "?", "?", "EYE", "EYE2", "?", "?", "?", "?",
    "?", "?", "?", "?", "?", "?", "?", "?",
    "?", "?", "?", "LAMPPOST", "LAMPPOST_ON", "?", "?", "?",
  }
  sprites_indexOf = {}

  types = {}
  for i,s in ipairs(sprites) do
    types[s] = {}
    sprites_indexOf[s] = i
  end

  for i,layer in ipairs(tiled.layers) do
    if layer.type == "objectgroup" then
      for i,o in ipairs(layer.objects) do
        if o.properties.player then player_obj = o end
        setType(o, sprites[o.gid] or "DUMMY")
        o.x = o.x+tw+tw/2
        o.y = o.y
        o.vx = 0
        o.vy = 0
        o.timer = 0
      end

    elseif layer.type == "tilelayer" and layer.opacity then
      local lw = layer.width
      if     layer.name == "Ground" then solidmap = layer.data
      elseif layer.name == "Water"  then watermap = layer.data end

      local cache = g.newCanvas(tiled.width * tiled.tilewidth, tiled.height * tiled.tileheight)
      cache:renderTo(function ()
        for i,tile in ipairs(layer.data) do
          if tile ~= 0 then
            g.draw(tileset, quads[tile], (i%lw)*tw, floor(i/lw)*tw)
          end
        end
      end)
      layer.cache = cache
    end
  end

  projectiles = {}
  table.insert(tiled.layers, {type="objectgroup", objects=projectiles})

  camera = { zoom = 1.5 }

  cam_min_x = g:getWidth()/camera.zoom / 2
  cam_min_y = g:getHeight()/camera.zoom / 2
  cam_max_x = tiled.width * tiled.tilewidth - cam_min_x
  cam_max_y = tiled.height * tiled.tileheight - cam_min_y

  camera.x = clamp(cam_min_x, player_obj.x, cam_max_x)
  camera.y = clamp(cam_min_y, player_obj.y, cam_max_y)

  g.setFont(g.newFont(12))
end

local now = love.timer.getTime()
local last_frame = now
local fps = 0
function calc_fps()
  now = love.timer.getTime()*1000
  local dt = now - last_frame
  fps = (59 * fps + 1000 / dt) / 60
  last_frame = now
end

function love.draw()
  g.clear()
  g.push()
  g.scale(camera.zoom, camera.zoom)
  g.translate(cam_min_x-camera.x, cam_min_y-camera.y)
  control(player_obj)
  draw_layers()
  g.pop()
  draw_hud()
end

function love.update ()
  calc_fps()

  collisions = 0
  objs = 0
  bubbles = {}

  camera.x = camera.x + (clamp(cam_min_x, player_obj.x, cam_max_x) - camera.x) / 6
  camera.y = camera.y + (clamp(cam_min_y, player_obj.y, cam_max_y) - camera.y) / 12

  update_layers()
end

pressed = {}
function love.keypressed (e)  pressed[e] = true  end
function love.keyreleased (e) pressed[e] = false end

local debugtimer = 0
local arrow = false
local hittimer = 0
local bowtimer = 0
function control (o)
  debugtimer = debugtimer-1
  if debugtimer < 0 and pressed["return"] then
    DEBUG = not DEBUG
    debugtimer = 10
  end

  if o.water then
--    if _music ~= audios.Beach then
--      play(audios.schwupp)
--      music("Beach")
--    end

    if pressed.up then       o.vy = o.vy - 0.2
    elseif pressed.down then o.vy = o.vy + 0.2 end

    if pressed.left then      o.vx = o.vx - 0.2
    elseif pressed.right then o.vx = o.vx + 0.2 end

    if pressed.up and
    (solid(o.x-15, o.y) or solid(o.x+15, o.y)) and
    not water(o.x, o.y-5) then
      o.vy = -6;
    end

    setType(o, hittimer > 10 and "RINK_ATTACK" or "RINK")
    hittimer = hittimer-1
    if hittimer < 0 and pressed[" "] then
--      setType(o, "RINK_ATTACK")
--      local as = {audios.hah,audios.hah2,audios.hah3}
--      play(as[floor(math.random()*2)])
      hittimer = 20
    end

    if o.type == "RINK" then
      local as = {"RINK_WALK", "RINK", "RINK_HOLD"}
      setType(o, as[floor(math.sin(now/100)*1.5+2.5)])
    end

    arrow = false;

  else
--    if _music ~= audios.Xelda then
--      play(audios.schwupp)
--      music("Xelda")
--    end

    setType(o,
      hittimer > 10 and "RINK_ATTACK" or
      (not arrow and bowtimer <= 15) and "RINK" or
      "RINK_BOW"
    )

    hittimer = hittimer-1
    if hittimer < 0 and pressed[" "] then
      setType(o, "RINK_ATTACK")
--      play([audios.hah,audios.hah2,audios.hah3][~~(Math.random()*2)])
      hittimer = 20

    elseif pressed.down then            setType(o, "RINK_SHIELD")
    elseif o.ground and pressed.up then o.vy = -7                 end

    if pressed.left then      o.vx = o.vx - (o.type ~= "RINK" and 0.1 or 0.5)
    elseif pressed.right then o.vx = o.vx + (o.type ~= "RINK" and 0.1 or 0.5) end

    if o.type == "RINK" and (pressed.left or pressed.right) then
      setType(o, math.sin(now/100)<0 and "RINK" or "RINK_WALK")
    end
  end
end

s = ""
function draw_hud ()
  g.setColor(255, 255, 255, 255)
  g.print("fps: " .. floor(fps), 10, 70)
  g.print("collisions: " .. floor(collisions), 10, 85)
  g.print("objs: " .. floor(objs), 10, 100)

--  local lines = string.split(s, "\n")
--  for i in ipairs(lines) do
--    g.print(lines[i], 10, 115+15*i);
--  end

  s = ""
end

function update_layers()
  for i,layer in ipairs(tiled.layers) do
    if layer.cache then
    else
      table.foreach(layer.objects, update_obj)
    end
  end
end

function draw_layers()
  for i,layer in ipairs(tiled.layers) do
    if layer.cache then
      local lprop = layer.properties
      local parallax_x = tonumber(lprop and lprop.parallax_x or 0)
      local parallax_y = tonumber(lprop and lprop.parallax_y or 0)
      local parallax_x = (i/#tiled.layers - 0.5) * parallax_x + 1
      local parallax_y = (i/#tiled.layers - 0.5) * parallax_y + 1

      local x = camera.x * (1-parallax_x)
      local y = camera.y * (1-parallax_y)

      if layer.name == "Water" then
        x = x - ((now+math.sin(now))%5000)/5000 * 4 * tw
        y = math.sin(now/500)*tw/4 + y
      end

      g.setColor(255, 255, 255, 255*layer.opacity)
      g.draw(layer.cache, x,y, 0, parallax_x,parallax_y);

    else
      table.foreach(layer.objects, draw_obj)
    end
  end
end

local updates = {}
function update_obj (i, o)
  if not o.disabled then
    objs = objs+1
    o.timer = o.timer-1
    local update = updates[o.type]
    if update then update(o) end
  end
end

function draw_obj (i, o)
  if not o.disabled then
    move_obj(o)

    if camera.x - cam_min_x < o.x and o.x < camera.x + cam_min_x
    and camera.y - cam_min_y < o.y and o.y < camera.y + cam_min_y then

      local sx if o.vx < 0 then sx=-1 else sx=1 end
      g.setColor(255,255,255,255)
      g.draw(tileset, quads[sprites_indexOf[o.type]], o.x-tw/2-(sx-1)*tw/2, o.y-tw, 0, sx, 1)

      if DEBUG then
        g.rectangle("line", o.x-tw/2, o.y-tw, tw, tw)
        g.rectangle("fill", o.x-2, o.y-2, 4, 4)
      end
    end
  end
end

function map(map, x, y)
  local result = map[floor(x/tw) + floor(y/tw)*tiled.width] ~= 0
  if DEBUG then
    if result then g.setColor(255,255,255,51)
    else           g.setColor(0,0,0,51)       end
    g.rectangle("fill", floor(x/tw)*tw, floor(y/tw)*tw, tw, tw)
  end
  return result
end
function solid(x, y) return solidmap and map(solidmap, x, y) end
function water(x, y) return watermap and map(watermap, x, y-15) end
function grid() return false end
function projectileType() return false end

function move_obj (o)
  o.water = water(o.x, o.y+tw/2+2)
  if o.water then
    o.vx = 0.9*o.vx
    o.vy = 0.9*o.vy
  end

  local w = tw/2
  local facing = 1
  if o.vx < 0 then facing = -1 end
  if o.vx ~= 0 then
    if solid(o.x+o.vx+facing*w, o.y) or grid(o.x, o.y) then
      o.vx = 0
    end
  end

  o.ground = o.vy >= 0 and (
    solid(o.x, o.y+o.vy+1) or
    grid(o.x, o.y+o.vy+1) or
    (not o.type=="BLOCK" and grid(o.x, o.y) and block(o.x, o.y+o.vy+1))
  )

  if not o.water then
    if o.ground then
      o.vx = 0.8*o.vx

    else
      o.vx = o.vx * 0.8
      o.vy = o.vy+0.5
    end
  end

  if o.ground or (o.vy < 0 and (solid(o.x, o.y+o.vy-w) or grid(o.x, o.y+o.vy-w))) then
    o.vy = 0
  end

  o.x = o.x+o.vx
  o.y = o.y+o.vy
end
