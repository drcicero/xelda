function setVar (name, bool)
  if name:sub(1,1) == "-" then
    name = name:sub(2)
    if not type(state.vars[name]) == "number" then state.vars[name] = 0 end
    state.vars[name] = state.vars[name] - 1
--    print("set " .. name .. " = " .. state.vars[name])

  else
    if name:sub(1,1) == "!" then
      name = name:sub(2)
      bool = not bool
    end

    if state.vars[name] ~= bool then
--      print("set " .. name .. " = " .. tostring(bool))
      audio.play "schwupp"
      state.vars[name] = bool
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

  local val = state.vars[name]
  local t = type(val)

  if     t == "nil" then     return not_
  elseif t == "boolean" then return val == not not_
  elseif t == "number" then  return (val <= 0) == not not_ end

  print("getVar: error " .. tostring(val) .. " is neither nil, bool or number")
end

