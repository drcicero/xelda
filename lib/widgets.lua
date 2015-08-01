--- State-Stack („Pushdown Automata“)
-- Manage an stack of widgets by wrapping some of the love.*
-- callbacks. Every time one of these callbacks is called, the method of the
-- top widget is called. If he returns true, the call bubbles down.
--
-- Additionally you can specify an super fram 'app.top', which is always called
-- first, before the stack. You can $lib.frames#M.push and $lib.frames#M.pop frames.
--
-- A 'widget' is a table with the following optional 10 methods:
--
-- - 'load', 'blur': see $lib.frames#M.push .
--
-- - 'quit', 'focus': see $lib.frames#M.pop .
--
-- - 'update', 'draw': called once per frame
--
-- - 'keypressed', 'keyreleased', 'mousepressed', 'mousereleased': event callbacks.

local M = {}
local stack = {}
M.stack = stack

M.timestep = false
now = 0

local accumulator = 0
local framerate = 1/60

local function rawupdate (...)
  for i = #stack, 1, -1 do local state = stack[i]
    if state.update then
      local nobubble = state:update(...)
      if nobubble==true then break end
    end
  end
end


--- 'blur' top frame. 'load' and push new frame.
function M.push (new_state)
  local top = stack[#stack]
  if top and top.blur then top:blur() end
  new_state = new_state.load and new_state:load() or new_state
  table.insert(stack, new_state)

--  M.build()
end


--- pop and 'quit' top 'n' frames. 'focus' next frame. 'n' is optional and
-- defaults to 1.
function M.pop (n)
  for i=1, (n or 1) do
    local top = table.remove(stack)
    if top and top.quit then top:quit() end
  end
  top = stack[#stack]
  if top and top.focus then top:focus() end
end

---- Functions for outside
-- The following functions call each corresponding method of the elements of the
-- stack is called, from top to bottom.
--
-- The draw function is a little bit different, as it calls the functions
-- from top to bottom.
--
-- See love.org/wiki documentation for further information of these functions.

--- M.keypressed
--- M.keyreleased
--- M.resize
--- M.mousepressed
--- M.mousereleased
--- M.quit
--- M.update
--- M.draw
-- this function is a little special, as it calls the methods from bottom to
-- top.


function M.update (dt, ...)
  now = now + dt
  if M.timestep then
    rawupdate(dt, ...)

  else
    accumulator = math.min(accumulator + dt, framerate*10)
    updates = 0
    while accumulator >= framerate do
      rawupdate(dt, ...)

      accumulator = accumulator - framerate
      updates = updates + 1
    end
  end
end

-- define all those functions bubbling
for i,name in ipairs({
  "keypressed", "keyreleased", "resize",
  "mousepressed", "mousereleased", "quit"
}) do

  M[name] = function (...)
    for i = #stack, 1, -1 do local state = stack[i]
      local f = state[name] if f then
        local nobubble = f(state, ...)
        if nobubble==true then break end
      end
    end
  end
end

function M.draw (...)
  for i, state in ipairs(stack) do
    if state.draw then state:draw(...) end
  end
end

return M
