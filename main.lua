--- Main 
-- This is the entry point

love.graphics.setDefaultFilter("linear", "nearest")
w = love.graphics.getWidth()
h = love.graphics.getHeight()
DEBUG = false

require "saveload"
require "game"
tweens = require "tweens"
require "appstates"
mainmenu = require "mainmenu"

function love.load ()
--  -- FIXME canvas are invisible?
--   CANVAS = love.graphics.isSupported("canvas", "npot")

  audio.load()
  --tween.load()

  xelda = love.graphics.newImage "assets/xelda.png"
  watson = love.graphics.newImage "assets/watson.png"

  push_app_state(game)
  push_app_state(mainmenu.slots())
end
