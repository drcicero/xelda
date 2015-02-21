local objs = require "map.objs"
local scripting = require "map.scripting"

return {
  focus = function ()
  cutscene("hello", function()
    local fairy = objs.spawn("FAIRY", 26.5*20, 11*20)
    fairy.properties.image = "Watson"
    fairy.gravity = 0

    local tmp = avatar
    avatar = fairy

    scripting.wander_by(fairy, -200, -40)
    scripting.dialog(fairy, "Oh no, its already dark outside...\n                      Follow me, quick!")

    avatar = tmp
    objs.del(fairy)
  end) end,
}

