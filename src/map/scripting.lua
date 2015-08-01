--- Level Scripting
-- This file currently contains 2 things: <ul>
-- <li> functions to load / run the scripts
-- <li> functions to use in the scripts
-- </ul>

local cron = require "cron"
local audio = require "audio"
local widgets = require "widgets"

local pool =  require "pool"
local state = require "state"
local serialize = (require "serialize").serialize

local M = {hooks={}, levels={}}

M.spawn = pool.spawn
M.del = pool.del

--- state.events.on
-- state.events.on is a table of cond=func pairs.
-- each $src.map.scripting#M.update the conds are called, and if it returns true
-- the corresponding func is called.
--
-- you have to set new cond=func pairs, if you want to use the events system.

--- state.events.once
-- <br>works like $src.map.scripting#state.events.on. additionaly the pair is removed after the first call.
state.events = {on={},once={}}

--- call this once per frame
function M.update()
  if not state.events then state.events = {on={}, once={}} end

  for cond, func in pairs(state.events.once) do
    if M.getVar(cond) then
      state.events.once[cond] = nil
      M.getVar(func)
    end
  end

  for cond, func in pairs(state.events.on) do
    if cond() then func() end
  end
end

---- Switchs -------------------------------------------------------------------

--- shortcut for $src.map.scripting#M.setVar(o.properties[propname], bool, o)
function M.emit (o, propname, bool)
  local name = o.properties[propname]
  if name then M.setVar(name, bool, o) end
end

--- set vars[name] to 'bool'. However, if 'name' starts with a: <ul>
-- <li> '!', then set vars[name] to 'not bool'.
-- <li> '$', followed by a name "funcname" in the "funcs" table of the
--       current levels scripting file "level" and an a string "arg" and
--       return "level.funcs[funcname](obj, bool, arg)".
-- </ul>
function M.setVar (name, bool, obj)
  local mapname = state.mapname
  local vars = state[mapname].vars
  if name:sub(1,1) == "$" then
    local first_space = name:find(" ") or #name+1
    local name, arg = name:sub(2, first_space-1), name:sub(first_space+1)
    return M.levels[mapname].funcs[name](obj, bool, arg)

  else
    if name:sub(1,1) == "!" then
      name = name:sub(2)
      bool = not bool
    end

    if vars[name] ~= bool then
      vars[name] = bool
    end
  end
end

--- lookup the current value for the boolean called name.
-- (deprecated: split name on spaces and returns true when any of the vars is true.)
-- <br>calles M.levels[state.mapname].funcs[name:sub(2)]()
-- <br>inverses the result if 'name' starts with "!".
-- <br>errors if val is neither nil, bool or number.
function M.getVar (name)
  if name:sub(1,1) == "$" then
    return M.levels[state.mapname].funcs[name:sub(2)]()

  else
    local leer = name:find(" ")
    if leer then
      print("WARN: leer deprecated")
      return M.getVar(name:sub(1, leer-1)) or M.getVar(name:sub(leer+1))
    end

    local not_ = name:sub(1,1) == "!"
    if not_ then name = name:sub(2) end

    local val = state[state.mapname].vars[name]
    local t = type(val)

    if     t == "nil" then     return not_
    elseif t == "boolean" then return val == not not_ end

    print("getVar: error " .. tostring(val) .. " is neither nil, bool or number")
  end
end

---- Cutscene ------------------------------------------------------------------

local script, scripterr

--- name is a string, func is a coroutine.
-- if its name was submitted before nothing happens, else the coroutine is run,
-- a new widget is pushed, and then popped as the coroutine dies.
function M.cutscene (name, func)
  if func==nil then name,func=func,name end

  -- run cutscene only once
  if name then
    local v = state[state.mapname].vars
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

  widgets.push {
    name = "cutscene: " .. tostring(name),

    draw = function () 
      local height = font:getHeight()*4
      local width  = 400-20  + 10
      local x = (w-400+20)/2 - 5
      local y = h-30-height  - 5
      love.graphics.setColor(0,0,0, 255 * 0.7)
      love.graphics.rectangle("fill", x, y, width, height)

      love.graphics.setColor(255,255,255, 255 * 0.3)
      love.graphics.rectangle("line", x, y, width, height)
    end,

    update = function ()
      sceneclock.update()
      if coroutine.status(script) == "dead"
      and sceneclock.len() == 0 then
        widgets.pop()
      end
    end,

    quit = function ()
      sceneclock = nil
    end,
  }

  M.resume()
end

---
function M.resume ()
  coroutine.resume(script)
  if scripterr then
    local tmp = scripterr
    scripterr = nil
    error(tmp)
  end
end

---
function M.wait (dur)
  sceneclock.add {dur=dur, ended=M.resume}
  coroutine.yield()
end

---- Dialog --------------------------------------------------------------------

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

  widgets.push({
    name = "textbox",

    update = function ()
      if pressed[" "] then
        if continue then
          change_level_timer = 50
          widgets.pop()
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

      if continue and (now % 1 < .5) then
        love.graphics.setColor(255,255,255, 127)
--        local x, y = (w+300)/2, h - 40 + 2 -12 +12 * (now % 1)
        local x, y = w/2, h - 38 -- + 12 * (now % 1)
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

  show_dialog(lastname, lasttext, text, M.resume)
  lasttext = lasttext .. text
  coroutine.yield()
end

---- Selectors -----------------------------------------------------------------

--- find obj of level by id.
-- if no match is found it returns nil or errors, depending on noerr
function M.byId (id, pool, noerr)
  local o = transient.byid[id]
  if o == nil and not noerr then
    error("no elem by id: " .. id)
  end
  return o
end

--- filter objs by class.
-- if no match is found it returns an empty table or errors, depending on noerr
function M.byClass (class, pool)
  pool = pool or state[state.mapname].pool

  local result = {}
  local len = 0
  for i,o in ipairs(pool) do
    if o.class == class then
      len = len+1
      result[len] = o
    end
  end
  return result
end

---- Moving --------------------------------------------------------------------

--- fly the given obj in curves by (x,y), if level_or_scene is true
-- transient.levelclock will be used instead of sceneclock.
function M.wander_by (obj, x, y, level_or_scene)
--  local tmp = avatar
--  avatar = obj

  local clock = level_or_scene and transient.levelclock or sceneclock
  local dur   = level_or_scene and .75 or 1.5
  local ended = not level_or_scene and M.resume or nil

  local oldx, oldy = obj.x, obj.y
  clock.add {dur=dur, ease=cron.ease.Swing, f=function (z)
    obj.x = oldx + x*z
    obj.y = oldy + y*z + 5 * math.sin(z*10)
  end, ended=ended}
  if not level_or_scene then coroutine.yield() end
end


---- Hooks ---------------------------------------------------------------------
--- calls hook from plugins

---
function M.hook (name)
  local level = M.levels[state.mapname]
  if level[name] then level[name]() end
end

---
function M.hooks.load (src)
  local level = M.levels[src] or
    love.filesystem.exists("scripts/" .. src .. ".lua") and
    require("scripts." .. src) or {}

  M.levels[src] = level
end

return M
