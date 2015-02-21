--- This is a module

local app = require "frames"
local audio = require "audio"

local clamp = require "clamp"
local game = require "game.main"
local slots = require "menus.slots"

local m = {}

text = {
  "",
  "Once upon the time there was a kingdom.", --  "there was a kingdom holding a great power.",

  "The people were at peace, and nature was, too.", --  "there was a kingdom holding a great power.",
  "But there was an artifact, to grant its owner any wish.",

  "One fateful day the sky turned black.",
  "Evil itself sought after the power.", --" and nothing stood its way.",

  "And as man despaired under an endless eclipse,",
  "A boy in Green appeared to challenge the darkness.", --  from head to toe

--  "His only wish to restore the light,",
  "And he banished the Evil from the grounds and Light returned.", -- the grounds man walked
  "The imprisoned Evil raged and earth trembled in fear.",

  "Time passed, and the kingdom was at peace again.",
  "Only the ocean remained restless.",

--  "For it knew, it was not the end of the Evil.",

--  "This is the saga of our land, that was passed over for generations.",
--  "But the time has come to give birth to another legend.",

--  "They may or may not have lived happily ever after (depending on circumstances).",
}

local start = now
local dur = 5
local time = #text * dur
local title = {
  love.graphics.newImage("assets/title_1.png"),
  love.graphics.newImage("assets/title_2.png"),
  love.graphics.newImage("assets/title_3.png"),
  love.graphics.newImage("assets/title_4.png"),
  love.graphics.newImage("assets/title_5.png"),
  love.graphics.newImage("assets/title_6.png"),
}
function m.load()
  audio.music "Ruins"
end

function end_intro()
  app.pop()
  app.push(game)
  app.push(slots.slots())
end

local x = false
function m.update(self)
  if love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
    end_intro()
  end

  local delta = now-start

  if delta > 4.2 * dur and not x then
    audio.play("explosion")
    audio.play("explosion", nil, nil, nil, .2)
    x = true

  elseif delta > time+dur then
    end_intro()
  end
end

function m.draw(self)
  local delta = now-start
  local T = delta * #text / time
--  print(T)
  local t = T <= 1 and T or T >= 12 and 1-(T-12) or 1
  love.graphics.setColor(255,255,255, 255 * t)
  love.graphics.setScissor(w/2-200, 0, 400, h)


  local t = T/2 % 1
  if T > 1 and T < 12 then
    t = t>.5 and 1 or 2*t
    t = t*t*(3-2*t)
  else t = 0 end
  love.graphics.draw(title[ clamp(1, math.ceil(T/2-1), #title) ],
    w/2-200 - t*400, h/2-title[1]:getHeight()/2)
  love.graphics.draw(title[ clamp(1, math.ceil(T/2), #title) ],
    w/2+200 - t*400, h/2-title[1]:getHeight()/2)
  love.graphics.setScissor(0, 0, w, h)

  local t = T % 1
  t = t<.2 and 5*t or t>.8 and 5*(1-t) or 1
  love.graphics.setColor(255,255,255, 255 * t)
  love.graphics.setFont(font)
  love.graphics.printf(
    text[math.ceil(T)] or "",
    w/3, h-font:getHeight()*5, w/3, "center")
end

return m
