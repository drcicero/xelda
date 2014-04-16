function clamp (min, x, max)
  if min > max then print("warning: clamp min ("..min..") > max ("..max..")", x) end
  if x < min then return min
  elseif x > max then return max
  else return x end
end

