--- Entities
-- An entity is a table with the following primary attributes: <ul>
-- <li> name :string? <br>either nil, or a unique string used to identify the element.
-- <li> x,y :number <br>position of the lower center point of the collision rectangle
-- <li> vx,vy :number <br>velocity is added each frame to the position
-- <li> width,height :number <br>size of collision rectangle
-- <li> ix,iy :number <br>image offset (& rotation center)
-- <li> r :number? <br>rotation in radians, the special values: nil and math.infinity mean unrotated
-- <li> alpha :number <br>opacity value from 0 to 255, where 0 means transparent.
-- <li> disabled :boolean <br>disabled entities are ignored and thus neither updated nor drawn
-- <li> timer :number
--      a countdown to be used in behavior logic.
-- </ul>
--
-- The following attributes are set by the physics system and used everywhere
-- it deems useful:<ul>
-- <li> wall, water, ground :boolean <br>whether this frame a wall is touched,
--      water is touched, ground is touched.
-- <li> facing :number <br> to be used to determine direction during standing.
--      -1 for left, +1 for right.
-- </ul>

local M = {}

local default_obj = {
  name='',

  x=0, y=0, vx=0, vy=0,
  width=13, height=14,
  ix=10, iy=19, -- ox, oy,

  r = math.huge, alpha = 255,

  timer=0, disabled=false,
  wall=false, water=false, ground=false, facing=1,
}

--- Turn an entity into a compressed-entity, which takes less space.
-- Warning compressed-entity cause errors with most methods,
-- that expect an entity. Ensure that all entities are decompressed before use.
function M.compress (o)
  if o.ox == o.width/2  then o.ox = nil end
  if o.oy == o.height-1 then o.oy = nil end
  for k,v in pairs(default_obj) do
    if o[k] == v then o[k] = nil end
  end
end

--- Turn a compressed-entity into an entity. (See compress.)
function M.decompress (o)
  for k,v in pairs(default_obj) do
    if o[k] == nil then o[k] = v end
  end
  if o.ox == nil then o.ox = o.width/2  end
  if o.oy == nil then o.oy = o.height-1 end

  if o.properties == nil then o.properties = {} end
end

return M
