--- Xeldas Saga
-- is a Action/Puzzle Platformer using the Love2d Engine.
--
-- The module $frames implements a stack of frames.
-- Eg. beginning at the top every frame decided whether it wants to bubble
-- the callback further down to the other frames.
--
-- The game is setup in #love.load , then every frame #love.draw and #love.update
-- are called.

GAME_VERSION = "0.8"
DEBUG = false

-- FIXME canvas are invisible?
-- CANVAS = love.graphics.isSupported("canvas", "npot")

love.graphics.setDefaultFilter("linear", "nearest")
w = love.graphics.getWidth()
h = love.graphics.getHeight()

package.path = package.path .. ";src/?.lua;lib/?.lua"
local app = require "frames"
local audio = require "audio"
pprint = (require "serialize").pprint

local intro = require "intro"
local camera = require "map.camera"

---
-- load audio ( $audio#M.load )
--
-- push $game.main
--
-- push $menu.slots#M.slots
function love.load ()
--  font = love.graphics.newFont(16)
  font = love.graphics.newFont("assets/slkscr.ttf", 16)
--  font = love.graphics.newFont("assets/.OpenSans.woff", 20)
  love.graphics.setFont(font)

  audio.load()
  app.push(intro)
end


local debugtimer = 0

---
function app.top.update ()
  debugtimer = debugtimer-1
  if debugtimer < 0 and pressed["d"] then
    DEBUG = not DEBUG
    debugtimer = 10
  end
end

function app.top.resize (self, x, y)
  w, h = x, y
  if transient then
    camera.resized()
    shadow = love.graphics.newCanvas(x, y)
  end
  giant = love.graphics.newFont(giantsrc, w/7)
end
