local time

function byId (id, pool)
  pool = pool or persistence[transient.name].pool
  for i,o in ipairs(pool) do
    if o.name == id then
      return o
    end
  end

  error("no elem by id: " .. id)
end


local bossimg = love.graphics.newImage("assets/boss.png")

level = {
  ice_puzzle_normal = {
    load = function ()
      local yel = byId("yel")
      local cyan = byId("cyan")
      yel.x = 4*20
      yel.y = 13*20
      cyan.x = 12*20
      cyan.y = 12*20
    end,
    unload = function () end,
    draw = function () end,
    update = function () end,
  },


  ice_boss = {
    load = function ()
      audio.music(nil, "default")
      persistence.vars.bow = true
      if not persistence.vars.arrows or persistence.vars.arrows < 15 then persistence.vars.arrows = 15 end

      if not persistence[transient.name].initialized then
        persistence[transient.name].initialized = true

        persistence[transient.name].water_y_end = false
        persistence[transient.name].water_y = -400
      end

      local bossstart = byId("bossstart", transient.pool)

      bossstart.properties.ontouch = function ()
        if getVar("victory") then
          table.insert(bubbles, {text="Thanks for playing!\nGAME OVER\n\nThis was a game by\nDrCicero (David R.) and his uncle", x=bossstart.x+bossstart.ox, y=bossstart.y+100})
        end
      end

      if getVar("victory") then
        audio.music("07", "default")

      elseif not persistence.vars.boss then
        bossstart.properties.onfirsttouch = function ()
          shock = 30
          audio.play("bigroar", nil, nil, nil, math.random()*1+2)
          persistence[transient.name].water_y_end = 0
        end

      else
        audio.music("raw", "default")

        persistence.vars.boss.lasts = {}
        for i=1,10 do
          local o = byId("boss.lasts[" .. i .. "]")
          persistence.vars.boss.lasts[i] = o
          o.properties.change = hurt_boss
        end
      end


      byId("eye1").properties.change = function ()
        audio.play("water", nil, nil, nil, 3)
        persistence[transient.name].water_y_end = persistence[transient.name].water_y + 8*20 end

      byId("eye2").properties.change = function ()
        audio.play("water", nil, nil, nil, 3.5)
        persistence[transient.name].water_y_end = persistence[transient.name].water_y + 4*20 end

      byId("eye3").properties.change = function ()
        audio.play("water", nil, nil, nil, 3)
        persistence[transient.name].water_y_end = -1 end
    end,


    unload = function()
      if persistence.vars.boss then
        for i,o in ipairs(persistence.vars.boss.lasts) do
          o.properties.change = nil
        end
        persistence.vars.boss.lasts = nil
      end

      byId("eye1").properties.change = nil
      byId("eye2").properties.change = nil
      byId("eye3").properties.change = nil
    end,


    draw = function ()
      if persistence.vars.boss then
        local bosshead = persistence.vars.boss.lasts[1]
        for i = 1, #persistence.vars.boss.lasts  do
          local o = persistence.vars.boss.lasts[i]
          love.graphics.setColor(10,120,245, 50)
          love.graphics.circle("fill", o.x, o.y, tw)
          love.graphics.setColor(255,255,255,255)
          love.graphics.draw(bossimg, o.x, o.y,
            -math.atan2(o.vx, o.vy)+math.pi/2,
            2, 2, 12.5, 12.5)
        end
      end
    end,
  }
}


