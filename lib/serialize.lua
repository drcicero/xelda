--- Serializing
-- TODO: make serialize respect same objs

local serialize
local function make_key (it, indent)
  return (
     -- if its a string of alphanumeric chars or the underscore leave it,
     type(it) == "string" and it:match("[%w_]+") ~= nil and it
     -- else wrap it in brackets and serialize it.
     or "[" .. serialize(it, nil, indent) .. "]"
  )
end

local function quote (it)
  return ("%q"):format(it)
end

---
-- return a serialization of 'it'.
--
-- 'it, replace=nil, indent=false, ancestors={}, path=""'
--
-- returns 'replace(it, path, indent, ancestors, replace)', if replace is not nil and its result is not nil.
-- ancestors will be made into comments and warnings.
-- path is a space seperated string of keys that lead to the current it.
function serialize(it, replace, indent, ancestors, path)
  indent    = type(indent) == "string" and indent
              or indent and "\n" or ""
  ancestors = ancestors or {}
  path      = path or ""

  if replace then
    local do_replace, result = replace(
      it, path, indent, ancestors, replace)
    if do_replace then return result end
  end

  local t = type(it)

  if t == "number"
  or t == "boolean"
  or t == "nil" then
    return tostring(it)

  -- ignore functions and userdata
  elseif t == "function"
  or t == "userdata" then
    print("serialize: bad type, " .. t .. " at " .. path)
    return "nil"

  elseif t == "string" then
    return ("%q"):format(it)

  elseif t == "table" then
    local next_indent, sep
    if indent == "" then
      next_indent, sep, eq = "", ",", "="
    else
      next_indent, sep, eq = indent .. "  ", ", ", " = "
    end

    -- check for circular references
    for i, ancestor in ipairs(ancestors) do
      if it == ancestor then
        print("serialize: warning self reference in " .. path)
        return "nil --[[circular reference to " .. #ancestors-i .. "th ancestor]]"
      end
    end
    table.insert(ancestors, it)


    -- the array part
    local subtabs = false
    local len, tmp = #it, {}
    for i=1, len do
      subtabs = subtabs or type(it[i]) == "table"
      tmp[i] = serialize(it[i], replace, next_indent,
        {unpack(ancestors)}, path.."/"..i)
    end
    local arr = table.concat(tmp, sep)

    -- the rest
    tmp = {}
    local i = 1
    for key, val in pairs(it) do
      -- only the rest
      if type(key) ~= "number" or key > len or key <= 0 then
        key = make_key(key, next_indent)
        val = serialize(val, replace, next_indent,
          {unpack(ancestors)}, path.."/"..key)

        if key == "[nil]" then
          print("serialize: bad key, in ".. key .. eq .. val)

        else
          -- give special keys their own line
          key = key:sub(1,1) == "[" and next_indent .. key or key
          if val ~= "nil" then
            tmp[i] = key .. eq .. val
            i = i + 1
          end
        end
      end
    end
--    table.sort(tmp) -- make output consistent, equatable
    local dict = table.concat(tmp, "," .. next_indent)
    dict = dict == "" and "" or
      next_indent .. dict .. indent

    return "{" .. (
      arr ~= "" and dict ~= ""
      and next_indent .. arr .. ","
      or arr
    ) .. dict .. "}"

  else
    print("serialize: bad type, " .. t .. " at " .. path)
    return "nil"
  end
end

--- print the array elements of 'tab', seperated by 'tab.sep' or space, append 'tab.stop' or newline.
local function pprint(tab)
  local sep = tab.sep or " "
  local stop = tab.stop or "\n"
  io.write(serialize(tab[1], nil, true))
  for i=2, #tab do io.write(sep .. serialize(tab[i], nil, true)) end
  io.write(stop)
end

return {serialize=serialize, quote=quote, make_key=make_key, pprint=pprint}
