--- Scripting
-- requires $frames, $audio, $cron

local app = require "frames"
local cron = require "cron"
local audio = require "audio"

local M = {hooks={}, levels={}}


--local chars = {
--  Xelda = love.graphics.newImage "assets/xelda.png",
--  Watson = love.graphics.newImage "assets/watson.png",
--}


local script, scripterr
---
-- name is a string, func is a coroutine.
--
-- only unique named cutscene may run parallel.
-- pushs a new app, start the coroutine, and pops it when it is dead.
function cutscene (name, func)
  if func==nil then name,func=func,name end

  -- run cutscene only once
  if name then
    local v = persistence[persistence.mapname].vars
    if v[name] == true then
      return
    else
      v[name] = true
    end
  end

  script = coroutine.create(function ()
    local ok, what = xpcall(func, debug.traceback)
    if not ok then scripterr = what end
  end)

  sceneclock = cron.new_clock()

  app.push {
    name = "cutscene: " .. tostring(name),

    draw = function () 
      local height = font:getHeight()*3
      love.graphics.setColor(0,0,0, 255 * 0.7)
      love.graphics.rectangle("fill", 0,h-50-height,w,height+30)

      love.graphics.setColor(255,255,255, 255 * 0.3)
      love.graphics.line(0,h-50-height, w,h-50-height)
      love.graphics.line(0,h-20, w,h-20)
    end,

    update = function ()
      sceneclock.update()
      if coroutine.status(script) == "dead"
      and sceneclock.len() == 0 then
        app.pop()
      end
    end,

    quit = function ()
      sceneclock = nil
    end,
  }

  resume()
end


function resume ()
  coroutine.resume(script)
  if scripterr then
    local tmp = scripterr
    scripterr = nil
    error(tmp)
  end
end


function wait (dur)
  sceneclock.add {dur=dur, ended=resume}
  coroutine.yield()
end


local function show_dialog (name, prevtext, text, after)
  local tmp 
  avatar.facing = avatar.x > name.x and -1 or 1

  tmp, avatar = avatar, name
  if name.properties.image == "Watson" then audio.play "he" end
  transient.levelclock.add {dur=1, f=function(t)
    name.r = .1*math.sin(t * math.pi*2)
    name.z = 1+.1*math.sin(t * math.pi)
  end, ended=function()
    name.r = nil
  end}

  pressed[" "] = false

  local o = {str=prevtext}
  local continue = false
  local dur = #text/25/2

  local tween = sceneclock.add {dur=dur, ease=cron.ease.Linear,
    f=cron.write(o, "str", text:gsub("\\n", "\n")),
    ended=function() continue = true audio.play "beep" end}

  app.push({
    name = "textbox",

    update = function ()
      if pressed[" "] then
        if continue then
          change_level_timer = 50
          app.pop()
          avatar = tmp
          if after then after() end

        else
          pressed[" "] = false
          sceneclock.del(tween)
          local tween = sceneclock.add {dur=0.1, ease=cron.ease.Linear,
            f=cron.write(o, "str", text:gsub("\\n", "\n"):sub(#o.str - #prevtext + 1)),
            ended=function() continue = true audio.play "beep" end}
        end
      end
    end,

    draw = function ()
      local x = w/2-400
      local y = math.max(0, h/2-200)
      local str = o.str
      local width, lines = font:getWrap(str, 400-20)
      local fh = font:getHeight()
      height = fh * math.max(lines, 3)

--[[
      if name and name.properties and chars[name.properties.image] then
        image = chars[name.properties.image]
        love.graphics.setColor(255,255,255,255)

        local scale = .9 * h/350
        love.graphics.draw(image,
          0,
--          x - 10 + 800/3 - image:getWidth()*scale,
          h - image:getHeight() * scale,
        --image==xelda and h-(image:getHeight()-100)*scale or h-(image:getHeight()+100)*scale,
          0, scale)
      end
]]

      love.graphics.setColor(255,255,255,255)
      love.graphics.setFont(font)
      love.graphics.printf(str,
        (w-400+20)/2, h-45-height, 400-20, "left")

      if continue then
        love.graphics.setColor(255,255,255, 127)
--        local x, y = (w+300)/2, h - 40 + 2 -12 +12 * (now % 1)
        local x, y = w/2, h - 38 + 12 * (now % 1)
        local w = fh-4
        local h = w / math.sqrt(1.5)

        love.graphics.polygon("fill",
          x,       y,
          x + w,   y,
          x + w/2, y + h
        )
      end

--      love.graphics.setColor(255,255,255, 50)
--      love.graphics.printf("[space]", (w-400+20)/2 + fh, h - 40, 400, "right")
    end,
  })
end


local lastname, lasttext = nil, ""

--- show new message-box, skipable
function M.dialog (name, text)
  if text then
    lastname = name
    lasttext = name.properties.image .. ": "
  else
    text = name
  end

  show_dialog(lastname, lasttext, text, resume)
  lasttext = lasttext .. text
  coroutine.yield()
end


--- find obj in pool by id. if noerr is true returns nil when no obj is found.
function M.byId (id, pool, noerr)
  local o = transient.byid[id]
  if o == nil and not noerr then
    error("no elem by id: " .. id)
  end

  return o
--  if pool == nil then
--    local res = M.byId(id, persistence[persistence.mapname].pool, true)
--    if res then return res end

----    res = M.byId(id, transient.pool, true)
----    if res then return res end

--    if noerr then return nil
--    else error("no elem by id: " .. id) end

--  else
--    for i,o in ipairs(pool) do
--      if o.name == id then
--        return o
--      end
--    end

--    if noerr then return nil
--    else error("no elem by id: " .. id) end
--  end
end

--- find objs in pool by class. if result is a table, its elements will also be returned.
function M.byClass (class, pool, result)
  result = result or {}
  if pool == nil then
    M.byClass(class, persistence[persistence.mapname].pool, result)
--  M.byClass(class, transient.pool, result)
    return result
  end

  local len = #result+1
  for i,o in ipairs(pool) do
    if o.class == class then
      result[len] = o
      len = len+1
    end
  end
  return result
end

---
-- fly the obj 'fairy' in curves by (x,y), if level_or_scene is true
-- transient.levelclock will be used instead of sceneclock.
function M.wander_by (fairy, x, y, level_or_scene)
--  local tmp = avatar
--  avatar = fairy

  local clock = level_or_scene and transient.levelclock or sceneclock
  local dur   = level_or_scene and .75 or 1.5
  local ended = not level_or_scene and resume or nil

  local oldx, oldy = fairy.x, fairy.y
  clock.add {dur=dur, ease=cron.ease.Swing, f=function (z)
    fairy.x = oldx + x*z
    fairy.y = oldy + y*z + 5 * math.sin(z*10)
  end, ended=ended}
  if not level_or_scene then coroutine.yield() end
end


---- Hooks
--- calls hook from plugins

---
function M.hook (name)
  local level = M.levels[persistence.mapname]
  if level[name] then level[name]() end
end

function M.hooks.load (src)
  local level = M.levels[src] or
    love.filesystem.exists("scripts/" .. src .. ".lua") and
    require("scripts." .. src) or {}

  M.levels[src] = level
end

return M