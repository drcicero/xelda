--- Xeldas Saga
-- is a Action/Puzzle Platformer using the Love2d Engine.
--
-- Essential concepts are<ul>
-- <li> 'game phases' (ex. menu, options, game) as a state-stack / (a form of a pushdown automata) (see $lib.widgets)
--  <br><small>(as gamestates work essentially like event bubbling from ui, I used the term 'widget' for both gamestates and widgets)</small>
-- <li> 'entitites' (ex. hero, slime, bush) and an pool („entity manager“) (see $src.entities and $src.pool)
-- <li> levels as a pair of:<ul>
--   <li>a 'tilemap' created with <a href=https//mapeditor.org>tiled</a>
--       <br>(see src.maps*)
--       <br>(levels are int he 'maps/' folder) and 
-- </ul>
--
-- Additional concepts<ul>
-- <li> 'tweening' / 'easing' (linear, cubic) (see $lib.cron)
-- <li> a subset of the common 'ui widgets' (ex. label, button, editfield) (see $lib.menu)
-- </ul>
--
-- The game is setup in #love.load, then every frame $main#love.draw and $main#love.update
-- are called.

GAME_VERSION = "0.8"
DEBUG = false
-- CANVAS = love.graphics.isSupported("canvas", "npot") -- FIXME bug: canvas are invisible

-- TODO fix boss
-- TODO persistence transient saveload -> state
-- TODO map.scripting -> scripting
-- TODO map.camera -> camera
-- TODO map.objs -> entities
-- TODO map -> tiled

love.graphics.setDefaultFilter("linear", "nearest")
w = love.graphics.getWidth()
h = love.graphics.getHeight()

-- local curdir = (...)[0]:match'(.*/).*'
-- FIXME bug: dont use relativ imports :(
package.path = "lib/?.lua;src/?.lua;" .. package.path

local audio = require "audio"
local widgets = require "widgets"
pprint = (require "serialize").pprint


--local info = {}
--debug.sethook(function (t)
--  if t == "call" then
--    local i = debug.getinfo(2)
--    if i.source ~= "=[C]" then
--      local c = info[i.source] or 0
--      info[i.source] = c + 1
--    end
--  end
--end, "c")


--local intro = require "intro"
local game = require "game.main"
local camera = require "map.camera"

--- init the game
function love.load ()
--  font = love.graphics.newFont(16)
--  font = love.graphics.newFont("assets/slkscr.ttf", 16)
  font = love.graphics.newFont("assets/.OpenSans.woff", 18)
  love.graphics.setFont(font)

  audio.load()

-- either:
--  widgets.push(intro)
--  widgets.push(game)
-- or:
    widgets.push(game)
    widgets.push((require "menus.slots").slots())
end

-- set all love handlers
for i,name in ipairs({
  "keypressed", "keyreleased",
  "mousepressed", "mousereleased",
  "resize", "quit",
}) do
  love[name] = widgets[name]
end

--- update game
function love.update (dt)
--  if info ~= nil then
--    pprint {"--- INFO ---"}
--    debug.sethook(nil, "c")
--    pprint {info}
--    info = nil
--  end

  if pressed.f2 then
    pressed.f2 = nil
    DEBUG = not DEBUG
  end

  widgets.update(dt)
end

--- love.draw ()
-- draw state and entities
love.draw = widgets.draw

--- handle window resize
function love.resize (x, y)
  w, h = x, y
  if transient then
    camera.resized()
    shadow = love.graphics.newCanvas(x, y)
  end
  giant = love.graphics.newFont(giantsrc, w/7)
  
  widgets.resize()
end

