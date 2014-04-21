local g = love.graphics

-- TODO REFACTOR into const, transient and persistent

map = nil
types = nil
avatar = nil
solidmap = false
watermap = false
state = nil

persistence = {}

function change_level (name, x, y)
  do -- clear transient data of old level
    -- type cache
    types = {META={}}
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
    state = save and save or default_state
    persistence[name] = state

    -- change avatar
    avatar = state.pool[state.avatar_index]
    if x then avatar.x = x end
    if y then avatar.y = y end

    -- adjust camera
    change_screensize()

    for j,o in ipairs(state.pool) do
      if o.type then types[o.type][o] = 1 end -- type cache
      map.attr[o] = {facing=1} -- transient attrs
    end

    for i,layer in ipairs(map.layers) do
      if layer.type == "objectgroup" then
        for j,o in ipairs(layer.objects) do
          if o.type then types[o.type][o] = 1 end -- type cache
          map.attr[o] = {} -- transient attrs
        end

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

local is_static_type = {
  GRASS=1,
  TABLET=1, SHIELD=1,
  SLIME=1, ESLIME=1,
  FISH=1, FISH2=1,
  GRID=1, META=1, RUBY1=1, HEART=1,
}

function load_map (src)
  local default_state = { 
    vars = {}, -- game logic variables
    pool = {}  -- obj pool
  }

  local map = assert(love.filesystem.load("maps/" .. src .. ".lua"))()

  -- add usefull attributes
  map.name = src
  map.attr = {}

  -- build default vars
  for k,v in pairs(map.properties) do
    default_state.vars[k] = assert(loadstring("return " .. v))()
  end

  -- adapt objs and extract the nonstatic objs into default_pool
  for i,layer in ipairs(map.layers) do
    if layer.type == "objectgroup" then

      local objs = {}

      for j, o in ipairs(layer.objects) do
        -- convert gid (number) to type (string)
        o.type = o.gid and (sprites[o.gid] or "DUMMY") or "META"

        -- offset objects
        if o.width == 0 then -- TODO why this condition?
          o.x = o.x + tw/2

          o.width = 13
          o.height = o.type=="GRID" and 18 or 15
          o.ox = o.width/2
          o.oy = o.height+1
          o.y = o.y - 1
        end

        -- define timer, vx, vy
        o.vx = 0
        o.vy = 0
        o.timer = 0

        -- remove superflous attributes
        o.name = o.name ~= "" and o.name or nil
        o.gid = nil
        o.shape = nil
        o.visible = nil

        -- static or dynamic?
        local tab = is_static_type[o.type] and objs or default_state.pool
        local index = #tab+1
        tab[index] = o

--        -- find avatar
--        if o.type == "RINK" then default_state.avatar_index = index end
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
    local index = #default_state.pool+1
    default_state.avatar_index = index
    default_state.pool[index] = {
      type = "RINK",
      x = 260, y = 100, vx = 0, vy = 0,
      width = 12, height = 20, ox = 6, oy = 20,
      timer = 0,
      properties = {},
    }
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
  local o

  for i,p in ipairs(state.pool) do
    if p.to_be_removed then
      o = p
      p.to_be_removed = false
      break
    end
  end

  if not o then
    o = {}
    table.insert(state.pool, o)
  end

  map.attr[o] = {}
  setType(o, type)
  o.timer = 0
  o.x = x
  o.y = y
  o.width = 15
  o.height = 20
  o.ox = o.width/2
  o.oy = o.height+1
  o.vx = vx or 0
  o.vy = vy or 0
  o.alpha = nil
  o.r = nil
  o.properties = {}

  return o
end

function remove (o)
  o.to_be_removed = true
  map.attr[o] = nil
  types[o.type][o] = nil
end
