local camera = {}

local clamp = require "clamp"


local function point_in_rect (p, r)
  return r.x < p.x and p.x < r.x + r.width
     and r.y < p.y and p.y < r.y + r.height
end

local function set_zone(avatar)
  if transient.zones then
    local o = transient.zone
    if o==nil or not point_in_rect(avatar, o) then
      for i,z in pairs(transient.zones) do
        if point_in_rect(avatar, z) then
          o, transient.zone = z, z
        end
      end
    end
    if o == nil then
      print("OMFG: no zone")
      return
    end

--    extrema = o.properties.use_min and math.min or math.max
    camera.zoom = math.max(h/o.width, h/o.height) * .9
    camera.w = w /camera.zoom
    camera.h = h /camera.zoom
    camera.min_x = o.x + camera.w/2
    camera.min_y = o.y + camera.h/2
    camera.max_x = o.x + o.width - camera.w/2
    camera.max_y = o.y + o.height - camera.h/2

  else
    camera.zoom = h/240
    camera.w = w /camera.zoom
    camera.h = h /camera.zoom
    camera.min_x = camera.w/2
    camera.min_y = camera.h/2
    camera.max_x = transient.width*transient.tilewidth - camera.w/2
    camera.max_y = transient.height*transient.tileheight - camera.h/2
  end
end


--- center on obj
function camera.jump(obj)
  set_zone(obj)

  camera.x = clamp(camera.min_x, obj.x, camera.max_x, true)
  camera.y = clamp(camera.min_y, obj.y, camera.max_y, true)
end


--- follow obj
function camera.follow(obj)
  set_zone(obj)

  local x = clamp(camera.min_x, obj.x, camera.max_x, true)
  local y = clamp(camera.min_y, obj.y, camera.max_y, true)
  camera.x = camera.x + (x - camera.x) /12
  camera.y = camera.y + (y - camera.y) /24
end


--- adapt camera to different screensize
function camera.resized ()
  camera.jump(avatar)
end


--- make objs that left the camera, enter on the other side
function camera.wrap (obj)
  local cam_x, min_x, cam_y, min_y =
    camera.x, camera.min_x, camera.y, camera.min_y

  if     obj.x < cam_x-min_x then obj.x = cam_x+min_x
  elseif obj.x > cam_x+min_x then obj.x = cam_x-min_x end
  if     obj.y < cam_y-min_y then obj.y = cam_y+min_y
  elseif obj.y > cam_y+min_y then obj.y = cam_y-min_y end
end


return camera
