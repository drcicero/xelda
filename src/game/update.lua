--- Game.update
-- requires $frames, $audio

local app = require "frames"
local audio = require "audio"
local cron = require "cron"

local sfx = require "sfx"
local saveload = require "saveload"

local maps = require "map.maps"
local objs = require "map.objs"
local camera = require "map.camera"

require "switchs"
require "game.collision"
require "game.control"


---
local touchclass = {
  -- shotable enemies
  [{EYE=1, BAT1=1, BAT2=1, BAT_SIT=1,
    FISH=1, FISH2=1, SLIME=1, ESLIME=1,
    WOLF=1, WOLF_HOWL=1, WOLF_DUCK_1=1, WOLF_DUCK_2=1, WOLF_RUN=1, WOLF_JUMP=1,
    PIG=1, SKELETON=1, GHOST=1}] = function (o)
    for p,_ in pairs(transient.types.ARROW) do
      if p.timer <= 0
      and circ_col(
        o.x, o.y-tw/2,
        p.x-math.cos(p.r)*10, p.y-math.sin(p.r)*10,
        tw/2, tw/4
      ) then
        objs.del(p)
        hurt_enemy(o)
        return
      end
    end
  end,

  -- sliceable enemies
  [{EYE=1, BAT1=1, BAT2=1, BAT_SIT=1,
    FISH=1, FISH2=1, SLIME=1, ESLIME=1,
    WOLF=1, WOLF_HOWL=1, WOLF_DUCK_1=1, WOLF_DUCK_2=1, WOLF_RUN=1, WOLF_JUMP=1,
    PIG=1, SKELETON=1, GHOST=1,
    GRASS=1, LAMPPOST_ON=1}] = function (o)
    if sword and circ_col(
      sword.x + math.cos(avatar.facing>0 and sword.r or math.pi+sword.r)*14,
      sword.y + math.sin(avatar.facing>0 and sword.r or math.pi+sword.r)*14,
      o.x, o.y-tw/2, tw/4, tw/2
    ) then
      if sword.timer == 1 or sword.timer == 2 then
        unsword()
      end
      hurt_enemy(o)
      return
    end
  end,

  -- hurting enemies
  [{BAT1=1, BAT2=1, BAT_SIT=1,
    WOLF=1, WOLF_HOWL=1, WOLF_DUCK_1=1, WOLF_DUCK_2=1, WOLF_RUN=1,
    NUT=1, PIG=1, FISH=1, FISH2=1, SKELETON=1}] = function (o)
    if pl_col(o.x, o.y-tw/2, tw/2) then
      hurt_player(o)
    end
  end,

  -- hurting enemies
  [{ELECTRO=1, NUT=1,
    WOLF=1, WOLF_DUCK_1=1, WOLF_DUCK_2=1, WOLF_JUMP=1, WOLF_RUN=1,}] = function (o)
    if pl_col(o.x, o.y, tw/2) then
      hurt_player(o)
    end
  end,
}

---
function hurt_player (o)
  if avatar.type ~= persistence.vars.avatar_name .. "_SHIELD"
  and avatar.timer < 0 then
    avatar.timer = 60

    sfx.hurtplayer(o.x, o.y)

    local health = persistence.vars.health - 1
    persistence.vars.health = health
    avatar.vx = (avatar.x < o.x) and -3 or 3
    avatar.vy = -6
    avatar.alpha = 0.5*255

    if health == 2 then
      audio.setPitch(1.1, "default")

    elseif health == 1 then
      audio.setPitch(1.2, "default")

    elseif health == 0 then
      local start = now
      local originalmvol = audio.mvol
      local loaded = false

      app.push {
        update = function () return loaded end,
        draw = function ()
          local x = now - start

          if x >= 2 then
            x = 0
            audio.setMVol(originalmvol)
            app.pop()
            return

          elseif x >= 1 then
            if not loaded then
              loaded = true
              saveload.autoload()
            end
            x = 2 - x
          end

          audio.setMVol((1-x) * originalmvol)
          love.graphics.setColor(0,0,0, 255 * x)
          love.graphics.rectangle("fill", 0,0,w,h)
        end,
      }
    end
  end
end

