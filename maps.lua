local g = love.graphics

-- TODO refactor into state.const, transient and persistent
-- TODO or maybe not

map = nil
types = nil
avatar = nil
solidmap = false
watermap = false
state = nil

persistence = {}

local is_transient_type = {
  TABLET=1, SHIELD=1, GRID=1, META=1,
  GRASS=1, RUBY1=1, HEART=1, ARROWS=1,
  SLIME=1, ESLIME=1, FISH=1, FISH2=1,
  ELECTRO=1, ARROW=1, SWORD=1,
  REMOVED=1,
}

function change_level (name, x, y)
  change_level_timer = 100

  do -- clear transient data of old level
    if state then
      -- remove type=="REMOVED" for real and clean rest
      local i=#state.pool
      while i>0 do
        local o = state.pool[i]
        if is_transient_type[o.type] then
          table.remove(state.pool, i)
          i = i-1
          if state.avatar_index > i then
            state.avatar_index = state.avatar_index-1
          end

        else
          i = i-1
          clean_obj(o)
        end
      end
    end

    -- type cache
    types = {META={}, REMOVED={}}
    for i,s in ipairs(sprites) do types[s] = {} end

    -- layer cache
    tiled.clear_layers()

    -- control, walking and swimming
    avatar = nil
    solidmap = false
    watermap = false
  end

  do
    -- create transient data and default state of new level 
    local default_state
    map, default_state = load_map(name)

    -- try loading or use default
    local save = persistence[name]
    print(name, serialize(persistence))
    state = save and save or default_state
    persistence[name] = state

    -- change music
    audio.music(map.properties.landmusic or "Ruins")

    -- change avatar
    avatar = state.pool[state.avatar_index]
    if x then avatar.x = x end
    if y then avatar.y = y end

    -- adjust camera
    change_screensize()

    table.foreachi(state.pool, unclean_obj)

    for i,layer in ipairs(map.layers) do
      if layer.type == "objectgroup" then

        table.foreachi(layer.objects, unclean_obj)

      elseif layer.type == "tilelayer" then
        -- layer cache
        tiled.layer_init(layer)

        -- walking and swimming
        if     layer.name == "Ground" then solidmap = layer.data
        elseif layer.name == "Water"  then watermap = layer.data end
      end
    end
  end
end

function load_map (src)
  local default_state = { 
    vars = {}, -- game logic variables
    pool = {}  -- obj pool
  }

  local map = assert(love.filesystem.load("maps/" .. src .. ".lua"))()

  -- add usefull attributes
  map.name = src

  -- build default vars
  for k,v in pairs(map.properties) do
    default_state.vars[k] = assert(loadstring("return " .. v))()
  end

  -- adapt objs and extract the persistent objs into default_pool
  for i,layer in ipairs(map.layers) do
    if layer.type == "objectgroup" then

      local objs = {}

      for j, o in ipairs(layer.objects) do
        -- convert gid (number) to type (string)
        o.type = o.gid and (sprites[o.gid] or "DUMMY") or "META"

        -- offset objects
        if o.width == 0 then -- TODO why this condition?
          o.x = o.x + tw/2
          o.y = o.y - 1
          o.width = 13
          o.height = o.type=="GRID" and 18 or 15
          o.ox = o.width/2
          o.oy = o.height+1
        end

        -- clean tiled-specific attrs
        o.gid = nil
        o.shape = nil
        o.visible = nil

        -- init and freeze
        init_obj(o)

        -- transient or persistent?
        local tab = is_transient_type[o.type] and objs or default_state.pool
        local index = #tab+1
        tab[index] = o

--        -- find avatar
--        if o.type:sub(1,4) == "RINK" then print("found") default_state.avatar_index = index end
      end

      map.layers[i] = {type="objectgroup", opacity=1, objects=objs}

    elseif layer.name == "Water" then
      layer.properties.parallax_x = 0.4
      layer.properties.parallax_y = 0.2
      layer.opacity = 0.5
    end
  end

  -- ensure the existence of an avatar
  if not default_state.avatar_index then
    print("overwritten") 
    local index = #default_state.pool+1
    default_state.avatar_index = index
    local o = {
      type = "RINK",
      x = 260, y = 100,
      width = 12, height = 20, ox = 6, oy = 20,
    }
    o.properties = {}
    init_obj(o)
    default_state.pool[index] = o
  end

  return map, default_state
end

function change_screensize (zoom)
  local fs = love.window.getFullscreen()
  w = fs and g:getWidth() or 800
  h = fs and g:getHeight() or 400

  camera = { zoom = zoom or h/12/20 }

  cam_min_x = w / camera.zoom / 2
  cam_min_y = h / camera.zoom / 2
  cam_max_x = map.width * map.tilewidth - cam_min_x
  cam_max_y = map.height * map.tileheight - cam_min_y

  camera.x = clamp(cam_min_x, avatar.x, cam_max_x, true)
  camera.y = clamp(cam_min_y, avatar.y, cam_max_y, true)
end

function add_obj (type, x, y, vx, vy)
  -- resuse one of the removed or delete
  local o
  for k,v in pairs(types.REMOVED) do
    o = init_obj(k, type)
    break
  end
  if not o then
    o = init_obj({}, type)
    table.insert(state.pool, o)
  end

  o.x, o.y = x, y
  if vx then o.vx = vx end
  if vy then o.vy = vy end

  return o
end

function del_obj (o)
  setType(o, "REMOVED")
end

function init_obj (o, type)
  -- create transient data
  clean_obj(o)
  unclean_obj(nil, o, nil, type)

  unfreeze(o)

  -- persistent data
  o.timer = 0
  o.x, o.y = o.x or 0, o.y or 0
  o.disabled = false
  o.properties = o.properties or {}

  freeze(o)

  return o
end

-- remove transient data
function clean_obj (o)
  unfreeze(o)

  o.vx, o.vy = nil, nil
  o.ox, o.oy = nil, nil
  o.ix, o.iy = nil, nil
  o.width, o.height = nil, nil

  o.r = nil
  o.alpha = nil

  o.wall, o.water, o.ground = nil, nil, nil
  o.facing = nil
end

-- create transient data
function unclean_obj (i, o, _, type)
  unfreeze(o)

  if o.type == nil and type == nil then error() end
  type = type or o.type or "DUMMY"
  setType(o, type)

  o.vx, o.vy = 0, 0
  o.width, o.height = 15, 20
  o.ix, o.iy = 10, 19
  o.ox, o.oy = o.width/2, o.height-1

  o.r = math.huge
  o.alpha = 255

  o.wall, o.water, o.ground = false, false, false
  o.facing = 1

  freeze(o)
end

function unfreeze (o)
  setmetatable(o, {})
end

function freeze (o)
  setmetatable(o, {__newindex=function (self, key, val)
    error("tried to change " .. make_key(key) .. " = " .. serialize(val) .. " of frozen ".. serialize(self), 2)
  end})
end

--function copy_obj (o)
--  print("copy_obj")
--  local new = {}
--  init_obj(new, o.type)

--  print("old", serialize(o))
--  for k,v in pairs(o) do new[k] = v end
--  for k,v in pairs(o.properties) do new.properties[k] = v end

--  return new
--end
