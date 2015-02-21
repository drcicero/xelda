--- Frames
-- Manage an stack of states called 'frame' by wrapping some of the love.*
-- callbacks. Every time one of these callbacks is called, the method of the
-- top frame is called. If he returns true, the call bubbles down.
--
-- Additionally you can specify an super fram 'app.top', which is always called
-- first, before the stack. You can $frames#M.push and $frames#M.pop frames.
--
-- A 'frame' is a table with the following optional 10 methods:
--
-- - 'load', 'blur': see $frames#M.push .
--
-- - 'quit', 'focus': see $frames#M.pop .
--
-- - 'update', 'draw': called once per frame
--
-- - 'keypressed', 'keyreleased', 'mousepressed', 'mousereleased': event callbacks.
local M = {}
local stack = {}
M.stack = stack
M.top = {}

M.timestep = true
now = 0

local accumulator = 0
local framerate = 1/60

local function rawupdate (...)
  if M.top.update then M.top.update() end
  for i = #stack, 1, -1 do local state = stack[i]
    if state.update then
      local nobubble = state:update(...)
      if nobubble==true then break end
    end
  end
end

function love.draw (...)
  if M.top.draw then M.top.draw() end
  for i, state in ipairs(stack) do
    if state.draw then state:draw(...) end
  end
end

function love.update (dt, ...)
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

-- bubbling
for i,name in ipairs({
  "keypressed", "keyreleased", "resize",
  "mousepressed", "mousereleased", "quit"
}) do

  love[name] = function (...)
    if M.top[name] then M.top[name](M.top[name], ...) end
    for i = #stack, 1, -1 do local state = stack[i]
      local f = state[name] if f then
        local nobubble = f(state, ...)
        if nobubble==true then break end
      end
    end
  end
end


--- 'blur' top frame. 'load' and push new frame.
function M.push (new_state)
--  print(debug.traceback())

  local top = stack[#stack]
  if top and top.blur then top:blur() end
  new_state = new_state.load and new_state:load() or new_state
  table.insert(stack, new_state)

--  M.build()
end


--- pop and 'quit' top 'n' frames. 'focus' next frame. 'n' defaults to 1.
function M.pop (n)
  for i=1, (n or 1) do
    local top = table.remove(stack)
    if top and top.quit then top:quit() end
  end
  top = stack[#stack]
  if top and top.focus then top:focus() end

--  M.build()
end

return M