---
function hurt_enemy (o)
  if o.type == "EYE" then
    if o.properties.multi then
      objs.setType(o, "EYE")
      objs.timer = 0
      emit(o, "change", objs.r == 0)

    else
      sfx.killenemy(o.x, o.y-10)

      objs.setType(o, "EYE2")
      o.properties.closed = true
      emit(o, "change", true)
   end

  elseif (o.type == "WOLF"
  or o.type == "WOLF_DUCK_1"
  or o.type == "WOLF_DUCK_2"
  or o.type == "WOLF_HOWL"
  or o.type == "WOLF_RUN"
  or o.type == "WOLF_JUMP")
  and o.properties.health ~= 0 then
    if o.alpha == 255 then
      sfx.hurtenemy(o.x, o.y-10)

      o.alpha = 0; transient.levelclock.add {dur=.5, f=cron.to(o, "alpha", 255)}
      objs.setType(o, "WOLF_JUMP")
      o.vx = avatar.facing * 5
      o.vy = -6
      o.properties.health = o.properties.health and o.properties.health - 1 or 2
      o.properties.hurt = true
    end

  elseif o.type == "GRASS" then
    sfx.grasscut(o.x, o.y-10)
    o.type = "CUT_GRASS"

    if math.random() > 0.5 then
      local x = objs.spawn(
        persistence.vars.health < persistence.vars.hearts*2 and math.random() > 0.5 and "HEART"
        or persistence.vars.bow and math.random() > 0.5 and "ARROWS" or "RUBY1",
        o.x, o.y-tw
      )
      x.vx = 0
      x.vy = -4
    end

  else
    if o.properties.onkill then
      emit(o, "onkill", true)
    end

    if not o.anormalkill then
      sfx.killenemy(o.x, o.y-10)

      if math.random() > 0.5 then
        local x = objs.spawn(
          persistence.vars.health < persistence.vars.hearts*2 and math.random() > 0.5 and "HEART"
          or persistence.vars.bow and math.random() > 0.5 and "ARROWS" or "RUBY1",
          o.x, o.y-tw
        )
        x.vx = 0
        x.vy = -4
      end

      objs.del(o)
    end

  end
end

---
function table.anykey(l, f)
  for e,_ in pairs(l) do
    if f(e) then return true end
  end return false
end

local function update_fish (o)

  if o.wall then
    o.facing = - o.facing
  end

  o.vx = o.facing * (o.type == "FISH" and 1.1 or 1.9)
  o.gravity = 0

  -- special form
  if o.timer < 0 and math.abs(o.x - avatar.x) < 40 then
    sfx.enemyboost(o.x, o.y-10)
    objs.setType(o, "FISH2")
    o.timer = 200

  elseif o.timer == 100 then
    objs.setType(o, "FISH")
  end
end

local function update_wolf (o)
  local dist, dir
  dist = avatar.x - o.x
  dir = dist > 0 and 1 or -1
  dist = dir * dist

  if o.type == "WOLF_JUMP" then
    o.r = .1 * o.vy * o.facing
    if o.ground then
      o.type = "WOLF"
      o.r = nil
      if not o.properties.hurt then
        sfx.enemyboost(o.x, o.y-10)
        o.timer = 0
      end

      o.properties.hurt = nil
      o.properties.target = 60 + math.random() * 180
    end

  else
    o.type = now % .5 < .25 and "WOLF" or "WOLF_RUN"
    if o.timer > -60 then
      o.type = "WOLF_HOWL"
--      o.vx = -dir * 3

    elseif pressed["x"] and now%2 ~= 0 then
--      o.vx = math.sin(now % math.pi*2)
--      o.properties.await = true
      o.vx =  dir * 2.5

    elseif (dist < 40
    or dist < 60 and pressed[" "]
    or (dist > 100 and o.facing==dir and o.wall)
    or (dist > 60 and dist < 100 and not pressed[" "] and o.properties.target and o.properties.target<=0)
    or o.properties.await)
    and o.ground then
      sfx.enemyboost(o.x, o.y-10)
      o.type = "WOLF_JUMP"
      o.properties.hurt = not (dist > 60 and dist < 100 and not pressed[" "] and o.properties.target and o.properties.target <= 0)
      o.x = o.x - 2 * o.facing
      o.vx = o.properties.await and (math.random()<.5 and -4 or 4) or dir * dist/15
      o.vy = o.properties.await and math.random() * -2 -4 or -6
      o.airfriction = .95
      o.properties.await = nil

    elseif dist < 80 then
      o.vx = -dir * 1.5

    elseif dist < 100 then
      o.type = now % 1 < .5 and "WOLF_DUCK_1" or "WOLF_DUCK_2"
      o.properties.target = o.properties.target and o.properties.target - 1 or 120

    elseif dist > 100 then
      o.vx =  dir * 2.5
    end
  end