function level.ice_boss.update ()
  local state = persistence[transient.name]
  if state.water_y_end and state.water_y_end ~= state.water_y then
    state.water_y = state.water_y + (state.water_y_end > state.water_y and 1 or -1)
    camera.x = camera.x + (math.random()*2-1)*5
    camera.y = camera.y + (math.random()*2-1)*5
  end

  if shock then
    camera.x = camera.x + (math.random()*2-1) * math.sqrt(shock)
    camera.y = camera.y + (math.random()*2-1) * math.sqrt(shock)
    shock = shock - 0.5
    if shock == 0 then shock = false end
  end

  if getVar("victory") then

  elseif persistence[transient.name].water_y == 0 then
    local boss = persistence.vars.boss
    if not boss then
      audio.music("raw", "default")
      persistence.vars.boss = {
        phase="up", lasts = {}, times = 5,
      }
      boss = persistence.vars.boss
      for i=1, 10 do
        local o = add_obj("EYE2", 75, 300)
        table.insert(boss.lasts, o)
        o.name = "boss.lasts[" .. i .. "]"
        o.properties.change = hurt_boss
        o.properties.closed = true
        o.airfriction = 0.99
        o.friction = 0.9
        o.gravity = 0.09
      end
      setVar("noescape", true)
    end

    local bosshead = boss.lasts[1]
    if boss.phase ~= "stop" then
      move_obj(bosshead)
    end

    for i = 1, #boss.lasts do
      local o = boss.lasts[i]
      if i ~= 1 and boss.phase ~= "stop" then
        local prev = boss.lasts[i-1]
        local dx = (prev.x-o.x)/7
        local dy = (prev.y-o.y)/7
        o.vx = dx
        o.vy = dy
        move_obj(o)
      end

      if avatar.timer < 0 and avatar.type ~= "RINK_SHIELD"
      and circ_col(avatar.x, avatar.y, o.x, o.y, tw/2, tw) then
        avatar.timer = 60
        hurt_player(o)
      end
    end


    if boss.phase == "up" then
      bosshead.vx = bosshead.vx + (0 - bosshead.vx)/6
      bosshead.vy = bosshead.vy + (-6 - bosshead.vy)/6
      if not bosshead.water then boss.phase = "right" audio.play "hit" end

    elseif boss.phase == "right" then
      bosshead.vx = bosshead.vx + (6.5 - bosshead.vx)/10
      if bosshead.vy >= 2 then
        if not boss.firstround then
          boss.firstround = true
          spawn_mobs()
          boss.phase = "right2"

        else
          boss.firstround = false
          spawn_mobs()
          open_eye()
          boss.phase = "stop"
        end
      end

    elseif boss.phase == "stop" then

    elseif boss.phase == "right2" then
      bosshead.vx = bosshead.vx + (0 - bosshead.vx)/100
      if bosshead.water then boss.phase = "down" audio.play "hit" end

    elseif boss.phase == "down" then
      bosshead.vx = bosshead.vx + (0 - bosshead.vx)/6
      bosshead.vy = bosshead.vy + (5 - bosshead.vy)/6
      if bosshead.y >= 320 then boss.phase = "left" end

    elseif boss.phase == "left" then
      bosshead.vx = bosshead.vx + (-5 - bosshead.vx)/6
      bosshead.vy = bosshead.vy + (0 - bosshead.vy)/6
      if bosshead.x <= 100 then boss.phase = "up" end
    end
  end
end


function hurt_boss ()
  local boss = persistence.vars.boss
  boss.times = boss.times - 1

  -- last hit
  if boss.times == 0 then 
    for i,o in ipairs(boss.lasts) do
      del_obj(o)
    end

    for i,o in ipairs(persistence[transient.name].pool) do
      if o.type == "SLIME" or o.type == "ESLIME" then
        hurt_enemy(o)
      end
    end

    persistence.vars.boss.lasts = nil
    persistence.vars.boss = nil
    setVar("victory", true)
    audio.music("07", "default")
    setVar("noescape", false)

  else
    spawn_mobs()

    for i,o in ipairs(boss.lasts) do
      o.airfriction = 0.99
      o.friction = 0.9
      o.gravity = 0.09
    end

    boss.lasts[1].vx = 2
    boss.lasts[1].vy = 2

    boss.phase = "right2"
  end
end


function spawn_mobs ()
  audio.play("bigroar", nil, nil, nil, math.random()*1+2)
  shock = 30
  local a = add_obj("SLIME", 8*20, 8*20)
  local b = add_obj("SLIME", 21*20, 8*20)
  a.vx = 1
  b.vx = -1
end

function open_eye ()
  persistence.vars.boss.lasts[math.ceil(math.random() * #persistence.vars.boss.lasts)].properties.closed  = false
end
