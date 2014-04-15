require "math"
floor = math.floor
local g = love.graphics

local tiled, tw, tileset, projectiles, groundmap, watermap, player, quads

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
    old_type[i] = empty
    local i = sprites_indexOf[old_type]
  end

  o.type = type
  local need_new = true
  for i = 0, #types do
    if types[i] == empty then
      need_new = false
      types[i] = o
    end
  end
  if need_new then table.insert(types[type], o) end

  return o
end

function love.load ()
  tiled = require "puzzle"
  tw = tiled.tilewidth
  groundmap = false
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
        o.x = o.x + tw/2
        o.y = o.y - tw/2
        o.timer = 0
        o.vx = 0
        o.vy = 0
        setType(o, sprites[o.gid] or "DUMMY")
        if o.properties.player then
          player_obj = o
        end
      end

    elseif layer.type == "tilelayer" and layer.opacity then
      if     layer.name == "Ground" then groundmap = layer.data
      elseif layer.name == "Water"  then watermap = layer.data end

      local cache = g.newCanvas(tiled.width * tiled.tilewidth, tiled.height * tiled.tileheight)
      cache:renderTo(function ()
        for i,tile in ipairs(layer.data) do
          if tile ~= 0 then
            local lw = layer.width
            g.draw(tileset, quads[tile], (i%lw)*tw, floor(i/lw)*tw)
          end
        end
      end)
      layer.cache = cache
    end
  end

  projectiles = {}
  table.insert(tiled.layers, {type="objectgroup", objects=projectiles})

  cam_min_x = g:getWidth() / 2
  cam_min_y = g:getHeight() / 2
  cam_max_x = tiled.width * tiled.tilewidth - g:getWidth() / 2
  cam_max_y = tiled.height * tiled.tileheight - g:getHeight() / 2

  camera = {
    zoom=1,
    x=clamp(cam_min_x, player_obj.x, cam_max_x),
    y=clamp(cam_min_y, player_obj.y, cam_max_y)
  }

  g.setFont(g.newFont(11))
end

local dt = dt
function love.update (dt_)
  dt = dt_
end

local last_frame
local now = love.timer.getTime()
local last_frame = now
local fps = 0

function calc_fps()
  now = love.timer.getTime()
  local dt = now - last_frame
  fps = (0 * fps + 1000 / dt) / 1
  last_frame = now
end

function love.draw()
  calc_fps()

  collisions = 0
  objs = 0
  bubbles = {}

  camera.x = camera.x + (clamp(cam_min_x, player_obj.x, cam_max_x) - camera.x) / 6
  camera.y = camera.x + (clamp(cam_min_y, player_obj.y, cam_max_y) - camera.y) / 12

  g.clear()
  g.push()
    g.scale(camera.zoom, camera.zoom)
    g.translate(cam_min_x-camera.x, cam_min_y-camera.y)

    --control(player_obj)
    draw_layers()
  g.pop()

  draw_hud()
end

s = ""
function draw_hud ()
  g.setColor(255, 255, 255, 255)
  g.print("fps: " .. floor(dt), 10, 70)
  g.print("collisions: " .. floor(collisions), 10, 85)
  g.print("objs: " .. floor(objs), 10, 100)

--  local lines = string.split(s, "\n")
--  for i in ipairs(lines) do
--    g.print(lines[i], 10, 115+15*i);
--  end

  s = ""
end

function draw_layers()
  for i,layer in ipairs(tiled.layers) do
    if layer.cache then
      local lprop = layer.properties
      local parallax_x = tonumber(lprop and lprop.parallax_x or 0)
      local parallax_y = tonumber(lprop and lprop.parallax_y or 0)
      local parallax_x = (i/#tiled.layers - 0.5) * parallax_x + 1
      local parallax_y = (i/#tiled.layers - 0.5) * parallax_y + 1

      local x = camera.x-g.getWidth()/2/camera.zoom
      local y = camera.y-g.getHeight()/2/camera.zoom
      local w = g:getWidth()/camera.zoom
      local h = g:getHeight()/camera.zoom

      g.setColor(255, 255, 255, 255*layer.opacity)
      g.draw(layer.cache, x,y, 0, parallax_x,parallax_y);

    else
      table.foreach(layer.objects, draw_obj)
    end
  end
end

local updates = {}
function draw_obj (i, o)
  if not o.disabled then
    objs = objs+1
    o.timer = o.timer-1
    move_obj(o)

    local update = updates[o.type]
    if update then update(o) end

    if camera.x - cam_min_x < o.x and o.x < camera.x + cam_min_x
    and camera.y - cam_min_y < o.y and o.y < camera.y + cam_min_y then

      local sx if o.vx < 0 then sx=-1 else sx=1 end
      g.draw(tileset, quads[sprites_indexOf[o.type]], o.x-tw/2, o.y, 0, sx)

    end
  end
end

function solid() return false end
function grid() return false end
function projectileType() return false end

function move_obj (o)
  o.water = water(o.x, o.y+tw/2+2)
  if o.water then
    o.vx = 0.9*o.vx
    o.vy = 0.9*o.vy
  end

  if o.vx <= 0 then
    local w = tw/2
    if o.vx < 0 then w = -w end
    if solid(o.x+o.vx+w, o.y) or grid(o.x, o.y) then
      o.vx = 0
    end
  end

  o.ground = o.vy >= 0 and (
    solid(o.x, o.y+o.vy+w+1) or
    grid(o.x, o.y+o.vy+1) or
    (not o.type="BLOCK" and grid(o.x, o.y) and block(o.x, o.y+o.vy+1))
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