end

local function update_slime (o)
  -- stop on edges or walls
  if o.wall
--  or solid(o.x + o.vx + o.facing * 10, o.y)
--  or grid(o, o.vx + o.facing * 10, 0)
  or not solid(o.x + o.vx*tw, o.y + tw/2 + 2) then
    o.facing = -o.facing
  end

  o.vx = o.facing

  if o.timer < 0 then
    if pl_col(o.x, o.y, 70) then
      sfx.enemyboost(o.x, o.y-10)
      objs.setType(o, "ESLIME")
      o.timer = 300
    end

  elseif 100 < o.timer and o.timer % 20 == 0 then
    local ele = objs.spawn("ELECTRO", o.x + math.random()*10-5, o.y - 15 + math.random()*10-5)
    audio.play("electro", ele.x, ele.y)
    ele.properties.ax = o.vx + math.random()*2-1
    ele.properties.ay = math.random()*2-1
    ele.gravity = 0
    ele.airfriction = 1
    ele.ix = 10  ele.iy = 10
    ele.ox = 10  ele.oy = 10

  elseif o.timer == 100 then
    objs.setType(o, "SLIME")
  end
end

local function show_text (o)
  if topisgame and pl_col(o.x, o.y-o.oy, tw/2) then
    table.insert(bubbles, {x=o.x, y=o.y, text=o.properties.text})
  end
end

local function update_trigger (o)
  if pl_col(o.x, o.y-tw/2, tw/2) then
    table.insert(bubbles, {x=o.x, y=o.y, text="[space] : toggle switch"})
    if pressed[" "] and o.timer < 0 then
      o.timer = 50
      sfx.killenemy(o.x, o.y-10)
      emit(o, "change", o.type == "TRIGGER")
      objs.setType(o, o.type=="TRIGGER" and "TRIGGER2" or "TRIGGER")
    end
  end
end

local function update_chest (o)
  if pl_col(o.x, o.y-tw/2, tw/2) then
    table.insert(bubbles, {x=o.x, y=o.y, text="[space] : open chest"})
    if not o.properties.got and pressed[" "] and o.timer < 0 then
      unsword()
      o.properties.got = true

      local mus = audio.channels.default.name
      audio.music(nil, "default")
      sfx.openchest(o.x, o.y-10)

      local x, y = o.x, o.y
      local i = objs.spawn(o.properties.item, o.x, o.y-tw)
      i.gravity = 0
      i.dont_update = true
      objs.del(o)

      local start, dur = now, 4
      app.push({
        update = function ()
          local t = (now - start) / dur

          avatar.type = persistence.vars.avatar_name ..
            (now%2>1 and "_HOLD" or "")

          local tt = 2*t-1
          local ttt = 1 - tt*tt
          i.x = x + 10*ttt * math.cos(t * 3 * 2*math.pi)
          i.y = y + 10*ttt * math.sin(t * 3 * 2*math.pi) - t*15

          if now - start > dur then
            audio.music(mus, "default")
            i.gravity = nil
            i.dont_update = nil
            app.pop()
          end
        end
      })
    end
  end
end

local function update_arrow (o)
  o.r = -math.pi/2 - math.atan2(o.vx, o.vy)
  if math.abs(o.vx) + math.abs(o.vy) < 0.1 then
    if o.timer > 1 then
      o.alpha = 255*o.timer/40
    elseif o.timer == 1 then
      objs.del(o)
    else
      o.timer = 40
    end

  elseif timer == -1 then
    o.timer = 0

  else
    o.timer = -1
    o.alpha = 255
  end
end

local function change_health (delta)
  persistence.vars.health = persistence.vars.health + delta
  if persistence.vars.health == 2 then
    audio.setPitch(1.1, "default")
  elseif persistence.vars.health == 1 then
    audio.setPitch(1.2, "default")
  else
    audio.setPitch(1, "default")
  end
end

