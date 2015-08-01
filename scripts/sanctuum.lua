local cron = require "cron"
local audio = require "audio"

local sfx = require "sfx"
require "game.collision"
local state = require "state"

local pool = require "pool"
local maps = require "map.maps"
local scripting = require "map.scripting"
local byId, dialog = scripting.byId, scripting.dialog


local nonag
local nonagimg = love.graphics.newImage("assets/nonag.png")
local nonagw, nonagh = nonagimg:getWidth(), nonagimg:getHeight()
local nquad = {
  love.graphics.newQuad(0,0, 40,40, nonagw, nonagh),
  love.graphics.newQuad(40,0, 40,40, nonagw, nonagh),
  love.graphics.newQuad(80,0, 40,40, nonagw, nonagh)
}


local M = {
  funcs = {},

  draw = function ()
    if nonag then
      local z = nonag.z or 1
      love.graphics.setColor(0,0,0,nonag.alpha)
      love.graphics.draw(nonagimg, nquad[nonag.ai],
        nonag.x, nonag.y, 0, z, z, nonag.ox, nonag.oy)
    end
  end,

  focus = function ()
    scripting.cutscene("init", function ()
      nonag = nil

      local sword_ = byId("sword", nil, true)
      sword_.y = sword_.y + 12
      sword_.ix = 10; sword_.iy = 10
      sword_.ox = 10; sword_.oy = 10
      sword_.properties.ghost = true
	
      byId("mid").properties.onfirsttouch = "$read"
      byId("drawing").properties.onfirsttouch = "$drawing"

      local fairy = pool.spawn("FAIRY", 40.5*20, 9*20)
      pool.setId(fairy, "fairy")
--      fairy.type = "TABLET"
--      fairy.properties.text = "Why did the King summon his archenemy Nonag? That does not make any sense."
      fairy.properties.image = "Watson"
      fairy.gravity = 0

      local king = byId("king")
      king.properties.image = "King"

      scripting.wander_by(fairy, -8*20, 0, true)
--      wander_by(fairy, -4*20, 0)
--      dialog(fairy, "Here you can read the saga.")
--      wander_by(fairy, -4*20, 0, true)
    end)
  end
}


local function shock (nonag, o, x, y, test)
  audio.play "bigroar"

  local num = 5*2
  for i=1,num do
    sceneclock.add {dur=i*0.2, ended=function ()
      nonag.ai = nonag.ai == 2 and 3 or 2
      if i%2==0 then
        o.vx = test and 6 or i%4==0 and 10 or -10
        o.vy = test and -7 or -5

        local m = pool.spawn("LIGHT", nonag.x, nonag.y)
        m.properties.ghost = true
        m.vx = math.sin(i/num*math.pi*2)*10
        m.vy = math.cos(i/num*math.pi*2)*10
        audio.play("electro2")

        sceneclock.add {f=function (t)
          if m.timer < 0 then
            sfx.spawn_fluff(m.x,m.y, 200,10,10, 5)
            audio.play("electro", m.x, m.y)
            m.timer = math.random()*20+20
          end
          local l = .2 * math.min(t*t, 1); local k = 1-l
          m.vx = k*m.vx + l*((o.x+20*math.sin(math.pi*2*(t-i*0.2))) - m.x)
          m.vy = k*m.vy + l*((o.y+20*math.cos(math.pi*2*(t-i*0.2))) - m.y)
        end, ended=function() pool.del(m) end}
      end
    end}
  end
  sceneclock.add {dur=num*0.2+0.1, ended=scripting.resume}
  coroutine.yield()

  o.gravity = 0
  o.vy = 0
  local ox, oy = o.x, o.y
  sceneclock.add {dur=1, ease=cron.ease.Swing,
    f=function (t)
      o.x = ox + math.sin(math.pi*4*t) +(x-ox)*t
      o.y = oy + math.sin(math.pi*2*t) +(y-oy)*t
    end, ended=scripting.resume}
  coroutine.yield()
end


function M.funcs.read () scripting.cutscene("greeting", function ()
  local fairy, king = byId("fairy"), byId("king")
--  dialog(fairy, "The king sent for you, because...\n                     you are an ancestor of the hero.")
  scripting.wander_by(fairy, -7*20, 0)

  dialog(fairy, "Oh, here you are, my lord.")

  local rink = avatar
  avatar = byId("king")
  dialog(king, "Yes, do have an idea how long you took?")

  dialog(king, " Anyway, Good that you are here now, Rink.")
  dialog(king, "Actually i wanted to tell it more softly to you.")
  dialog(" But this moring - Well there was no 'morning'.")
  dialog(king, "The sun vanished!")
  dialog("\nYou see: We have to hurry!")
  dialog(king, "I read some history books and calculated by a certain chance that you are an ancestor of the GREEN ONE.")
  dialog(king, " But we have to be sure!")

  dialog(king, " According to the legend this is how we can decide, whether you really are THE GREEN ONE or not.")
  dialog(king, "This shall be the test:\nOnly the GREEN ONE can draw the sword out of the stone.")
  avatar = rink

  local sword_ = byId("sword")
  scripting.wander_by(fairy, sword_.x-fairy.x-40, sword_.y-10-fairy.y, true)
end) end


