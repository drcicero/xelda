--- All about objs

local g = love.graphics
local M = {}

---
function M.changeType (o, type)
  transient.types[o.type][o] = nil
  o.type = type
  transient.types[type][o] = 1
end

function M.setType (o, type)
  o.type = type
  transient.types[type][o] = 1
end

function M.cacheType (o)
  transient.types[o.type][o] = 1
end


--- reuse one of the removed objs or make a new one
local function getAlmostNewObj ()
  for k,_ in pairs(transient.types.REMOVED) do
    return k
  end

  local o = {type="REMOVED"}
  table.insert(persistence[persistence.mapname].pool, o)
  return o
end


--- spawn obj of type at pos (x,y)
function M.spawn (type, x, y)
  local o = getAlmostNewObj()
  M.changeType(o, type)
  M.cacheType(o)
  M.decompress(o)
  o.x, o.y = x, y
  return o
end

function M.changeId (o, name)
  if o.name then
    transient.byid[name] = nil
  end

  o.name = name
  transient.byid[name] = o
end


---
function M.del (o)
  M.changeType(o, "REMOVED")
  for k,v in pairs(o) do o[k] = nil end
  o.type = "REMOVED"
end


local default_obj = {
  name='',

  x=0, y=0, vx=0, vy=0,
  width=13, height=14,
  ix=10, iy=19, -- ox, oy,

  r = math.huge, alpha = 255,

  timer=0, disabled=false,
  wall=false, water=false, ground=false, facing=1,
}


---
function M.compress (o)
  if o.ox == o.width/2  then o.ox = nil end
  if o.oy == o.height-1 then o.oy = nil end
  for k,v in pairs(default_obj) do
    if o[k] == v then o[k] = nil end
  end
end


---
function M.decompress (o)
  for k,v in pairs(default_obj) do
    if o[k] == nil then o[k] = v end
  end
  if o.ox == nil then o.ox = o.width/2  end
  if o.oy == nil then o.oy = o.height-1 end

  if o.properties == nil then o.properties = {} end
end

return M
