local cron = require "cron"
local audio = require "audio"

local sfx = require "sfx"
local persistence = require "state"

local move_obj = require "game.move"

local pool = require "pool"
local draw = require "map.draw"
local scripting = require "map.scripting"
local byId = scripting.byId

local g = love.graphics

local boss
local bossimg = g.newImage("assets/boss.png")

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


local function sfx_bosstrigger()
end

local function spawn_mobs ()
  sfx_bosstrigger()

  local o = pool.spawn("SLIME", 8*20, 8*20)
  o.vx = 1

  local o = pool.spawn("SLIME", 21*20, 8*20)
  o.vx = -1
end


local function reset_boss_lasts()
  for i = #boss.lasts,1,-1 do
    local o = boss.lasts[i]
    if o.properties.delete then
      table.remove(boss.lasts, i)
      sfx.hitboss(o.x, o.y)
      pool.del(o)

    else
      o.airfriction = 0.99
      o.friction = 0.9
      o.gravity = 0.09
    end
  end
end


local function boss_fight_end ()
  -- delete all boss lasts
  for i,o in ipairs(boss.lasts) do
    transient.levelclock.add {dur=.6*(i-1)+2, ended=function()
      sfx.hitboss(o.x, o.y)
      o.alpha = 255
      transient.levelclock.add {dur=.5, f=cron.to(o, "alpha", 0), ended=function()
        pool.del(o)
      end}
    end}
  end
  boss = nil

  -- delete all slimes
  for o,_ in pairs(transient.types.SLIME) do
    sfx.hurtenemy(o.x, o.y)
    pool.del(o)
  end
  for o,_ in pairs(transient.types.ESLIME) do
    sfx.hurtenemy(o.x, o.y)
    pool.del(o)
  end

  -- play win music
  transient.levelclock.add {dur=5, ended=function()
    scripting.setVar("victory", true)
    audio.music("07")
    scripting.setVar("noescape", false)
  end}
end

local function are_all_eyes_closed ()
  for i,o in ipairs(boss.lasts) do 
    if not o.properties.closed then
      return false
    end
  end
  return true
end

local function update_boss (bosshead)
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
end


local phase = {
  up = function (bosshead)
    bosshead.vx = bosshead.vx + (0 - bosshead.vx)/6
    bosshead.vy = bosshead.vy + (-6 - bosshead.vy)/6
    if not bosshead.water then
      boss.phase = "right"
      audio.play "hit"
    end
  end,
  
  right = function (bosshead)
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
  end,
  
  right2 = function (bosshead)
    bosshead.vx = bosshead.vx + (0 - bosshead.vx)/100
    if bosshead.water then
      boss.phase = "down"
      audio.play "hit"
    end
  end,
  
  down = function (bosshead)
    bosshead.vx = bosshead.vx + (0 - bosshead.vx)/6
    bosshead.vy = bosshead.vy + (5 - bosshead.vy)/6
    if bosshead.y >= 320 then boss.phase = "left" end
  end,

  left = function (bosshead)
    bosshead.vx = bosshead.vx + (-5 - bosshead.vx)/6
    bosshead.vy = bosshead.vy + (0 - bosshead.vy)/6
    if bosshead.x <= 100 then boss.phase = "up" end
  end,
}


return {
  funcs = {
    throwback = function (self)
      avatar.vy = -5
      avatar.vx = (self.name == "leftwall" and 1 or -1) * 10
    end,

    bossstart_onfirsttouch = function ()
     byId("leftwall").properties.ontouch  = "$throwback"
     byId("rightwall").properties.ontouch = "$throwback"
     sfx_bosstrigger()

      audio.music "Raw"
      boss = { phase="up", lasts = {}, notyet = 1, timer = 0, }
      for i=1, 10 do
        local o = pool.spawn("EYE2", 75, 300)
        table.insert(boss.lasts, o)
        o.name = "boss.lasts[" .. i .. "]"
        o.class = "bosslasts"
        o.properties.change = "$hurt_boss"
        o.properties.closed = true
        o.airfriction = 0.99
        o.friction = 0.9
        o.gravity = 0.09
      end
      scripting.setVar("noescape", true)
    end,

    hurt_boss = function (self)
      self.properties.delete = true

      if are_all_eyes_closed() then
        reset_boss_lasts()

        if #boss.lasts == 3 then
          boss_fight_end()
        else
          spawn_mobs()
          boss.lasts[1].vx = 2
          boss.lasts[1].vy = 2
          boss.phase = "right2"
        end        
      end
    end,

    eye_change = function (self, bool, arg)
      audio.play("water", nil, nil, nil, 3)
      persistence[persistence.mapname].water_y_end = tonumber(arg)
    end,
  },

  focus = function ()
    audio.music(scripting.getVar "victory" and "07"
                or boss and "Raw"
                or nil)

    local bossstart = byId("bossstart")
    bossstart.properties.onfirsttouch = "$bossstart_onfirsttouch"

    byId("eye1").properties.change = "$eye_change " .. tostring(-12 * 20)
    byId("eye2").properties.change = "$eye_change " .. tostring(- 8 * 20)
    byId("eye3").properties.change = "$eye_change " .. tostring(  0     )

    scripting.cutscene("init", function ()
      local level = persistence[persistence.mapname]
      level.water_y_end = false
      level.water_y = -20 * 20
    end)
  end,

  draw = function ()
    if boss then
      for k,o in ipairs(boss.lasts) do
        g.setColor(255,255,255, o.alpha)
        g.draw(bossimg, o.x, o.y,
          -math.atan2(o.vx, o.vy)+math.pi/2,
          2, 2, 12.5, 12.5)

        draw.draw_obj(o)

--        if not o.properties.closed then
--          local a, b = 100+math.random()*155, math.random()*100
--          g.setColor(a, b, b, 255)
--          g.setLineWidth(1 + math.random()*4)

--          local x = math.cos(o.properties.da_angle - boss.timer/60)
--          local y = math.sin(o.properties.da_angle - boss.timer/60)

--          g.line(o.x, o.y-10, o.x + x*200, o.y-10 + y*200)
--          g.setLineWidth(1)
--        end
      end
    end
  end,

  update = function ()
    local level = persistence[persistence.mapname]
    if level.water_y_end and level.water_y_end ~= level.water_y then
      level.water_y = level.water_y + (level.water_y_end > level.water_y and 1 or -1)
    end

    if boss and boss.phase ~= "stop" then
      local bosshead = boss.lasts[1]

      boss.timer = boss.timer - 1
      update_boss(bosshead)
      phase[boss.phase](bosshead)
    end
  end,
}