local updates = {
  PUFF = function (o)
    -- o.alpha = 255 * (o.timer-o.properties.dur)/o.properties.dur
    local s, e, d = o.properties.zstart, o.properties.zend, o.properties.dur
    local q = 2 * (-o.timer/d) - 1
    o.z = s + e * (1 - q*q)
--    o.z = o.properties.zstart + o.properties.zend * -o.timer/d
    o.vy = o.vy + (o.gravity or 0.05)
    if -o.timer >= d then
      objs.del(o)
    end
  end,

  GRASS = function (o)
    local t = o.x + 2*o.y + now
    o.r = math.sin(t*5)/25+math.sin(t*2)/20
  end,

  HOLE = function (o)
    local theblock

    local function match(b)
      theblock = b
      return not b.disabled
        and persistence.vars.grab ~= b and b.x-tw/2 < o.x
        and o.x < b.x+tw/2 and b.y-tw/2 < o.y and o.y < b.y+tw/2
    end

    if table.anykey(transient.types.YELLOW, match)
    or table.anykey(transient.types.CYAN, match)
    or table.anykey(transient.types.MAGENTA, match) then
      theblock.x = o.x
      theblock.y = o.y - 6
      theblock.vx = 0
      theblock.vy = 0
      emit(o, theblock.type, true)

      if theblock.type ~= "CYAN"    then emit(o, "CYAN", false)    end
      if theblock.type ~= "MAGENTA" then emit(o, "MAGENTA", false) end
      if theblock.type ~= "YELLOW"  then emit(o, "YELLOW", false)  end

    else
      emit(o, "CYAN", false)
      emit(o, "MAGENTA", false)
      emit(o, "YELLOW", false)
    end

  end,

  BIG_LOCK = function (o)
    local function match(b)
      if not b.disabled
      and persistence.vars.grab ~= b and b.x-tw/2 < o.x
      and o.x < b.x+tw/2 and b.y-tw/2 < o.y and o.y < b.y+tw/2 then
        sfx.unlock(o.x, o.y-10)
        objs.del(b)
        emit(o, "change", true)
        objs.setType(o, "BIG_LOCK_OPEN")
        return true
      end
    end

    -- the correct bigkey
    if not table.anykey(transient.types.BIGKEY, match) then
      emit(o, "change", false)
    end
  end,

  LOCK = function (o)
    if pl_col(o.x, o.y, tw/2) then
      if persistence.vars.keys > 0 then
        table.insert(bubbles, {
          x = o.x, y = o.y,
          text = "[space] : use key",
        })

        if pressed[" "] then
          sfx.unlock(o.x, o.y-10)
          persistence.vars.keys = persistence.vars.keys - 1
          emit(o, "change", true)
          objs.del(o)
        end

      else
        table.insert(bubbles, {
          x = o.x, y = o.y,
          text = "Find a key for this lock!",
        })
      end
    end
  end,

  EYE = function (o)
    if o.timer % 100 == 0 then
      o.type = "EYE2"
      audio.play("schwupp", o.x, o.y)
    end

    if o.timer > 0 and o.r == 0 then
      o.r = o.r / 100
    end
  end,

  EYE2 = function (o)
    if not o.properties.closed then
      if o.timer % 10 == 0 then
        o.type = "EYE"
      end
    end
  end,

  TABLET = show_text, SHIELD = show_text,

  TRIGGER = update_trigger, TRIGGER2 = update_trigger,
  CHEST = update_chest,

  META = function (o)
    if topisgame
    and box_col(avatar, o, tw,tw, o.width, o.height) then
      if o.properties.onfirsttouch then
        emit(o, "onfirsttouch", true)
        o.properties.onfirsttouch = nil
      end
      if o.properties.ontouch then
        emit(o, "ontouch", true)
      end

      if o.properties.TO then
        table.insert(bubbles, {
          x = o.x+o.width/2,
          y = o.y+o.height,
          text = "[space] : use door",
          alpha = change_level_timer < 0 and 255 or 100
        })

        if pressed[" "] and change_level_timer < 0 then
          quit = function ()
            unsword()

            if persistence.vars.grab
            and persistence.vars.grab.type == "BIGKEY" then
              objs.del(persistence.vars.grab)
            else
              persistence.vars.grab = false
            end

            maps.use_door_to(o.properties.TO)
            change_level_timer = 60

            if persistence.vars.grab then
              persistence.vars.grab =
                objs.spawn("BIGKEY", avatar.x, avatar.y)
            end

            saveload.autosave()
          end
        end
      end
    end
  end,

  SLIME = update_slime, ESLIME = update_slime,
  FISH = update_fish, FISH2 = update_fish,
  WOLF=update_wolf, WOLF_HOWL=update_wolf, WOLF_JUMP=update_wolf,
  WOLF_DUCK_1=update_wolf, WOLF_DUCK_2=update_wolf, WOLF_RUN=update_wolf,

  HEART = function (o)
    if  persistence.vars.health < persistence.vars.hearts*2
    and pl_col(o.x, o.y-tw/2, tw/4) then
      sfx.getheart(o.x, o.y-10)
      move_to_inventory(o, 15*persistence.vars.health+20+10, 10+20+10, function ()
        change_health(1)
        objs.del(o)
      end)
    end
  end,

  CONTAINER = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      sfx.getheart(o.x, o.y-10)
      move_to_inventory(o, 15*persistence.vars.health+20+10, 10+20+10, function ()
        persistence.vars.hearts = persistence.vars.hearts + 1
        if persistence.vars.health < persistence.vars.hearts*2 then
          change_health(1)
        end
        objs.del(o)
      end)
    end
  end,

  ARROWS = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      sfx.getheart(o.x, o.y-10)
      move_to_inventory(o, 109+tw+10, 50+2+tw+10, function ()
        persistence.vars.arrows = persistence.vars.arrows + 3
      end)
    end
  end,

  KEY = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      sfx.getkey(o.x, o.y-10)
      move_to_inventory(o, 61+10, 50+2+10, function ()
        persistence.vars.keys = persistence.vars.keys + 1
      end)
    end
  end,

  BOW = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      sfx.getheart(o.x, o.y-10)
      persistence.vars.bow = true
      persistence.vars.arrows = 15
      objs.del(o)
    end
  end,

  SHOOTING = update_arrow, ARROW = update_arrow,

  ELECTRO = function (o)
    o.r = o.timer%5 == 0 and math.random()*math.pi*2 or o.r
    if not o.properties.barknobite then
      o.alpha = 255 * (1 + o.timer / 50)
  --    o.vx, o.vy = o.properties.ax, o.properties.ay
      if o.timer == -40 then
        objs.del(o)
      end
    end
  end,
}