function M.funcs.drawing () scripting.cutscene("drawing", function ()
  local fairy, king, sword_ = byId("fairy"), byId("king"), byId("sword")

  avatar.vx = 0
  dialog(fairy, "Yes, Rink, go try it! Nobody tried... er... could do it until now.")
  audio.music("Xelda", "default")
  state.vars.sword = true
  sceneclock.add {dur=2, f=cron.by(sword_, "y", -10), ease=cron.ease.Accel, ended=scripting.resume}
  coroutine.yield()
  sceneclock.add {dur=2, f=cron.by(sword_, "r", 1*math.pi)}
  sceneclock.add {dur=2, f=cron.by(sword_, "x", 10), ended=scripting.resume}
  coroutine.yield()

  audio.play "hah"
  pool.del(byId "sword")
  avatar.type = "SLEEPY_RINK_ATTACK2"
  dialog(fairy, "Congratulations, GREEN ONE!")
  avatar.type = "SLEEPY_RINK"

  audio.music(nil, "default")
  audio.play("explosion", nil, nil, nil, .5)
  local moon = byId "moon"
  local moonx, moony = moon.x, moon.y
  sfx.spawn_feuerwerk(moonx,moony, 200,200,100, 20)
  pool.del(moon)

  for o,_ in pairs(transient.types.TOP_LAMP) do
    o.properties.ghost = nil
  end

  sfx.shake(5, 10)
  dialog(fairy, "Oh my, lord! The moon!!!")
  dialog("\nWhat was that???")

  local xelda = pool.spawn("XELDA", 28*20, 10*20-1)
  pool.setId(xelda, "xelda")
  xelda.properties.image = "Xelda"
  xelda.facing = -1
  xelda.vx = -1
  sceneclock.add {dur=1, f=cron.to(xelda, "x", 19*20), ended=scripting.resume}
  coroutine.yield()

  xelda.facing = 1
  dialog(xelda, "Dad, are you ok? There was this earthquake...")
  sceneclock.add {dur=0.5, ended=scripting.resume, f=cron.by(xelda, "x", -10)}
  coroutine.yield()

  sceneclock.add {dur=0.1, ended=scripting.resume, f=cron.by(king, "x", -10)}
  coroutine.yield()
  sceneclock.add {dur=0.1, ended=scripting.resume, f=cron.by(king, "x", 10)}
  coroutine.yield()
  sceneclock.add {dur=0.1, ended=scripting.resume, f=cron.by(king, "x", -10)}
  coroutine.yield()
  sceneclock.add {dur=0.1, ended=scripting.resume, f=cron.by(king, "x", 10)}
  coroutine.yield()

  dialog(king, "No! Xelda, what are you doing here?")
  dialog(fairy, "Xelda, oh... the sword must have freed you imidiatly.")
  dialog(xelda, "Freed from what?")
  dialog(fairy, "Er... ok, Rink, she was not kidnapped. I hope you understand.")

  nonag = pool.spawn("?", moonx, moony-20)
  sceneclock.add {f=function(t)
    sfx.spawn_fluff(nonag.x,nonag.y-20, 255,0,0, 5+math.random()*10)
  end}
  nonag.z = 0
  nonag.width = 40; nonag.height = 40
  nonag.ox = 20; nonag.oy = 40
  nonag.ai = 1
  nonag.gravity = 0
  nonag.properties.image = "Nonag"
  audio.play("explosion", nil, nil, nil, .5)
  audio.play "bigroar"
  audio.music("Raw", "default")

  dialog(nonag, "MWAHAHAHA!")
  dialog(xelda, "Dad, what is going on here?")
  dialog(king, "Damn. It worked so well. Now, Nonagdorf take him!")

  local rink = avatar
  dialog(nonag, "We had a deal - So where is THE GREEN ONE? I can not see him.")

  if not DEBUG then
    avatar = king
    sceneclock.add {dur=1, ease=cron.ease.Accel,
      f=cron.by(king, "x", 20*3), ended=scripting.resume}
    coroutine.yield()
    state.vars.avatar_name = "RINK"
    audio.play "tadadi"
    rink.type = "RINK"
    sceneclock.add {dur=1, ease=cron.ease.Deccel,
      f=cron.by(king, "x", 20), ended=scripting.resume}
    coroutine.yield()
    dialog(king, "Do you recognise him now?")
    king.facing = -1
    dialog(fairy, "What is going on, here? I dont understand?")
    dialog(nonag, "I see.\n                                   Now you will not do any damage.")

    avatar = rink
    shock(nonag, rink, 20.5*20, 6.5*20)
    avatar = xelda
    shock(nonag, xelda, 22.5*20, 7.5*20)
    dialog(xelda, "Arhg! What is going on here?")
    dialog(nonag, "MWAHAHAHA!")
    sceneclock.add {dur=0.5, ease=cron.ease.Swing,
      f=cron.by(king, "x", -10)}
    dialog(king, "Wait! What are you doing!? What about the deal? You can't take her!")

    avatar = king
    shock(nonag, king, 24.5*20, 6.5*20, true)

    dialog(nonag, "MWAHAHAHA!\n                     I take you all!")

    avatar = fairy
    dialog(fairy, "No! I cant let you do that.")
    scripting.wander_by(fairy, nonag.x-fairy.x, nonag.y-fairy.y-20)
    nonag.ai = 1

    avatar = fairy
    audio.play "bigroar"

    dialog(fairy, "Ahrg!")
    king.gravity = nil
    rink.gravity = nil
    xelda.gravity = nil
  end

  dialog(fairy, "This is your chance, GREEN ONE! Hit him with the magical sword! Do it with [space]!")
  byId("offlimits").properties.ontouch = "$throwback"
  byId("mid").properties.ontouch       = "$throwback"

  nonag.gravity = nil
  xelda.vx = 20
  xelda.vy = -6
  king.vx = -30
  king.vy = -6
  scripting.wander_by(fairy, 0, 100, true)

  avatar = rink

  state.events.once["$has_sword_hit_nonag"] = "$on_sword_hit_nonag"
end) end

