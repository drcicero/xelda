
function update_layers()
  for i,layer in ipairs(map.layers) do
    if layer.type == "objectgroup" then
      table.foreach(layer.objects, update_obj)
    end
  end

  table.foreach(state.pool, update_obj)
end

local arrow_hurt = {TRIGGER=1, TRIGGER2=1, EYE=1, BAT1=1, BAT2=1, BAT_SIT=1, FISH=1, FISH2=1, SLIME=1, PIG=1, SKELETON=1, GHOST=1}
local sword_hurt = {TRIGGER=1, TRIGGER2=1, EYE=1, BAT1=1, BAT2=1, BAT_SIT=1, FISH=1, FISH2=1, SLIME=1, PIG=1, SKELETON=1, GHOST=1, GRASS=1, LOCK=1, CHEST=1, LAMPPOST_ON=1}
local player_hurt = {BAT1=1, BAT2=1, BAT_SIT=1, NUT=1, PIG=1, FISH=1, FISH2=1, SLIME=1, ESLIME=1, SKELETON=1}

function hurt_player (o)
  player.health = player.health - 1
  audio.play "hit"
  avatar.vx = (avatar.x < o.x) and -3 or 3
  avatar.vy = -6
  avatar.timer = 40
  avatar.alpha = 0.5*255

  if player.health == 0 then
    load_game()
  end
end

function hurt_enemy (o)
  if o.type == "CHEST" then
    o.got = true
    audio.music()
    audio.play "Triumph"

    local start = now
    local time = 7000 --[[audios.Triumph.duration*1000 CONTAINER BIGKEY BOW LAMP]]
    local tmp

    tmp, love.update = love.update, function ()
      calc_fps()

      change_screensize(h/12/20 + (now-start)/time * (h/6/20 - h/12/20))

      avatar.type = math.sin(now/100)>0 and "RINK_HOLD" or "RINK"

      if now - start > time then
        local item, spec = o.properties.item, nil
        if item:sub(1, 7) == "BIGKEY " then
          item, spec = "BIGKEY", item:sub(8)
        end

        x = add_obj(item, o.x, o.y-tw, 0, -4)
        if spec then
          x.properties.bigkey = spec
        end

        love.update = tmp
        change_screensize()

        remove(o)
      end
    end

  elseif o.type == "EYE" then
    setType(o, "EYE2")
    setVar(o.properties.change, true)

  elseif o.type == "LOCK" then
    if player.keys > 0 then
      player.keys = player.keys - 1
      remove(o)
      setVar(o.properties.change, true)
    end

  elseif o.type == "LOCK" then
    if player.keys > 0 then
      player.keys = player.keys - 1
      remove(o)
      setVar(o.properties.change, true)
    end

  else
    if o.properties.onkill then
      setVar(o.properties.onkill, true)
    end

    audio.play "hit"

    if math.random() > 0.5 then
      add_obj(
        player.health < player.hearts*2 and math.random() > 0.5 and "HEART"
        or player.bow and math.random() > 0.5 and "ARROWS" or "RUBY1",
        o.x, o.y-tw, 0, -4
      )
    end

    remove(o)

  end
end

function table.anykey(l, f)
  for e,_ in pairs(l) do
    if f(e) then return true end
  end return false
end

function update_fish (o)
  -- move
  o.vx = (o.left and 1 or -1) * (o.type == "FISH" and 1.1 or 1.9)

  -- stop on edges or walls
  if solid(o.x + o.vx + (o.vx<0 and -10 or 10), o.y+10)
  or solid(o.x + o.vx + (o.vx<0 and -10 or 10), o.y-10)
  or grid(o, o.vx + (o.vx<0 and -10 or 10), 10)
  or grid(o, o.vx + (o.vx<0 and -10 or 10), 10) then
    o.left = not o.left
  end

  -- special form
  if o.timer < 0 and math.abs(o.x - avatar.x) < 40 then
    setType(o, "FISH2")
    o.timer = 200
  elseif o.timer == 100 then
    setType(o, "FISH")
  end
end

