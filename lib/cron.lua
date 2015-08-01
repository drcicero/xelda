--- Tweening & Jobs
-- Example:
--[[
local cron = require "cron"
local clock
local s = "\n"
function load()
  clock = cron.new_clock()
  clock.add({start=0, dur=1, f=function(t)
    s = s .. t .. "\n"
  end, ended=function()
    s = s .. "1 second passed!" .. "\n"
  end})
end

function update (dt)
    clock.update (dt)
end

-- main
load()
for i=0,15 do
  update(1/10)
end
return s
]]

local M = {}

--- returns a new Clockspace. See #space.add .
function M.new_clock ()
  local space = {}
  space.now = 0
  space.jobs = {}

  ---- Clockspace --------------------------------------------------------------
  --- Add a new job:
  -- a job is a table with the properties {start, dur, [f, [ease]], [ended]}, where
  -- <ul><li>start is the time the job should start,
  -- <li>dur is the duration the job should run,
  -- <li>f is a function that is called every update with a number beginning at 0 and ending after with 1,
  -- <li>ease is a key of one of the cron.ease functions, that may skew the argument to f, and
  -- <li>ended is a function that is called once the job stops.</ul>
  function space.add (job)
    job.start = space.now
    space.jobs[job] = true
    if type(job.ease) == "string" then
      job.ease = M.ease[job.ease]
    end
    return job
  end

  --- Remove a job.
  function space.del (job)
    space.jobs[job] = nil
    return job
  end

  --- How many jobs are currently running?
  function space.len ()
    return #space.jobs
  end

  --- Call this function inside love.update().
  -- It will run scheduled jobs.
  function space.update(dt)
    local now = space.now + (dt or 1/60)
    space.now = now

    for job,_ in pairs(space.jobs) do
      if now >= job.start then
        local x = now - job.start
        x = job.dur and math.min(x/job.dur, 1) or  x

        if job.f then
          job.f(job.ease and job.ease(x) or x)
        end

        if x == 1 then
          if job.ended then job.ended() end
          space.jobs[job] = nil
        end
      end
    end
  end

  return space
end

---- Easing/Interpolation Functions. -------------------------------------------
-- Methods that return smooth changes from 0 to 1. See
-- <a href=http://www.wolframalpha.com/input/?i=plot+x+and+%283-2x%29+x%C2%B2+and+x%C2%B2+and+2x-x%C2%B2+from+0+to+1 >
-- a plot of all four functions</a> , to compare them visually.
M.ease = {}

--- = x (Linear Interpolation)
function M.ease.Linear(x) return x end
--- = (3 - 2x) x²  (Swing / Ease / Smooth Interpolation)
function M.ease.Swing(x) return x*x*(3-2*x) end
--- = x²  (Accellerating Interpolation)
function M.ease.Accel(x) return x*x end
--- = 2x - x²  (Deccelerating Interpolation)
function M.ease.Deccel(x) return 2*x-x*x end

---- Mutating functions. -------------------------------------------------------

--- Tween number property to a value.
function M.to (table, key, goal)
  local from = table[key]
  local diff = goal - from
  return function (x) table[key] = from + diff * x end
end

--- Tween number property by a value.
function M.by (table, key, diff)
  local from = table[key]
  return function (x) table[key] = from + diff * x end
end

--- Tween string property by value (The value will be added at the end).
function M.write (table, key, val)
  local from, diff = #table[key], #val
  val = table[key] .. val
  return function (x) table[key] = val:sub(1, from + diff * x) end
end

return M
