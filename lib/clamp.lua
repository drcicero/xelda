--- Clamp
-- clamp is a useful math shortcut.

--- 
-- returns x clamped into the range from min to max.
-- errors on 'min > max', or returns '(min+max)/2' if 'avg' is 'true'.
local function clamp (min, x, max, avg)
  if min > max then
    if avg then
      return (min+max)/2
    else
      error("'min > max' in clamp(".. min..", ".. x..", ".. max..", "..tostring(avg).."); if you set arg 4 to true, min > max returns (min+max)/2")
    end

  elseif x < min then return min
  elseif x > max then return max
  else                return x   end
end

return clamp
