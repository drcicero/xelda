local g = love.graphics
local stage, tw, projectiles, solidmap, watermap, player

DEBUG = false

require "math"
floor = math.floor

require "clamp"
require "audio"
require "switchs"
require "setType"
require "collision"
audio = require "audio"
tiled = require "tiled"

function love.load ()
  CANVAS = g.isSupported("canvas", "npot")

  audio.load()

  player = {health=6, hearts=3, keys=0, rubies=0, arrows=0}
  solidmap = false
  watermap = false

  stage = require "maps/puzzle"
  tw = stage.tilewidth
  tiled.load(tw)

  for i,layer in ipairs(stage.layers) do
    if layer.type == "objectgroup" then
      for i,o in ipairs(layer.objects) do
        if o.properties.player then player_obj = o end
        setType(o, sprites[o.gid] or "DUMMY")
        o.x = o.x+tw*3/2
        o.vx = 0
        o.vy = 0
        o.timer = 0
      end

    elseif layer.type == "tilelayer" and layer.opacity then
      if     layer.name == "Ground" then solidmap = layer.data
      elseif layer.name == "Water"  then watermap = layer.data end
    end
  end

  projectiles = {}
  table.insert(stage.layers, {type="objectgroup", objects=projectiles, name="projectiles"})

  camera = { zoom = 1.5 }

  cam_min_x = g:getWidth()/camera.zoom / 2
  cam_min_y = g:getHeight()/camera.zoom / 2
  cam_max_x = stage.width * stage.tilewidth - cam_min_x
  cam_max_y = stage.height * stage.tileheight - cam_min_y

  camera.x = clamp(cam_min_x, player_obj.x, cam_max_x)
  camera.y = clamp(cam_min_y, player_obj.y, cam_max_y)

  g.setFont(g.newFont(12))

  audio.music "Xelda"

  if CANVAS then
    for i,layer in ipairs(stage.layers) do
      if layer.type == "tilelayer" then
        local cache = g.newCanvas(stage.width * stage.tilewidth, stage.height * stage.tileheight)

        g.setCanvas(cache)
        g.setColor(255, 255, 255, 255*layer.opacity)
        tiled.draw_layer(layer, 0, 0, 0, 1, 1)

        layer.cache = cache
      end
    end
  end
  g.setCanvas()
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
    update_layers()

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
end

pressed = {}
function love.keypressed (e)  pressed[e] = true  end
function love.keyreleased (e) pressed[e] = false end

local arrow = false
local fullscreentimer = 0
local debugtimer = 0
local hittimer = 0
local bowtimer = 0
function control (o)
  fullscreentimer = fullscreentimer-1
  if pressed.lalt and pressed["return"] then
    love.window.setFullscreen(not love.window.getFullscreen())
    fullscreentimer = 10
  end
  debugtimer = debugtimer-1
  if debugtimer < 0 and pressed["return"] then
    DEBUG = not DEBUG
    debugtimer = 10
  end

  if o.water then
    if audio._music ~= "Beach" then
      audio.play "schwupp"
      audio.music "Beach"
    end

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
    if audio._music ~= "Xelda" then
      audio.play "schwupp"
      audio.music "Xelda"
    end

    setType(o,
      hittimer > 10 and "RINK_ATTACK" or
      (not arrow and bowtimer <= 15) and "RINK" or
      "RINK_BOW"
    )

    hittimer = hittimer-1
    if hittimer < 0 and pressed[" "] then
      setType(o, "RINK_ATTACK")
--      play([audios.hah,audios.hah2,audios.hah3][~~(math.random()*2)])
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
  for i,layer in ipairs(stage.layers) do
    if layer.type == "objectgroup" then
      table.foreach(layer.objects, update_obj)
    end
  end
end

