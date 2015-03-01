--- Switch Scripting
-- requires $scripting
local scripting = require "map.scripting"

function emit (o, propname, bool)
  local name = o.properties[propname]
  if name then setVar(name, bool, o) end
end

---
-- set vars[name] to 'bool'. However, if 'name' starts with a:
--
-- * '!', then set vars[name] to 'not bool'.
-- 
-- * '-', then decr vars[name] or init to '-1'.
--
-- * '$', then return 'scripting.levels.funcs[name](bool)'.
function setVar (name, bool, obj)
  local mapname = persistence.mapname
  local vars = persistence[mapname].vars
  if name:sub(1,1) == "$" then
    local first_space = name:find(" ") or #name
    return scripting.levels[mapname].funcs[name:sub(2, first_space)](obj, bool, name:sub(first_space+1))

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

---
-- split name on spaces and returns true when any of the vars
-- is true, is <= 0, else false.
--
-- inverses the result if 'name' starts with "!".
function getVar (name)
  local leer = name:find(" ")
  if name:find(" ") then
    return getVar(name:sub(1, leer-1)) or getVar(name:sub(leer+1))
  end

  local not_ = name:sub(1,1) == "!"
  if not_ then name = name:sub(2) end

  local val = persistence[persistence.mapname].vars[name]
  local t = type(val)

  if     t == "nil" then     return not_
  elseif t == "boolean" then return val == not not_
  elseif t == "number" then  return (val <= 0) == not not_ end

  print("getVar: error " .. tostring(val) .. " is neither nil, bool or number")
end