function M.funcs.has_sword_hit_nonag ()
  return sword and circ_col(
    sword.x + math.cos(sword.r)*14,
    sword.y + math.sin(sword.r)*14,
    nonag.x, nonag.y-nonag.height/2,
    tw/4, tw*1.5
  )
end

function M.funcs.on_sword_hit_nonag () scripting.cutscene("on_sword_hit_nonag", function ()
  unsword()
  local nonagx, nonagy = nonag.x, nonag.y
--        if hits < 5 then
--          sceneclock.add {dur=0.5, ease=cron.ease.Accel, f=function(t)
--            nonag.x = math.sin(6*2*math.pi*t) + nonagx
--            nonag.y = math.sin(7*2*math.pi*t) + nonagy - t*2
--          end}

--        else
--          events.on[cond] = nil
  byId("offlimits").properties.ontouch = nil
  byId("mid").properties.ontouch       = nil

  local avatarx, avatary = avatar.x, avatar.y
  audio.play("explosion", nil, nil, nil, .5)
  scripting.setVar("bottom", true)
  audio.play "bigroar"
  sfx.spawn_feuerwerk(nonagx,nonagy, 255,0,0, 30)
--  coroutine.yield()

  pool.del(nonag)
  pool.del(avatar)
  nonag = nil
  avatar = fairy

  local king = byId "king"
  local xelda = byId "xelda"
  king.facing = -king.facing
  xelda.facing = -xelda.facing
  sceneclock.add {dur=2, ease=cron.ease.Swing,
    f=cron.by(king, "x", 60)}
  sceneclock.add {dur=2, ease=cron.ease.Swing,
    f=cron.by(xelda, "x", -60)}
  audio.music("Ruins", "default")

  avatar = xelda
  state.vars.avatar_name = "XELDA"
  dialog(king, "...")
  dialog(avatar, "AAAAAAAHHHHHHH!")
  dialog(king, "Puh.")
  dialog(avatar, "AAAAAAAHHHHHHH!")
  dialog(king, "Hey, calm down - That went better than I expected!")
  dialog(avatar, "AAAAAAAHHHHHHH -")
  dialog(" ... What are do you mean 'better'!?")
  dialog(" Rink is DEAD!?")

  dialog(king, "Oh, im sure they are not dead yet...")
  dialog(avatar, " Well, thats 'better', isn't it? A free, roaming MONSTER IN OUR KINGDOM!?")

  local fairy = byId "fairy"
  scripting.wander_by(fairy, -20, 20, true)
  dialog(king, "No - it is -")
  dialog(fairy, "King!")
  scripting.wander_by(fairy, -10, 10, true)
  dialog(" What have you done?")
  dialog(" I expect an explanation!")

  dialog(avatar, "Yes, Dad. What happend just now?")
  dialog(king, "Er... Yes, Xelda, I just saved your life!")
  dialog(" It's better this way, Xelda. Imagine -")

--        dialog(" Do you remember the saga of our land?")
--        dialog(king, "There is final sentence that was kept hidden from public:")
--        dialog(king, "Time passed, and the kingdom was at peace again.")
--        dialog(" Only the ocean remained restless.")
--        dialog(" For it knew, it was not the end.")
--        dialog(xelda, "... ?")
--        dialog(king, "You see? I had to do something.")

  dialog(avatar, "No! Someone has to save him.")
  dialog(king, "Wha - How? Don't do anything foolish.")
  dialog(avatar, "Ha! *draws sword*")
  dialog(avatar, "It is pretty light!")

  dialog(king, "The sword of the legend. Put it back, before...")
  dialog(avatar, "*points at him*")

  dialog(king, "Er...")
  dialog(avatar, "You're not going to do anything about it...")
  dialog(" So i am going to save Rink!")

  xelda.vx = -5
  xelda.vy = -5

  dialog(avatar, "See you later, dad.")

  xelda.r = nil
  maps.use_door_to("ice_entry")
end) end

function M.funcs.throwback (self)
  avatar.vy = -5
  avatar.vx = (self.name == "offlimits" and 1 or -1) * 10
end

return M
