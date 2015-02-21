--- Events

local M = {}

--- call this once per frame
function M.update()
  for cond, func in pairs(M.once) do
    if cond() then
      M.once[cond] = nil
      func()
    end
  end

  for cond, func in pairs(M.on) do
    if cond() then func() end
  end
end

--- M.on = {}
-- M.on is a table of cond=func pairs. each #M.update the conds are called
-- and if true the corresponding func is called.
M.on = {}

--- M.once = {}
-- like #M.on. additionaly the pair is removed after the first call.
M.once = {}

return M
