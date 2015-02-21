---- standard styles
return {
  base   = { col = {255,255,255,255*0.7}, font = love.graphics.newFont("assets/slkscr.ttf", 16) },
  label  = { col = {200,255,100,255} },
  button = {  },
  input  = { col = {100,255,200,255} },
  range  = { col = {100,255,200,255} },

-- custom classes
  header  = { col = {200,255,100,255}, font = love.graphics.newFont("assets/slkscr.ttf", 32) },
  light   = { col = {200,255,100,200} },
  primary = { col = {255,255,255,255}, font = love.graphics.newFont("assets/slkscr.ttf", 20) },
  push    = { after = " ..." },
  pop     = { align="left" }, --before = "< " },
}