function draw_layers()
  for i,layer in ipairs(stage.layers) do
    if layer.type == "tilelayer" then
      local lprop = layer.properties
      local parallax_x = (i/#stage.layers - 0.5) * tonumber(lprop and lprop.parallax_x or 0) + 1
      local parallax_y = (i/#stage.layers - 0.5) * tonumber(lprop and lprop.parallax_y or 0) + 1
      local x = camera.x * (1-parallax_x)
      local y = camera.y * (1-parallax_y)

      if layer.name == "Water" then
        x = x - (now%1000)/1000 * tw*1.25
        y = math.sin(now/500) * tw/4 + y
      end

      if CANVAS then
        g.setColor(255, 255, 255, 255)
        g.setBlendMode("premultiplied")
        g.draw(layer.cache, x, y, 0, parallax_x, parallax_y)
        g.setBlendMode("alpha")

      else
        g.setColor(255, 255, 255, 255*layer.opacity)
        tiled.draw_layer(layer, x, y, 0, parallax_x, parallax_y)
      end

    elseif layer.type == "objectgroup" then
      table.foreach(layer.objects, draw_obj)
    end
  end
end

function arrow_hurt (x)
  for i,s in ipairs({"TRIGGER", "TRIGGER2", "EYE", "EYE2", "BAT1", "BAT2", "BAT_SIT", "SLIME", "PIG", "SKELETON", "GHOST"}) do
    if x == s then return true end
  end return false
end

function sword_hurt (x)
  for i,s in ipairs({"GRASS", "LOCK", "CHEST", "LAMPPOST_ON", "TRIGGER", "TRIGGER2", "EYE", "EYE2", "BAT1", "BAT2", "BAT_SIT", "SLIME", "PIG", "SKELETON", "GHOST"}) do
    if x == s then return true end
  end return false
end

function player_hurt (x)
  for i,s in ipairs({"BAT1", "BAT2", "NUT", "BAT_SIT", "PIG", "SLIME", "ESLIME", "SKELETON"}) do
    if x == s then return true end
  end return false
end


function add_obj (type, x, y, vx, vy)
  local o
  for i,p in ipairs(projectiles) do
    if p.disabled then
      o = p
      break
    end
  end
  if not o then
    o = {}
    table.insert(projectiles, o)
  end

  setType(o, type)
  o.timer = 0
  o.x = x
  o.y = y
  o.vx = vx or 0
  o.vy = vy or 0
  o.properties = {}
  o.disabled = false
end

function hurt_enemy (o)
  if o.type == "CHEST" then
    o.disabled = true

    audio.music()
    audio.play "Triumph"

    local tmp = control
    control = function () end
    setType(player_obj, "RINK_HOLD")

    add_obj(o.properties.item, o.x, o.y-tw, 0, -4)

    local tmp2 = love.update
    local start = now

    local time = 7000 --[[audios.Triumph.duration*1000 CONTAINER BIGKEY BOW LAMP]]

    love.update = function ()
      calc_fps()

      if now - start > time then
        control = tmp
        love.update = tmp2
      end
    end

  else
    audio.play "hit"
    add_obj(
      player.health < player.hearts*2 and Math.random() > 0.5 and "HEART"
      or player.bow and Math.random() > 0.5 and "ARROWS" or "RUBY1",
      o.x, o.y-tw, 0, -4
    )
    o.disabled = true

  end
end

local updates = {}
function update_obj (i, o)
  if not o.disabled then
    objs = objs+1
    o.timer = o.timer-1

    move_obj(o)

    local update = updates[o.type]
    if update then update(o) end

    if arrow_hurt(o.type) then
      for i,p in ipairs(projectiles) do
        if p.timer <= 0 and p.type == "ARROW" and collision(o.x,o.y-tw/2, p.x,p.y-tw/2, tw/2,tw/2) then
          hurt_enemy(o)
        end
      end
    end

    if player_obj.type == "RINK_ATTACK" and sword_hurt(o.type)
    and collision(player_obj.x + player_obj.facing*10, player_obj.y-tw/2, o.x, o.y-tw/2, tw/4, tw/2) then
      hurt_enemy(o)
    end

    if player_obj.timer < 0 and player_obj.type ~= "RINK_SHIELD"
    and player_hurt(o)
    and pl_col(o.x, o.y-tw/2, tw/2) then
      hurt_player()
    end

    if o.type:sub(1, 4) == "RUBY" and pl_col(o.x, o.y-tw/2, tw/4) then
      audio.play "ding"
      player.rubies = player.rubies + tonumber(o.type:sub(5))
      o.disabled = true

    elseif not player.grab and pressed.c
    and (o.type == "CYAN" or o.type == "YELLOW" or o.type == "MAGENTA")
    and pl_col(o.x, o.y-tw/2, tw/4) then
      player.grab = o;
    end


  end
end

function draw_obj (i, o)
  if not o.disabled then
    if camera.x - cam_min_x < o.x and o.x < camera.x + cam_min_x
    and camera.y - cam_min_y < o.y and o.y < camera.y + cam_min_y then

      local sx if o.vx < 0 then sx=-1 else sx=1 end
      g.setColor(255,255,255,255)
      g.draw(tiled.tileset, tiled.quads[sprites_indexOf[o.type]], o.x-tw/2-(sx-1)*tw/2, o.y-tw, 0, sx, 1)

      if DEBUG then
        g.rectangle("line", o.x-tw/2, o.y-tw, tw, tw)
        g.rectangle("fill", o.x-2, o.y-2, 4, 4)
      end
    end
  end
end

function map(map, x, y)
  local result = map[floor(x/tw) + floor(y/tw)*stage.width] ~= 0
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
  if o.vx < 0 then o.facing = -1 else o.facing = 1 end

  if o.vx ~= 0 then
    if solid(o.x+o.vx+o.facing*w, o.y) or grid(o.x, o.y) then
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
