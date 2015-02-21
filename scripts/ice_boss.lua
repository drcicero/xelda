local cron = require "cron"
local audio = require "audio"

local sfx = require "sfx"

local objs = require "map.objs"
local camera = require "map.camera"
local scripting = require "map.scripting"


local byId = scripting.byId
local byClass = scripting.byClass
local wander_by = scripting.wander_by

local bossimg = love.graphics.newImage("assets/boss.png")
local shock

function shallowcopy (m)
  local t = {}
  for i=1,#m do t[i] = m[i] end
  return t
end

function sample (k, t)
  for i = 1, #t-k do
    local r = math.ceil(math.random() * #t)
    table.remove(t, r)
  end

  return t
end

local function spawn_mobs ()
  audio.play("bigroar", nil, nil, nil, math.random()*1+2)
  shock = 30

  local o = objs.spawn("SLIME", 8*20, 8*20)
  o.vx = 1

  local o = objs.spawn("SLIME", 21*20, 8*20)
  o.vx = -1
end


return {
  funcs = {
    bossstart_onfirsttouch = function ()
      shock = 30
      audio.play("bigroar", nil, nil, nil, math.random()*1+2)
      persistence[persistence.mapname].water_y_end = 0
    end,

    bossstart_ontouch = function (self)
      if getVar("victory") then
        table.insert(bubbles, {
          x = self.x + self.ox, y = self.y + 100,
          text = "Thanks for playing!\nGAME OVER\n\nThis was a game by\nDrCicero (David R.) and his uncle",
        })
      end
    end,

    hurt_boss = function (self)
      local boss = persistence.vars.boss

      self.properties.delete = true

      local all_closed = true
      for i,o in ipairs(boss.lasts) do 
        if not o.properties.closed then
          all_closed = false  break
        end
      end

      if all_closed then
        for i = #boss.lasts,1,-1 do
          local o = boss.lasts[i]
          if o.properties.delete then
            table.remove(boss.lasts, i)
            sfx.hitboss(o.x, o.y)
            objs.del(o)

          else
            o.airfriction = 0.99
            o.friction = 0.9
            o.gravity = 0.09
          end
        end

        -- last hit
        if #boss.lasts == 1 then 
          cutscene("boss_fight_end", function()
            for i,o in ipairs(boss.lasts) do
              levelclock.add {dur=.6*(i-1)+2, ended=function()
                sfx.hitboss(o.x, o.y)
                o.alpha = 255
                levelclock.add {dur=.5, f=cron.to(o, "alpha", 0), ended=function()
                  objs.del(o)
                end}
              end}
            end
            boss.lasts = {}

            for i,o in ipairs(persistence[persistence.mapname].pool) do
              if o.type == "SLIME" or o.type == "ESLIME" then
                levelclock.add {dur=1*i, ended=function()
                  sfx.hitboss(o.x, o.y)
                  o.alpha = 255
                  levelclock.add {dur=1.1, f=cron.to(o, "alpha", 0), ended=function()
                    objs.del(o)
                  end}
                end}
              end
            end

            levelclock.add {dur=5, ended=function()
              persistence.vars.boss = nil
              setVar("victory", true)
              audio.music("07")
              setVar("noescape", false)
            end}
          end)

        else
          spawn_mobs()

          boss.lasts[1].vx = 2
          boss.lasts[1].vy = 2

          boss.phase = "right2"
        end        
      end
    end,

    eye1_change = function ()
      audio.play("water", nil, nil, nil, 3)
      persistence.ice_boss.water_y_end = persistence[persistence.mapname].water_y + 8*20
    end,

    eye2_change = function ()
      audio.play("water", nil, nil, nil, 3.5)
      persistence.ice_boss.water_y_end = persistence[persistence.mapname].water_y + 4*20
    end,

    eye3_change = function ()
      audio.play("water", nil, nil, nil, 3)
      persistence.ice_boss.water_y_end = -1
    end,
  },

  load = function ()
    local curmap = persistence[persistence.mapname]

    if not curmap.initialized then
      curmap.initialized = true
      curmap.water_y_end = false
      curmap.water_y = -400

      byId("eye1").properties.change = "$eye1_change"
      byId("eye2").properties.change = "$eye2_change"
      byId("eye3").properties.change = "$eye3_change"
    end

    local bossstart = byId("bossstart")
    bossstart.properties.ontouch = "$bossstart_ontouch"
    bossstart.properties.onfirsttouch = "$bossstart_onfirsttouch"

    if getVar("victory") then
      audio.music("07")

    elseif persistence.vars.boss then
      audio.music("Raw")

      persistence.vars.boss.lasts = {}
      for i=1, 10 do
        persistence.vars.boss.lasts[i] = byId("boss.lasts[" .. i .. "]")
      end

    else
      audio.music(nil)
    end
  end,


  unload = function()
    if persistence.vars.boss then
      persistence.vars.boss.lasts = nil
    end
  end,


  draw = function ()
      local boss = persistence.vars.boss

--    if persistence.vars.boss then
      -- local bosshead = persistence.vars.boss.lasts[1]
      for k,o in pairs(byClass('bosslasts')) do
--        love.graphics.setColor(10,120,245, 50)
--        love.graphics.circle("fill", o.x, o.y, tw)
        love.graphics.setColor(255,255,255, o.alpha)
        love.graphics.draw(bossimg, o.x, o.y,
          -math.atan2(o.vx, o.vy)+math.pi/2,
          2, 2, 12.5, 12.5)

        if not o.properties.closed then
          local a, b = 100+math.random()*155, math.random()*100
          love.graphics.setColor(a, b, b, 255)
          love.graphics.setLineWidth(1 + math.random()*4)

--          local dx, dy = avatar.x - o.x, avatar.y - o.y
          local x = math.cos(o.properties.da_angle - boss.timer/60)
          local y = math.sin(o.properties.da_angle - boss.timer/60)
--          local d = math.sqrt(dx*dx+dy*dy)

          love.graphics.line(o.x, o.y-10, o.x + x*200, o.y-10 + y*200)
          love.graphics.setLineWidth(1)
        end
      end
--    end
  end,

  update = function ()
    local state = persistence[persistence.mapname]
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

    elseif persistence[persistence.mapname].water_y == 0 then
      local boss = persistence.vars.boss

      -- load init start begin
      if not boss then
        audio.music "Raw"
        persistence.vars.boss = { phase="up", lasts = {}, notyet = 1, timer = 0, }
        boss = persistence.vars.boss
        for i=1, 10 do
          local o = objs.spawn("EYE2", 75, 300)
          table.insert(boss.lasts, o)
          o.name = "boss.lasts[" .. i .. "]"
          o.class = "bosslasts"
          o.properties.change = "$hurt_boss"
          o.properties.closed = true
          o.airfriction = 0.99
          o.friction = 0.9
          o.gravity = 0.09
        end
        setVar("noescape", true)
      end
      boss.timer = boss.timer - 1

      local bosshead = boss.lasts[1]
      if boss.phase ~= "stop" then
        move_obj(bosshead)
      end

      for i = 1, #boss.lasts do
        local o = boss.lasts[i]
        if i ~= 1 and boss.phase ~= "stop" then
          local prev = boss.lasts[i-1]
          local dx, dy = (prev.x-o.x)/7, (prev.y-o.y)/7
          o.vx, o.vy = dx, dy
          move_obj(o)
        end

        if circ_col(avatar.x, avatar.y, o.x, o.y, tw/2, tw) then
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
          if boss.notyet == 0 then
            boss.timer = 0
            boss.notyet = math.floor((11-#boss.lasts)/2)
            spawn_mobs()

            local asd = shallowcopy(boss.lasts)
            if 11 - #boss.lasts > #boss.lasts then table.remove(asd, 1) end
            for i,o in pairs(sample(11 - #boss.lasts, asd)) do
              o.properties.da_angle = math.pi/2 - math.atan2(avatar.x-o.x, avatar.y-o.y)
              o.properties.closed = false
            end

            boss.phase = "stop"

          else
            boss.notyet = boss.notyet - 1
            spawn_mobs()
            boss.phase = "right2"
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
  end,
}
