types = {}

local empty = {}
function setType (o, type)
  local old_type = types[o.type]
  if old_type ~= nil then
    for i = 1, #old_type do
      if old_type[i] == o then
        old_type[i] = empty
        break
      end
    end
  end

  o.type = type
  local need_new = true
  for i = 1, #types do
    if types[i] == empty then
      need_new = false
      types[i] = o
      break
    end
  end
  if need_new then table.insert(types[type], o) end

  return o
end

