function setType (o, type)
  if o.type ~= nil then
    types[type][o] = nil
  end

  o.type = type
  types[type][o] = 1

  return o
end