---
function update_obj (i, o)
  if o.type == "REMOVED" then return end

  if o.properties.switch then
    local d = getVar(o.properties.switch)
    if o.disabled ~= d then
      sfx.abled(o.x, o.y-10)
      o.disabled = d
    end
  end

  if o.disabled then return end

  if o.type == "META" then
    updates.META(o)
    return
  end

--  pprint {persistence[persistence.mapname]}
  o.timer = o.timer-1

  if o.type ~= "GRID"
  and o.type ~= "EYE"
  and o.type ~= "EYE2" then
    move_obj(o)
  end

  for t, f in pairs(touchclass) do
    if t[o.type] then f(o) end
  end

  if o.type:sub(1, 4) == "RUBY"
  and not o.dont_update
  and pl_col(o.x, o.y-tw/2, tw/4) then
    local value = tonumber(o.type:sub(5))
    sfx.getruby(o.x, o.y-10)
    move_to_inventory(o, 14+10, 50-2+10, function ()
      for i = 1, value do
        hudclock.add {dur=i/15, ended=function ()
          audio.play "ding"
          persistence.vars.rubies = persistence.vars.rubies + 1
        end}
      end
    end)

  elseif not persistence.vars.grab
  and ({CYAN=1, YELLOW=1, MAGENTA=1, BIGKEY=1})[o.type]
  and pl_col(o.x, o.y-tw/2, tw/4) then
    table.insert(bubbles, {x=o.x, y=o.y, text="[c] : carry"})
    if not persistence.vars.occupied and pressed.c then
      persistence.vars.occupied = true
      persistence.vars.grab = o
    end
  end

  if not o.dont_update then
    local update = updates[o.type]
    if update then update(o) end
  end
end

---
-- got item animation:
-- remove an obj from stage and put it on the hud.
function move_to_inventory(o, x, y, endfunc)
  local newo = {
    type = o.type,
    x = o.x - camera.x + camera.w/2,
    y = o.y - camera.y + camera.h/2,
    ix = 10, iy = 10,
  }
  objs.del(o)

  local i = table.insert(hud_objs, newo)

  local dx, dy =
    cron.to(newo, "x", (math.max(0, w/2-400) + x)/camera.zoom),
    cron.to(newo, "y", (math.max(0, h/2-200) + y)/camera.zoom)

  hudclock.add {dur=.3, ease=cron.ease.Swing, f=function (t)
    dx(t) dy(t)
  end, ended=function ()
    table.remove(hud_objs, i)
    endfunc()
  end}
