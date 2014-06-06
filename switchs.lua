function setVar (name, bool)
  if type(name) == "function" then return name(bool) end
  if name:sub(1,1) == "-" then
    name = name:sub(2)
    if not type(persistence[transient.name].vars[name]) == "number" then persistence[transient.name].vars[name] = 0 end
    persistence[transient.name].vars[name] = persistence[transient.name].vars[name] - 1
--    print("set " .. name .. " = " .. persistence[transient.name].vars[name])

  else
    if name:sub(1,1) == "!" then
      name = name:sub(2)
      bool = not bool
    end

    if persistence[transient.name].vars[name] ~= bool then
--      print("set " .. name .. " = " .. tostring(bool))
      audio.play "schwupp"
      persistence[transient.name].vars[name] = bool
    end
  end
end

function getVar (name)
  local leer = name:find(" ")
  if name:find(" ") then
    return getVar(name:sub(1, leer-1)) or getVar(name:sub(leer+1))
  end

  local not_ = name:sub(1,1) == "!"
  if not_ then name = name:sub(2) end

  local val = persistence[transient.name].vars[name]
  local t = type(val)

  if     t == "nil" then     return not_
  elseif t == "boolean" then return val == not not_
  elseif t == "number" then  return (val <= 0) == not not_ end

  print("getVar: error " .. tostring(val) .. " is neither nil, bool or number")
end

