local camera = {}

local clamp = require "clamp"


local function find_zone(avatar)
  if transient.zones then
    local o = transient.zone
    if not (o and o.x < avatar.x and avatar.x < o.x + o.width
    and o.y < avatar.y and avatar.y < o.y + o.height) then
      for i,o in pairs(transient.zones) do
        if o.x < avatar.x and avatar.x < o.x + o.width
        and o.y < avatar.y and avatar.y < o.y + o.height then
          transient.zone = o
        end
      end
    end

    o = transient.zone
--    if o.properties.use_min then
--      extrema = math.min
--    else
--      extrema = math.max
--    end

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
  find_zone(obj)

  camera.x = clamp(camera.min_x, obj.x, camera.max_x, true)
  camera.y = clamp(camera.min_y, obj.y, camera.max_y, true)
end


--- follow obj
function camera.follow(obj)
  find_zone(obj)

  camera.x = camera.x + (clamp(
    camera.min_x, obj.x, camera.max_x, true) - camera.x) / 12
  camera.y = camera.y + (clamp(
    camera.min_y, obj.y, camera.max_y, true) - camera.y) / 24
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
