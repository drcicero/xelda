local entities = require "entities"
local persistence = require "state"

local M = {}

--- setType setId decompress
function M.init (o)
  M.setType(o, o.type)
  M.setId(o, o.name)
  entities.decompress(o)
end


---
function M.setType (o, type)
  transient.types[o.type][o] = nil
  o.type = type
  transient.types[type][o] = 1
end

---
function M.setId (o, name)
  if o.name then
    transient.byid[name] = nil
  end

  if name then
    o.name = name
    transient.byid[name] = o
  end
end

--- reuse one of the removed objs or make a new one TODO remove
local function getAlmostNewObj ()
  for k,_ in pairs(transient.types.REMOVED) do
    return k
  end

  local o = {type="REMOVED"}
  table.insert(persistence[persistence.mapname].pool, o)
  return o
end

--- spawn obj of type at pos (x,y) TODO remove
function M.spawn (type, x, y)
  local o = getAlmostNewObj()
  M.setType(o, type)
  entities.decompress(o)
  o.x, o.y = x, y
  return o
end

---
function M.del (o)
  M.setType(o, "REMOVED")
  for k,v in pairs(o) do o[k] = nil end
  o.type = "REMOVED"
end


return M
