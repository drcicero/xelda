--- Tweening.

local tween = {}

local pi = math.pi
local when, tweens, newtweens = {}, {}, {}

--- Defer call.
-- After time has passed, func will be called without arguments.
function tween.after(time, func)
    when[#when+1] = {at=love.timer.getTime()+time, func=func}
end

--- Tween int-property to value.
-- Shortcut for tween.by(table, key, val-table[key], dur, f)
function tween.to(table, key, val, dur, f)
    return tween.by(table, key, -table[key]+val, dur, f)
end

--- Tween int-property by value.
-- For the next dur seconds calls to 'tween.update' will set 'table[key]'
-- to 'from + val * f(time_passed/dur)', where from is table[key] and
-- time_passed is the time since calling 'tween.by'.
-- dur=0 duration in seconds
-- f=plugins.tween.Swing f
--[[
local tween = {to=print, by=print}
local table = {x=0}

tween.by(table, "x", 10, 1) -- now tween.update will transition table.x over the next second from 0 to 10

-- You can also mixin 'to' and 'by'.
table.to = tween.to
table.by = tween.by

table:to("x", 10, 1)
]]
function tween.by(table, key, val, dur, f)
    if dur == nil then
        table[key] = table[key] + val
        return table
    end

    if f == nil then f = tween.Swing end

    local from = table[key]
    local function f2(x) return from + val * f(x) end

    newtweens[#newtweens+1] = {
        table=table, key=key, f=f2,
        start=love.timer.getTime(), dur=dur
    }
    return table
end

--- Tween string-property to value.
-- Will repeatedly update 'table[key]' according to 'f'. 'dur' defaults to '0', 'f' to 'tween.Swing'.
function tween.write(table, key, val, dur, f)
    if dur == nil then 
        table[key] = table[key] .. val
        return table
    end

    if f == nil  then f = tween.Swing end

    val = table[key] .. val
    local from, diff = #table[key], #val
    local function f2(x) return val:sub(1, from + diff * f(x)) end

    newtweens[#newtweens+1] = {
        table=table, key=key, f=f2,
        start=love.timer.getTime(), dur=dur
    }
    return table
end

--    function tween.shake(degree)
--        local rot = obj.rot
--        tween.Random(delta, obj, "rot", math.pi*2/36/10)

--        local children = obj._children
--        if childs ~= nil then
--            for i,child in ipairs(children) do
--                tween.shake(child)
--            end
--        end
--    end
--    help[tween.shake] = [[delta, obj -> nil]]

--- Show, grow and rotate the thing for dur seconds, then return it to its previous state. 'dur' defaults to '2'.
function tween.highlight(thing, dur)
    if not dur then dur=2 end
    dur = dur/2
    local alpha, size, rot
        = thing.alpha, thing.size, thing.rot

    tween.to(thing, "size",  2*size, dur)
    tween.by(thing, "rot",   2*pi,   dur)
    tween.to(thing, "alpha", 255,    dur)

    tween.after(dur, function()
        tween.to(thing, "size",  size,  dur)
        tween.to(thing, "rot",   rot,   dur)
        tween.to(thing, "alpha", alpha, dur)
    end)

    return thing
end

---- Easing Methods.
--- Linear Interpolation
-- <a href=http://www.wolframalpha.com/input/?i=plot+x+and+%283-2x%29+x%C2%B2+and+x%C2%B2+and+2x-x%C2%B2+from+0+to+1 >Compare the easing methods in a plot.</a>
-- returns x
function tween.Linear(x) return x end

--- Swing / Ease / Smooth Interpolation
-- returns (3-2x) *x*x
function tween.Swing(x) return x*x*(3-2*x) end

--- Accellerating Interpolation
-- returns x*x
function tween.Accel(x) return x*x end

--- Deccelerating Interpolation.
-- returns 2x - x*x
function tween.Deccel(x) return 2*x-x*x end

---- Interface Plugin

--- Call this function before using tables that are beeing tweened.
-- Normaly you call it once per frame and before drawing.
function tween.update()
    local now = love.timer.getTime()

    local i=1
    while i < #when+1 do local job = when[i]
        if now >= job.at then
            job.func()
            table.remove(when, i)
        else
            i = i+1
        end
    end

    local i=1
    while i < #tweens+1 do local tween = tweens[i]
        if now >= tween.start then
            local x = (now-tween.start)/tween.dur
            if x >= 1 then
                tween.table[tween.key] = tween.f(1)
                table.remove(tweens, i)
            else
                tween.table[tween.key] = tween.f(x)
                i = i+1
            end
        else
            i = i+1
        end
    end

    for k, newtween in pairs(newtweens) do
        table.insert(tweens, newtween)
        newtweens[k] = nil
    end
end

return tween
