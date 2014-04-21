local make_key, serialize

function make_key (it, indent)
  indent = indent or ""
  return (
     -- if its a string of alphanumeric chars or the underscore leave it,
     type(it) == "string" and it:match("[%w_]+") ~= nil and it
     -- else wrap it in brackets and serialize it.
     or "[" .. serialize(it, nil, indent) .. "]"
  )
end

local newline = "\n"
local default_indent = "  "

function serialize(it, replace, indent, ancestors, path)
  indent    = indent or ""
  ancestors = ancestors or {}
  path      = path or ""

  if replace then
    local do_replace, result = replace(it, path, indent, ancestors, replace)
    if do_replace then return result end
  end

  local t = type(it)

  if t == "number"
  or t == "boolean"
  or t == "nil" then
    -- simple conversion
    return tostring(it)

  elseif t == "function"
  or t == "userdata" then
    -- cannot serialize functions or userdata
    print("serialize: warning " .. t .. " at "..path)
    return "nil"

  elseif t == "string" then
    -- escape and wrap it in quotes
    return ("'" ..
      it:gsub("\\", "\\\\")
        :gsub("'", "\\'")
        :gsub("[\a\t\f\v\n]", {["\a"]="\\a", ["\t"]="\\t", ["\f"]="\\f", ["\v"]="\\v", ["\n"]="\\n"})
    .. "'")

  elseif t == "table" then
    -- check for circular references
    for i, ancestor in ipairs(ancestors) do
      if it == ancestor then
        print("serialize: warning self reference in " .. path)
        return "nil --[[circular reference to " .. #ancestors-i .. "th ancestor]]"
      end
    end
    table.insert(ancestors, it)

    -- the array part of the table
    local array_part, shortcut = {}, true
    local table_in_array = false
    for i, val in ipairs(it) do
      local x
      if type(val) ~= "table" then
        x = serialize(val, replace, "", {unpack(ancestors)}, path.." "..i)
      else
        table_in_array = true
        x = serialize(val, replace, indent .. default_indent, {unpack(ancestors)}, path.." "..i)
      end
      if x == nil then
        shortcut = false
        break
      end
      array_part[i] = x
    end
    array_part = shortcut and table.concat(array_part, ", ") or ""

    -- other dict part of the table
    local dict_part, i = {}, 1
    local len = #it
    for key, val in pairs(it) do
      if not shortcut or type(key) ~= "number" or key > len or key <= 0 then
        key = make_key(key, indent .. default_indent)
        if key == "[nil]" then
          print("serialize: that was an unserializable key")

        else
          if key:sub(1,1) == "[" then key = newline .. indent .. default_indent .. key end
          local val = serialize(val, replace, indent .. default_indent, {unpack(ancestors)}, path.." "..key)
          if val ~= "nil" then
            dict_part[i] = key .. " = " .. val
            i = i+1
          end
        end
      end
    end

    table.sort(dict_part) -- ?

    dict_part = i == 1 and "" or
      newline .. default_indent .. indent .. table.concat(dict_part, "," .. newline .. default_indent .. indent) .. newline .. indent

    local both = array_part ~= "" and dict_part ~= ""
    return "{" ..
      ((both or table_in_array) and newline .. default_indent .. indent or "") ..
      array_part ..
      (both and "," or "") ..
      dict_part ..
    "}"

  else
    print("serialize: warning type of arg#1 is neither of nil, number, boolean, function, userdata or table but " .. t)
    return "nil"
  end
end

function pprint(tab)
  local sep = tab.sep or " "
  local stop = tab.stop or "\n"
  io.write(serialize(tab[1]))
  for i=2, #tab do io.write(sep .. serialize(tab[i])) end
  io.write(stop)
end

return serialize
