--- The Gameplay Widget
--
-- implements widget from $lib.widgets
--
-- has a clock ($lib.cron)
--
-- uses $src.map.scripting
--
-- open $src.menus.pause on escape.
--
-- drawings: $src.map.draw, $src.map.camera, $src.ingamedebug
--
-- see also $src.game.update , $src.game.draw

local widgets_push = (require "widgets").push
local cron_new_clock = (require "cron").new_clock

local persistence = require "state"

local draw = require "map.draw"
local scripting = require "map.scripting"
local camera_follow = (require "map.camera").follow

local pausemenu = require "menus.pause"

local game = {
  name = "game",
  draw = require "game.draw",
}
require "game.update"
local control = require "game.control"

local g = love.graphics

change_level_timer = 0
hud_objs = {}
tw = 20
topisgame = false

bubbles = {}

---- Frame implementation

--- create a hudclock and call $src.map.draw#M.load .
function game.load (self)
  hudclock = cron_new_clock()
  draw.load(tw)
  return game
end

--- update clocks, call $src.scripting#M.update, $src.map.camera#camera.follow,
-- $src.game.update#control if topisgame. calls $src.game.update#update_obj for each obj.
function game.update (self, dt, from_draw)
  if from_draw or not DEBUG then
    bubbles = {}

    change_level_timer = change_level_timer-1

    hudclock.update()
    transient.levelclock.update()
    scripting.update()

    camera_follow(avatar)

    if topisgame then
      control()
      if pressed.escape then
        pressed.escape = false
        widgets_push(pausemenu())
      end
    end

    table.foreach(
      persistence[persistence.mapname].pool,
      update_obj )
    scripting.hook("update")

    if quit then
      local tmp = quit
      quit = nil
      tmp()
    end

  elseif not from_draw and DEBUG then
    DEBUGupdate = game.update
  end
end

--- set topisgame; $src.map.scripting hook 'focus'
function game.focus (self, e)
  topisgame = true
  scripting.hook("focus")
end

--- del topisgame; $src.map.scripting hook 'blur'
function game.blur (self, e)
  topisgame = false
  scripting.hook("blur")
end


--- pressed = {}
-- a table of key=true pairs where key is a currently pressed key
pressed = {}

--- set pressed[key] to true
function game.keypressed (self, e)  pressed[e] = true  end
--- set pressed[key] to false
function game.keyreleased (self, e) pressed[e] = false end


return game
