--- Control
-- Control the object in the global variable 'avatar'. Moving, jumping,
-- attacking, rolling, etc.
--
-- requires $lib.cron, $lib.audio, $src.sfx, $src.map.camera, $src.map.scripting

local cron = require "cron"
local audio = require "audio"

local sfx = require "sfx"
local persistence = require "state"

local pool = require "pool"
local camera = require "map.camera"
local scripting = require "map.scripting"

local function action() return pressed[" "]  or pressed.y or pressed.z end
local function up()     return pressed.up    or pressed.j or pressed.w end
local function down()   return pressed.down  or pressed.k or pressed.s end
local function left()   return pressed.left  or pressed.h or pressed.a end
local function right()  return pressed.right or pressed.l or pressed.d end

local function b2n(bool) return bool and 1 or 0 end

sword = false
local doing = nil

function unsword ()
  if sword then
    persistence.vars.occupied = false
    pool.del(sword)
    sword = false
    pressed[" "] = false pressed.y = false pressed.z = false
    doing = nil
    avatar.noface = false
  end
end

local arrow = false

local arrow_timer = 0
local rolling_timer = 0

local CONTROL = true

---
local function quake_camera_on_low_health(o)
  if persistence.vars.health == 2 then
    camera.x = camera.x + math.random()
    camera.y = camera.y + math.random()

  elseif persistence.vars.health == 1 then
    camera.x = camera.x + math.random()*3
    camera.y = camera.y + math.random()*3
  end

  if o.timer > 0 then o.alpha = (40-o.timer)/40*255 end
end

---
local function control_secondary_music(o)
  if o.water then
    if audio.channels.default.vol ~= 1/3 then
      audio.music("droplets", "droplets")
      audio.setVol(1/3, "default")
    end

  else
    if audio.channels.default.vol ~= 1 then
      audio.music(nil, "droplets")
      audio.play "schwupp"
      audio.setVol(1, "default")
    end
  end
end

---
local function control_grab(o)
  if persistence.vars.grab and not action() then
    persistence.vars.occupied = false
    persistence.vars.grab = nil
  end

  if persistence.vars.grab then
    persistence.vars.grab.x = o.x + o.facing * 5
    persistence.vars.grab.y = o.y
    persistence.vars.grab.vx = avatar.vx
    persistence.vars.grab.vy = avatar.vy

--    THROW GRABBED THINGS
--    if pressed.x then
--      arrow = persistence.vars.grab
--      persistence.vars.grab = false
--    end
  end
end

---
local function control_sword(o)
  if persistence.vars.sword then
    if sword and sword.type ~= "REMOVED" then
      sword.timer = sword.timer-1

      o.type = persistence.vars.avatar_name .. "_ATTACK"
      local a = -sword.timer/5
      sword.x, sword.y = o.x - o.facing, o.y - 8
      sword.vx = o.facing
      sword.properties.ghost = true
      sword.r = o.facing == 1 and a or - a

      sword.timer = math.max(sword.timer, 2)
      if not action() then
        unsword()
      end

    elseif not persistence.vars.occupied and action() then
      if space_register ~= nil then
        space_register()

      else
        persistence.vars.occupied = true
        o.noface = true
        o.type = persistence.vars.avatar_name .. "_ATTACK"

        sword = pool.spawn("SWORD", o.x, o.y-8)
        sfx.drawsword(o.x+o.facing*15, o.y-10)

        sword.timer = 5
        sword.ox = -4
        sword.oy = 2.5
        sword.height = 5
        sword.ix = -4
        sword.iy = 10

        local a = -sword.timer/5
        sword.x, sword.y = o.x, o.y-8
        sword.vx, sword.vy = o.facing, 0
        sword.r = o.facing==1 and a or - a
      end
    end
  end

  space_register = nil
end

---
local function control_swim(o)
  local o = avatar

  if arrow then
    audio.play "schwupp"
    persistence.vars.occupied = false
    o.noface = false

    pool.setType(arrow, "ARROW")
    arrow.properties.ghost = false
    arrow = false
    arrow_timer = 30
  end

  if up() then       o.vy = o.vy - 0.2
  elseif down() then o.vy = o.vy + 0.2 end

  if left() then      o.vx = o.vx - 0.2
  elseif right() then o.vx = o.vx + 0.2 end

  if up() and
