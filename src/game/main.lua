--- The Game Manager
--
-- implements frame from $frames, can push $menu.pause.
--
-- has a $cron, $events and a $camera.
--
-- advances $scripting and $ingamedebug.
--
-- see also $game.update, $game.draw.
local app = require "frames"
local cron = require "cron"
local events = require "events"

local draw = require "map.draw"
local camera = require "map.camera"
local scripting = require "map.scripting"

local pausemenu = require "menus.pause"
local display_debug = require "ingamedebug"

require "game.update"

local g = love.graphics

local game = {name="game"}
change_level_timer = 0
hud_objs = {}
tw = 20
topisgame = false

bubbles = {}

---- Frame implementation

--- create a hudclock and call $draw#draw.load .
function game.load (self)
  hudclock = cron.new_clock()
  draw.load(tw)

  return game
end

day = false
--- setfont 'font', draw background, shadow and weather, call $draw#draw.draw_layers
function game.draw(self, dt)
  g.setFont(font)

  local outside = (
     persistence.mapname == "ice_boss"
  or persistence.mapname == "village" 
  or persistence.mapname == "mainmenu"
  )

  if outside and day then
    g.setColor(50,200,200,255)
    g.rectangle("fill", 0,0, w, h)
  end
  g.push()
    g.scale(camera.zoom, camera.zoom)
    g.translate(camera.w/2-camera.x, camera.h/2-camera.y)

    draw.draw_layers(transient, persistence[persistence.mapname].pool)
    if DEBUGupdate then DEBUGupdate(self, dt, true) DEBUGupdate = false end

    if outside then draw_weather() end
  g.pop()

  if not (outside and day) then
    draw_shadow()
  end

  draw_hud()
end

--- update clocks, call $events#M.update, $camera#camera.follow, $update#control if topisgame. update_obj
function game.update (self, dt, from_draw)
  if from_draw or not DEBUG then
    bubbles = {}

    change_level_timer = change_level_timer-1

    hudclock.update()
    levelclock.update()
    events.update()

    camera.follow(avatar)

    if topisgame then
      control()
      if pressed.escape then
        pressed.escape = false
        app.push(pausemenu())
      end
    end

    table.foreach(
      persistence[persistence.mapname].pool,
      update_obj )
    scripting.hook("update")

    if quit then
      local tmp = quit
      quit = nil
      tmp()
    end

  elseif not from_draw and DEBUG then
    DEBUGupdate = game.update
  end
end

--- set topisgame
function game.focus (self, e)
  topisgame = true
  scripting.hook("focus")
end

--- del topisgame
function game.blur (self, e)
  topisgame = false
end


--- pressed = {}
-- a table of key=true pairs where key is a currently pressed key
pressed = {}

--- set pressed[key] to true
function game.keypressed (self, e)  pressed[e] = true  end
--- set pressed[key] to false
function game.keyreleased (self, e) pressed[e] = false end


---- Rest

s = ""
--- draw hearts, rubies, arrows and so on.
function draw_hud ()
  if topisgame then
    g.push()
      g.scale(camera.zoom, camera.zoom)
      for i,o in pairs(hud_objs) do
        local sx = o.r==math.huge and o.facing or 1
        local r = o.r==math.huge and 0 or o.r
        g.setColor(255, 255, 255, (o.alpha or 255)/4*3)
        g.draw(draw.tileset, draw.quads[sprites_indexOf[o.type]],
          o.x,o.y, r, sx,1, o.ix,o.iy)
      end
    g.pop()
  end

  local floor = math.floor
  local x = math.max(0, w/2-400)
  local y = math.max(0, h/2-200)

  --  g.setColor(0, 0, 0, 255*0.25)
  --  g.rectangle("fill", 0, 0, x, h)
  --  g.rectangle("fill", w-x, 0, x, h)
  --  g.rectangle("fill", x, 0, w-2*x, y)
  --  g.rectangle("fill", x, h-y, w-2*x, y)

  g.push()
  g.translate(x, y)

  display_debug()

  g.setColor(255, 255, 255, 255)
  g.setFont(font)

  if topisgame then
    local z
    if persistence.vars.health == 2 then
      z = 2+math.sin(now/200)*0.5

    elseif persistence.vars.health == 1 then
      z = 2+math.sin(now/100)*1

    else
      z = 2
    end

    for i = 1, persistence.vars.hearts*2, 2 do
      local tile_idx =
        i+1 <= persistence.vars.health and sprites_indexOf.HEART or
        i == persistence.vars.health   and sprites_indexOf.HEART_HALF or
                                 sprites_indexOf.HEART_EMPTY

      g.draw(draw.tileset, draw.quads[tile_idx], 15*i+20, 10+20, 0, z, z, 10, 10)
    end
  end

  local x, y = 15, 50
  if persistence.vars.rubies~=0 then
    g.draw(draw.tileset, draw.quads[sprites_indexOf.RUBY1],
      x, y-2, 0, 2, 2)
    g.print(persistence.vars.rubies, x +30, y +20)
  end

  if topisgame then
    local x = 70
    if persistence.vars.keys~=0 then
      g.draw(draw.tileset, draw.quads[sprites_indexOf.KEY],
        x, y+2, 0, 2, 2)
      g.print(persistence.vars.keys, x +30, y +20)
    end

    local x = 125
    if persistence.vars.bow then
      g.draw(draw.tileset, draw.quads[sprites_indexOf.ARROW],
        x +tw, y+2 +tw, math.pi/2, 2, 2, tw/2, tw/2)
      g.print(persistence.vars.arrows or 0, x+30, y +20)
    end
  end

  g.pop()
  textbubbles()
end

--- draw textbubbles
function textbubbles ()
--  g.setFont(font)
  for i,o in ipairs(bubbles) do
    local text = o.text:gsub("\\n", "\n") or "ERROR MISSING TEXT"
    local width, height = font:getWrap(text, w/3)
    height = font:getHeight()*height
    local x = (o.x + camera.w/2-camera.x)*camera.zoom - width/2
    local y = (o.y + camera.h/2-camera.y - tw*2) *camera.zoom - height

    g.setColor(0, 0, 0, 0.66 * (o.alpha or 255))
    g.rectangle("fill", x-10, y-10, width+20, height+20)

    g.setColor(255, 255, 255, o.alpha or 255)
    g.setFont(font)
    g.printf(text, x, y, width, "center")
  end
end

--lightningtimer = 100

snow = {}
for i=1, 20 do table.insert(snow, {x=math.random()*w,y=0,vx=math.random()*5-5,vy=math.random()*10+10}) end

shadow = g.newCanvas(w, h)
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
    g.setColor(200, 200, 255, 100)
    g.line(s.x, s.y, s.x+s.vx, s.y+s.vy)
    s.x = s.x + s.vx
    s.y = s.y + s.vy

    camera.wrap(s)
  end
end

function draw_shadow ()
  g.setCanvas(shadow)
    g.setBlendMode("alpha")
    g.setColor(0,0,0,200)
    g.rectangle("fill",0,0,w,h)

    g.setColor(255,255,255,255)

    g.setBlendMode("additive")
    local z = 6.5*camera.zoom
    g.draw(light, w/2-light:getWidth()/2*z,h/2-light:getHeight()/2*z, 0, z, z)

  g.setCanvas()
  g.setBlendMode("multiplicative")
  g.draw(shadow, 0, 0)

  g.setBlendMode("alpha")
end


--function game.clear()
--  draw.clear_layers()
--end

return game
