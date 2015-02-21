--- All about objs

local g = love.graphics

local M = {}

--- set type of object. (update type cache)
function M.setType (o, type)
	if o.type then
    	types[o.type][o] = nil
	end
	
	types[type][o] = 1
	o.type = type
	
	return o
end


--- reuse one of the removed objs or make a new one
-- TODO belongs to map 
local function getNewObj ()
  local o

  for k,_ in pairs(types.REMOVED) do
    o = k
    break
  end

  if o == nil then
    o = {}
    table.insert(
      persistence[persistence.mapname].pool,
      o
    )
  end

  return o
end


--- spawn obj of type at pos (x,y)
-- TODO belongs to map
function M.spawn (type, x, y)
  local o = getNewObj()
  M.unclean(nil, o, nil, type)
--  o.is_transient = is_transient_type[type]
  o.x, o.y = x, y
  return o
end


--- del obj
function M.del (o)
  M.setType(o, "REMOVED")
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


-- prepare for saving, remove redundant data
function M.clean (o)
--  unfreeze(o)

  if o.ox == o.width/2 then o.ox = nil end
  if o.oy == o.height-1 then o.oy = nil end
  -- if eq(o.properties, {}) then o.properties = nil end
  for k,v in pairs(default_obj) do
    if o[k] == v then
      o[k] = nil
    end
  end
end


-- finish loading, create transient data
function M.unclean (_, o, _, type, dontsettype)
--  unfreeze(o)

  if not dontsettype then 
    if type == nil and o.type == nil then error("notype") end
    type = type or o.type -- or "DUMMY"
    M.setType(o, type)
  end

  for k,v in pairs(default_obj) do
    if o[k] == nil then o[k] = v end
  end
  if o.ox == nil then o.ox = o.width/2 end
  if o.oy == nil then o.oy = o.height-1 end
  if o.properties == nil then o.properties = {} end

  if o.properties.switch then
    o.disabled = getVar(o.properties.switch)
  end

--  freeze(o)
end

--function unfreeze (o)
--  setmetatable(o, {})
--end

--function freeze (o)
--  setmetatable(o, {__newindex=function (self, key, val)
--    error("tried to change " .. make_key(key) .. " = " .. serialize(val) .. " of frozen ".. serialize(self), 2)
--  end})
--end

--function copy_obj (o)
--  print("copy_obj")
--  local new = {}
--  unclean_obj(nil, new, nil, o.type)

--  print("old", serialize(o))
--  for k,v in pairs(o) do new[k] = v end
--  for k,v in pairs(o.properties) do new.properties[k] = v end

--  return new
--end


return M
