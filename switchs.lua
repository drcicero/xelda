local switchs = {}
function setSwitch (sw, bool)
  local reverse = sw[0] == "!"
  if reverse then
    sw = sw.sub(1)
    bool = not bool
  end
  if switchs[sw] ~= bool then
    print(sw, switchs[sw], bool)
--    play(audios.schwupp)
    switchs[sw] = bool
  end
end
function getSwitch (sw)
  local reverse = sw[0] == "!"
  if reverse then sw = sw.sub(1) end
  return switchs[sw] == not reverse
end

