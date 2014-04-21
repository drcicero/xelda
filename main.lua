
-- TODO FIXME draw state.pool !!!

local g = love.graphics
g.setDefaultFilter("linear", "nearest")

tw = 20
change_level_timer = 0

require "math"
floor = math.floor

require "saveload"
require "clamp"
require "audio"
require "switchs"
require "setType"
require "collision"
require "update"
audio = require "audio"
tiled = require "tiled"
require "maps"

function love.load ()
  -- options
  DEBUG = false

  -- FIXME with canvas tilemaps are no longer visible
  --CANVAS = g.isSupported("canvas", "npot")

  -- init
  font = g.newFont(16)
  g.setFont(font)

  -- load libs
  audio.load()
  tiled.load(tw)

  -- load menu
  change_level "mainmenu"

  -- the player
  player = {health=6, hearts=3, keys=0, rubies=0}

  -- is there a save file?
  if love.filesystem.exists("save.lua") then setVar("first_play", true) end

--  -- init special vars
--  calc_fps()
--  update_layers()
end

function love.draw(dt)
  g.clear()
  g.push()
    g.scale(camera.zoom, camera.zoom)
    g.translate(cam_min_x-camera.x, cam_min_y-camera.y)

    tiled.draw_layers(map, state.pool)
    if DEBUG then love.update(dt, true) end
  g.pop()

  draw_hud()
end

function love.update (dt, from_draw)
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

pressed = {}
function love.keypressed (e)  pressed[e] = true  end
function love.keyreleased (e) pressed[e] = false end

s = ""
function draw_hud ()
  local x = math.max(0, w/2-400)
  local y = 0 -- math.max(0, h/2-200)

  g.setColor(0, 0, 0, 10)
  g.rectangle("fill", 0, 0, x, h)
  g.rectangle("fill", w-x, 0, x, h)
  g.rectangle("fill", x, 0, w-2*x, y)
  g.rectangle("fill", x, h-y, w-2*x, y)

  g.push()
  g.translate(x, y)

  g.setColor(255, 255, 255, 255)
  g.print("fps: " .. floor(fps), 26, 115)
--  g.print("collisions: " .. floor(collisions), 10, 85)
--  g.print("objs: " .. floor(objs), 10, 100)
--  g.print(s, 10, 130);
--  s = ""

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
    local width, height = font:getWrap(o.text, w/3)
    height = font:getHeight()*height
    local x = (o.x + cam_min_x-camera.x)*camera.zoom - width/2
    local y = (o.y + cam_min_y-camera.y - tw*2) *camera.zoom - height

    g.setColor(0, 0, 0, 0.66*255)
    g.rectangle("fill", x-10, y-10, width+20, height+20)

    g.setColor(255, 255, 255, 255)
    love.graphics.printf(o.text, x, y, width, "center")
  end
end

tmp = love.update
function love.focus (e)
  if e then
    love.update = tmp
  else
    love.update = calc_fps
  end
end

function love.quit ()
  if map.name ~= "mainmenu" then
    print("quitting")
    save_game()
  end
end

