local audio = require "audio"

local pool = require "pool"
local camera = require "map.camera"
local scripting = require "map.scripting"
local dialog = scripting.dialog

function shock(dur, rad)
  audio.play "hit"
  sceneclock.add {dur=dur, ease="Deccel", f=function (t)
    camera.x = camera.x + rad * 2*(math.random()-.5) * (1-t)
    camera.y = camera.y + rad * 2*(math.random()-.5) * (1-t)
  end}
end


function schnorch (avatar)
  audio.play "hah"
  local schnorch = pool.spawn("Z", avatar.x, avatar.y)
  schnorch.vx = math.random()*4-1
  schnorch.vy = math.random()*-.5-.5
  schnorch.gravity = 0.02
  schnorch.airfriction = 0.9
  local tween = sceneclock.add {}
  local rnd = math.random() * math.pi * 2
  tween.f = function (x)
    schnorch.r = 0.1 * math.sin(rnd + math.pi*x) * math.pi

    schnorch.alpha = schnorch.alpha - 3
    if schnorch.alpha == 0 then
      pool.del(schnorch)
      sceneclock.del(tween)
    end
  end
end


return {
  focus = function ()
    scripting.cutscene("hello", function ()
      local rink = avatar
      local accumulator = 0
      local sleepytween = sceneclock.add {f=function (x)
        rink.r = (-0.4 + 0.015*math.sin(math.pi*x/2))*math.pi
        if x > accumulator then
          schnorch(rink)
          accumulator = accumulator + 1
        end
      end}

      fairy = pool.spawn("FAIRY", 160, 90)
      fairy.properties.image = "Watson"
      fairy.gravity = 0
      scripting.wander_by(fairy, -60, -20)

      dialog(fairy, "Good Morning, Rink.")
      dialog("\nI was sent by the king. He wants to see you.")
      schnorch(rink)
      dialog(fairy, "It is a matter of death and light...         of darkness...       and life...")
      schnorch(rink)
      dialog("\nListen!      Hey!      Wakeup!     LISTEN!       ...       ...       ...         !")
      schnorch(rink)

      shock(3, 10)
      sceneclock.del(sleepytween)

      rink.vx, avatar.vy = 7, -6
      rink.r = math.huge
      rink.gravity = nil
      audio.play "explosion"
      rink.type = "SLEEPY_RINK"
      audio.music(nil, "default")
      dialog(fairy, "THE PRINCESS WAS KIDNAPPED!")

      dialog(fairy, "Phew. Follow me.")
      scripting.wander_by(fairy, 60, 20)
      pool.del(fairy)

--      rink.vx = 4
    end)
  end
}