function update_slime (o)
  -- move
  o.vx = o.left and 1 or -1

  -- stop on edges or walls
  if solid(o.x + o.vx + (o.vx<0 and -10 or 10), o.y)
  or grid(o, o.vx + (o.vx<0 and -10 or 10), 0)
  or not solid(o.x + o.vx*tw, o.y + tw/2+2) then
    o.left = not o.left
  end

  -- special form
  if o.timer < 0 and math.abs(o.x - avatar.x) < 40 then
    setType(o, "ESLIME")
    o.timer = 200
  elseif o.timer == 100 then
    setType(o, "SLIME")
  end
end

function show_text (o)
  if pl_col(o.x, o.y, tw/2) then
    local text = o.properties.text
    local lines = 1
    text:gsub("\n", function () lines=lines+1 end)
    table.insert(bubbles, {x=o.x, y=o.y, text=o.properties.text, lines=lines})
  end
end

local updates = {
  HOLE = function (o)
    local theblock

    local function match(b)
      theblock = b
      return not b.to_be_removed and not b.disabled
        and player.grab ~= b and b.x-tw/2 < o.x
        and o.x < b.x+tw/2 and b.y-tw/2 < o.y and o.y < b.y+tw/2
    end

    if table.anykey(types.YELLOW, match)
    or table.anykey(types.CYAN, match)
    or table.anykey(types.MAGENTA, match) then
      theblock.x = o.x
      theblock.y = o.y - 6
      theblock.vx = 0
      theblock.vy = 0
      setVar(o.properties[theblock.type], true)

      if o.properties.CYAN    and theblock.type ~= "CYAN"    then setVar(o.properties.CYAN, false)    end
      if o.properties.MAGENTA and theblock.type ~= "MAGENTA" then setVar(o.properties.MAGENTA, false) end
      if o.properties.YELLOW  and theblock.type ~= "YELLOW"  then setVar(o.properties.YELLOW, false)  end

    else
      if o.properties.CYAN    then setVar(o.properties.CYAN, false)    end
      if o.properties.MAGENTA then setVar(o.properties.MAGENTA, false) end
      if o.properties.YELLOW  then setVar(o.properties.YELLOW, false)  end
    end
  end,

  BIG_LOCK = function (o)
    local theblock

    local function match(b)
      theblock = b
      return not b.to_be_removed and not b.disabled
        and player.grab ~= b and b.x-tw/2 < o.x
        and o.x < b.x+tw/2 and b.y-tw/2 < o.y and o.y < b.y+tw/2
    end

    -- the correct bigkey
    if table.anykey(types.BIGKEY, match) and theblock.properties.bigkey == o.properties.bigkey then
      remove(theblock)
      setVar(o.properties.change, true)
      setType(o, "BIG_LOCK_OPEN")

    else
      setVar(o.properties.change, false)
    end
  end,

  TABLET = show_text, SHIELD = show_text,

  META = function (o)
    if box_col(avatar, o, tw,tw, o.width, o.height) then
      if o.properties.onfirsttouch then
        setVar(o.properties.onfirsttouch, true)
        o.properties.onfirsttouch = nil
      end

      if o.properties.TO then
        if pressed[" "] and change_level_timer < 0 then
          quit = function ()
            if player.grab and player.grab.type == "BIGKEY" then
              for i,p in ipairs(pool) do
                if p == player.grab then
                  remove(p)
                  pool[i] = {to_be_removed=true, properties={}}
                  remove(p, false)
                  break
                end
              end

            else
              player.grab = false
            end

            local from = map.name
            if not o.properties.TO then error("Nowhere to go.") end

            change_level(o.properties.TO)

            if player.grab then
              pool[#pool+1] = player.grab
              player.grab.x = avatar.x
              player.grab.y = avatar.y
            end

            local found = false
            for meta,_ in pairs(types.META) do
              if meta.properties.TO == from then
                avatar.x = meta.x + meta.width/2
                avatar.y = meta.y
                found = true
                break
              end
            end
            if not found then error("No Door in " .. o.properties.TO .. " to " .. from) end
            camera.x = clamp(cam_min_x, avatar.x, cam_max_x)
            camera.y = clamp(cam_min_y, avatar.y, cam_max_y)

            save_game()
          end
          change_level_timer = 100
        end

      elseif map.name == "mainmenu" then
        if pressed[" "] and change_level_timer < 0 then
          local n = o.name

          if n == "NEWGAME" then
            states = {}
            quit = function ()
              change_level "ice_entry"
              avatar.x = 490
              avatar.y = 150
--              change_level "ice_time"
--              avatar.x = 490
--              avatar.y = 100
            end

          elseif n == "LOAD" then
            load_game()
          end

          change_level_timer = 100
        end
      end
    end
  end,

  SLIME = update_slime, ESLIME = update_slime,
  FISH = update_fish, FISH2 = update_fish,

  HEART = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      audio.play "gluck"
      player.health = player.health + 1
      remove(o)
    end
  end,

  ARROWS = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      audio.play "gluck"
      player.arrows = player.arrows + 3
      remove(o)
    end
  end,

  KEY = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      audio.play "gluck"
      player.keys = player.keys + 1
      remove(o)
    end
  end,

  BOW = function (o)
    if pl_col(o.x, o.y-tw/2, tw/4) then
      audio.play "gluck"
      player.bow = true
      player.arrows = 15
      remove(o)
    end
  end,

  ARROW = function (o)
    o.r = -math.pi/2 - math.atan2(o.vx, o.vy)
    if math.abs(o.vx) + math.abs(o.vy) < 0.1 then
      if o.timer > 1 then
        o.alpha = 255*o.timer/40
      elseif o.timer == 1 then
        remove(o)
      else
        o.timer = 40
      end
    else
      o.timer = -1
      o.alpha = 255
    end
  end
}

function update_obj (i, o)
  objs = objs+1

  if o.properties.switch then
    o.disabled = getVar(o.properties.switch)
  end

  if not o.to_be_removed and not o.disabled then
    if o.type ~= "META" then
      o.timer = o.timer-1
      if o.type ~= "GRID" and o.type ~= "EYE" and o.type ~= "EYE2" then move_obj(o) end
    end

    local update = updates[o.type]
    if update then update(o) end

    if o.type ~= "META" then
      if arrow_hurt[o.type] then
        for _,p in ipairs(state.pool) do
          if not p.to_be_removed and p.type == "ARROW"
          and p.timer <= 0 and collision(o.x,o.y-tw/2, p.x,p.y-tw/2, tw/2,tw/2) then
            hurt_enemy(o)
          end
        end
      end

      if avatar.type == "RINK_ATTACK"
      and sword_hurt[o.type]
      and collision(avatar.x + map.attr[avatar].facing*10, avatar.y-tw/2, o.x, o.y-tw/2, tw/4, tw/2) then
        hurt_enemy(o)
      end

      if avatar.timer < 0 and avatar.type ~= "RINK_SHIELD"
      and player_hurt[o.type]
      and pl_col(o.x, o.y-tw/2, tw/2) then
        hurt_player(o)
      end

      if o.type:sub(1, 4) == "RUBY" and pl_col(o.x, o.y-tw/2, tw/4) then
        audio.play "ding"
        player.rubies = player.rubies + tonumber(o.type:sub(5))
        remove(o)

      elseif not player.grab and pressed.c
      and ({CYAN=1, YELLOW=1, MAGENTA=1, BIGKEY=1})[o.type]
      and pl_col(o.x, o.y-tw/2, tw/4) then
        player.grab = o
      end
    end
  end
end

function count (tab)
  local i = 0
  for _,_ in pairs(tab) do i=i+1 end
  return i
end

function find (arr, o)
  for i,o in ipairs(arr) do if o==o then return i end end
end

function move_obj (o)
  map.attr[o].water = water(o.x, o.y+tw/2+2)
  if map.attr[o].water then
    o.vx = 0.9*o.vx
    o.vy = 0.9*o.vy
  end

  local w = "ARROW" == o.type and 2 or tw/2
  if o.vx < 0 then map.attr[o].facing = -1 else map.attr[o].facing = 1 end

  map.attr[o].wall = false
  if o.vx ~= 0 then
    if solid(o.x + o.vx + map.attr[o].facing*w, o.y) or grid(o, o.vx, 0) then
      o.vx = 0
      map.attr[o].wall = true
    end
  end

  map.attr[o].ground = o.vy >= 0 and (
    solid(o.x, o.y+o.vy+1) or
    grid(o, 0, o.vy+1) or
    (not o.type=="BLOCK" and grid(o, 0, 0) and block(o.x, o.y+o.vy+1))
  )

  if not map.attr[o].water then
    if map.attr[o].ground then
      o.vx = o.vx * 0.8

    else
      o.vx = o.vx * ("ARROW" == o.type and 0.99 or 0.8)
      o.vy = o.vy + 0.5
    end
  end

  if map.attr[o].ground or (o.vy < 0
  and (solid(o.x, o.y+o.vy-w*2+1) or grid(o, 0, o.vy+1))) then
    o.vy = 0
  end

  o.x = o.x+o.vx
  o.y = o.y+o.vy
end

local arrow = false
local fullscreentimer, debugtimer, hittimer, bowtimer = 0, 0, 0, 0
function control ()
  local o = avatar

  camera.x = camera.x + (clamp(cam_min_x, o.x, cam_max_x, true) - camera.x) / 6
  camera.y = camera.y + (clamp(cam_min_y, o.y, cam_max_y, true) - camera.y) / 12

  if pressed.escape then love.event.quit() end

  if o.timer > 0 then o.alpha = (40-o.timer)/40*255 end

  fullscreentimer = fullscreentimer-1
  debugtimer = debugtimer-1
  if pressed.lalt and pressed["return"] then
    if fullscreentimer < 0 then
      local fs = love.window.getFullscreen()
      love.window.setFullscreen(not fs, "desktop")

      change_screensize()
      fullscreentimer = 10
    end

  elseif debugtimer < 0 and pressed["return"] then
    DEBUG = not DEBUG
    debugtimer = 10
  end

  if not pressed.c then player.grab = false end
  if player.grab then
    player.grab.x = o.x + map.attr[o].facing * 5
    player.grab.y = o.y
    player.grab.vx = avatar.vx
    player.grab.vy = avatar.vy

--    if pressed.x then
--      arrow = player.grab
--      player.grab = false
--    end
  end

  o.type = hittimer > 10 and "RINK_ATTACK" or "RINK"
  hittimer = hittimer-1
  if hittimer < 0 and pressed[" "] then
    local as = {"hah", "hah2", "hah3"}
    audio.play(as[floor(math.random()*2)+1])
    hittimer = 20
  end

  if map.attr[o].water then
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

    if o.type == "RINK" then
      local as = {"RINK_WALK", "RINK", "RINK_HOLD"}
      o.type = as[floor(math.sin(now/100)*1.5+2.5)]
    end

    arrow = false

  else
    if audio._music ~= (landmusic or "Fight") then
      audio.play "schwupp"
      audio.music(landmusic or "Fight")
    end

    o.type = (
      hittimer > 10 and "RINK_ATTACK" or
      (not arrow and bowtimer <= 15) and "RINK" or
      "RINK_BOW"
    )

    if     pressed.down            then o.type = "RINK_SHIELD"
    elseif map.attr[o].ground and pressed.up then o.vy = -7              end

    bowtimer = bowtimer - 1
    if arrow then
      local x = avatar.x - math.abs(math.cos(now/500))*15 * (avatar.vx<0 and 1 or -1)
      local y = avatar.y - math.abs(math.sin(now/500))*15
      arrow.x, arrow.y = x, y
      arrow.vx, arrow.vy = (x-o.x)/1.5, (y-o.y)/1.5

      if not pressed.x then
        audio.play "schwupp"
        arrow = false
        bowtimer = 30
      end

    elseif player.bow and bowtimer < 0 and pressed.x then
      if player.arrows > 0 then
        player.arrows = player.arrows-1

        local x = avatar.x - math.abs(math.cos(now/500))*15 * (avatar.vx<0 and 1 or -1)
        local y = avatar.y - math.abs(math.sin(now/500))*15

        arrow = add_obj("ARROW", x, y)
      end
    end

    if pressed.left then      o.vx = o.vx - (o.type ~= "RINK" and 0.1 or 0.5)
    elseif pressed.right then o.vx = o.vx + (o.type ~= "RINK" and 0.1 or 0.5) end

    if o.type == "RINK" and (pressed.left or pressed.right) then
      o.type = math.sin(now/100) < 0 and "RINK" or "RINK_WALK"
    end
  end
end