--    (solid(o.x-15, o.y) or solid(o.x+15, o.y)) and
  not water(o.x, o.y-5) then
    o.vy = o.vy - 0.9 --6
  end

  if o.type == persistence.vars.avatar_name then
    local as = {"_WALK", "", "_HOLD"}
    o.type = persistence.vars.avatar_name .. as[math.floor(math.sin(now/.1)*1.5+2.5)]
  end
end

---
local function control_bow (o)
  arrow_timer = arrow_timer - 1
  if arrow then
    local x = math.abs(math.cos(now/.5)) * -o.facing
    local y = math.abs(math.sin(now/.5))
    arrow.x, arrow.y = o.x - x*-2, o.y - y*-3 - 8
    arrow.vx, arrow.vy = -x*12, -y*12

    o.type = o.type .. "_BOW"

    if not pressed.x then
      audio.play "schwupp"
      persistence.vars.occupied = false
      o.noface = false

      pool.setType(arrow, "ARROW")
      arrow.properties.ghost = false
      arrow = false
      arrow_timer = 30
    end

  elseif not persistence.vars.occupied
  and persistence.vars.bow and arrow_timer < 0
  and pressed.x and persistence.vars.arrows > 0 then
    audio.play "hah"

    persistence.vars.occupied = true
    persistence.vars.arrows = persistence.vars.arrows-1
    o.noface = true

    arrow = pool.spawn("SHOOTING", o.x, o.y)
    arrow.properties.ghost = true
    arrow.noturn = true
    arrow.airfriction = 0.99
    arrow.ox = 10
    arrow.oy = 10
    arrow.ix = 10
    arrow.iy = 10
  end
end

---
local function control_move(o)
  if (o.r == nil or o.r == math.huge) and o.ground then
    rolling_timer = rolling_timer + 1
    if down() and rolling_timer > 40 then
      sfx.jump(o.x, o.y-10)

      rolling_timer = 0
      change_level_timer = 60*2

--      o.type = persistence.vars.avatar_name .. "_SHIELD"
      o.r = -math.pi*2 * o.facing
      o.vx = o.facing * 5

      o.friction = .99
      o.airfriction = .99
      local diy, doy = 10-o.iy, 5-o.oy
      o.iy = o.iy + diy
      o.oy = o.oy + doy
      o.y = o.y + diy
      CONTROL = false
      transient.levelclock.add {dur=.25, ended=function()
        CONTROL = true
      end}
      transient.levelclock.add {dur=.3, f=cron.to(o, "r", 0), ended=function()
        o.r = nil
        o.friction = nil
        o.airfriction = nil
        o.iy = o.iy - diy
        o.oy = o.oy - doy
        o.y = o.y - diy - 1
      end}

    -- jump
    elseif up() then
      sfx.jump(o.x, o.y)
      o.vy = -7
    end

-- glide
--  elseif not o.ground then
--    if pressed.up and o.vy > .5 then
--      o.vy = .5
--    end
  end

  if     left()  then o.vx = o.vx - (o.type ~= persistence.vars.avatar_name and 0.1 or 0.5)
  elseif right() then o.vx = o.vx + (o.type ~= persistence.vars.avatar_name and 0.1 or 0.5) end

  if o.type == persistence.vars.avatar_name then
    if left() or right() then
      local as = {"_WALK", "", "_WALK2"}
      o.type = o.type .. as[math.floor(math.sin(now/.1)*1.2+2.5)]
    elseif now % .3 < .15 and now % 3 < .45 then
      o.type = persistence.vars.avatar_name .. "_BLINK"
    end
  end
end

--- control global 'avatar', call secondary control functions
local function control ()
  local o = avatar
  o.type = persistence.vars.avatar_name

  quake_camera_on_low_health(o)
  control_secondary_music(o)

  if CONTROL then
    -- either or
    control_grab(o)
    control_sword(o)

    if o.ladder then
      o.vx = b2n(right()) - b2n(left())
      o.vy = b2n(down())  - b2n(up())
    elseif o.water then
      control_swim(o)
    else
      control_bow(o)
      control_move(o)
    end

    if DEBUG and pressed.r then
      local here = persistence.mapname
      persistence.mapname = nil
      persistence[here] = nil
      scripting.levels[here] = nil
      change_level(here)
      change_level_timer = 60
    end
 end
end

-- also defines sword or others
return control