end

--function find (arr, o)
--  for i,o in ipairs(arr) do if o==o then return i end end
--end

---
function move_obj (o)
  if o.type == "REMOVED" then error("wtf") end
  local w = "ARROW" == o.type and 2 or tw/2

  if not o.noturn and not o.noface then
    if     o.vx < -.1 then o.facing = -1
    elseif o.vx >  .1 then o.facing =  1 end
  end

  local floor = math.floor
  local function tileOf (x) return floor(x / tw) end

  if o.ghost or o.properties.ghost then
    o.x = o.x + o.vx
    o.y = o.y + o.vy

  else
--  o.wall = false
--  if not o.ghost and not o.properties.ghost then
--    if o.vx ~= 0 then
--      if solid(o.x + o.vx + o.facing*w, o.y)
--      or grid(o, o.vx, 0) then
--        o.vx = 0
--        o.wall = true

--      else
--        if o.ground and math.abs(o.vx) > 0.1
--        and (o.type:find("RINK")~=nil or o.type:find("XELDA")~=nil
--        or o.type:find("SLIME")~=nil  or o.type:find("FISH")~=nil) then
--          o.properties.schwupptimer = (o.properties.schwupptimer or 0)-math.random()
--          if o.properties.schwupptimer < 0 then
--            audio.play("hah3", o.x, o.y, 0.9)
--            o.properties.schwupptimer = 10
--          end
--        end
--      end
--    end

--    o.ground = o.vy >= 0 and (
--      solid(o.x, o.y+o.vy+1) or
--      (not grid(o, 0, 0) and grid(o, 0, o.vy+1)) or
--      (not o.type=="BLOCK" and grid(o, 0, 0) and block(o.x, o.y+o.vy+1))
--    )

    if o.y == nil then pprint {o} end -- TODO find error after ice_boss
    o.water = water(o.x, o.y+tw/2+2)
    o.wall = false
    o.ground = false

    o.vy = o.vy + (o.gravity or .5) / (o.water and 15 or 1)

--    if o.ground or (o.vy < 0
--    and (solid(o.x, o.y+o.vy-w*2+1) or grid(o, 0, o.vy+1))) then
--      if o.vy > 2 then audio.play("hit", o.x, o.y-200) end
--      o.vy = 0
--    end
--  end


    -- horizontal
    if o.vx ~= 0 then
      local vx, y = o.vx, o.y
      local right = vx > 0 and 1 or 0
      local front = o.x - o.ox + right * o.width

      -- is the area of tiles, we want to enter, nonsolid
      if unsolid_area (
        right + tileOf(front + (1-right) * vx), -- x_from
        right + tileOf(front + right * vx), -- x_to
        tileOf(y - o.oy - 1), -- y_from
        tileOf(y - o.oy - 1 + o.height) + 1 -- y_to
      ) and not grid(o, vx, 0) then
        o.x = o.x + vx

      else
        o.wall = true
        o.vx = 0

        if math.abs(vx) > 2.5 then
          sfx.hitground(o.x, o.y-o.height+o.oy, math.abs(vx) > 11 and 2 or 1)
        end
      end
    end

    -- vertical
    if o.vy ~= 0 then
      local vy, x = o.vy, o.x
      local up = vy > 0 and 1 or 0
      local front = o.y - o.oy + up * o.height - 1

      -- is the area of tiles, we want to enter, nonsolid
      if unsolid_area (
        tileOf(x - o.ox), -- x_from
        tileOf(x - o.ox + o.width) + 1, -- x_to
        up + tileOf(front + (1-up) * vy), -- y_from
        up + tileOf(front + up * vy) -- y_to
      ) and not grid(o, 0, vy) then
        o.y = o.y + vy

      else
        o.vy = 0

        if vy > 0 then
--          o.y = ?
          o.ground = true
        end

        if math.abs(vy) > 2.5 then
          sfx.hitground(o.x, o.y-o.height+o.oy, math.abs(vy) > 11 and 2 or 1)
        end

      end
    end

    if o.water then
      o.vx = .9 * o.vx
      o.vy = .9 * o.vy

    else
      if o.ground then
        o.vx = o.vx * (o.friction or .8)

      else
        o.vx = o.vx * (o.airfriction or .8)

      end
    end
  end
end
