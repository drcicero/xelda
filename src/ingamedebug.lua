--- Ingame Debugging
-- a message box and collission drawings
--
-- returns a draw function

local floor = math.floor
local audio = require "audio"
local app = require "frames"
local serialize = (require "serialize").serialize

local g = love.graphics


function count (tab)
  local i = 0
  for _,_ in pairs(tab) do i=i+1 end
  return i
end


function print_globals ()
  local tab, i = {}, 1
  for k,v in pairs(_G) do
    if 1 ~= ({_G=1, _VERSION=1, arg=1, assert=1, bit=1, collectgarbage=1, coroutine=1, debug=1, dofile=1, error=1, gcinfo=1, getfenv=1, getmetatable=1, io=1, ipairs=1, jit=1, loadfile=1, loadstring=1, love=1, math=1, module=1, newproxy=1, next=1, os=1, package=1, pairs=1, pcall=1, print=1, rawequal=1, rawget=1, rawset=1, require=1, select=1, setfenv=1, setmetatable=1, string=1, table=1, tonumber=1, tostring=1, type=1, unpack=1, xpcall=1})[k] then
      tab[i] = k
      i = i+1
    end
  end
  table.sort(tab)
  print(serialize(tab))
end

return function ()
  if app.timestep then
    s = s .. "fps: " .. love.timer.getFPS()

  else
    s = s .. "updates: " .. tostring(updates)
  end

  g.setColor(255, 255, 255, 50)
  g.setFont(font)
  if DEBUG then
--    s = s .. "\ncollisions: " .. floor(collisions)
--          .. "\nobjs: " .. floor(objs)

    s = s .. "\n\navatar.lua:"
    s = s .. "\n  vx: " .. avatar.vx
    s = s .. "\n  vy: " .. avatar.vy

    s = s .. "\n\napp.lua:"
    for i, state in pairs(app.stack) do
      s = s .. "\n  " .. (state.name or tostring(state))
    end

    s = s .. "\n\naudio.lua:"
    for id, channel in pairs(audio.channels) do
      s = s .. "\n  " .. id .. ": " .. floor(channel.vol*100)/100 .. "x " ..  tostring(channel.name)
    end

--    g.print(serialize(avatar), 300, 0)

    local i = 0
    for t,objs in pairs(types) do
      local c = count(objs)
      if c > 0 then
        i=i+1
        g.print(t .. ": " .. count(objs), 200, i*15)
      end
    end
  end


  g.print(s, 26, 115);
  s = ""
end
