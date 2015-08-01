local pool = require "pool"
local scripting = require "map.scripting"

return {
  focus = function ()
  scripting.cutscene("hello", function()
    local fairy = pool.spawn("FAIRY", 26.5*20, 11*20)
    fairy.properties.image = "Watson"
    fairy.gravity = 0

    local tmp = avatar
    avatar = fairy

    scripting.wander_by(fairy, -200, -40)
    scripting.dialog(fairy, "Oh no, its already dark outside...\n                      Follow me, quick!")

    avatar = tmp
    pool.del(fairy)
  end) end,
}

