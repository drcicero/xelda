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

