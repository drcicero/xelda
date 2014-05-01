function setType (o, type)
  if o.type then
    types[o.type][o] = nil
  end

  types[type][o] = 1
  o.type = type

  return o
end

