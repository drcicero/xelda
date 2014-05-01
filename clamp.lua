--- Clamp
-- clamp is a useful math shortcut.

---
-- returns 'x' if 'x' is between 'min' and 'max', else returns the nearest of 'min' or 'max'.
-- if 'min' is bigger than 'max', then '(min+max)/2' will be returned.
-- if 'avg' is 'true' this will not create a warning.
function clamp (min, x, max, avg)
  if min > max then
    if avg then
      return (min+max)/2
    else
      print("warning: clamp(".. min..", ".. x..", ".. max..", "..tostring(avg)..") min > max without avg")
      return (min+max)/2
    end

  elseif x < min then return min
  elseif x > max then return max
  else                return x   end
end

