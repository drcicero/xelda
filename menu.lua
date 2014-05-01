--- Menu:
-- Display a interactive column-based dialog box. It can be used to make menu or 
-- other simple guis.
-- 
-- Dependencies: $audio, $love.graphics

require "audio"

menu = {app={}}

local g = love.graphics

local pad, getW, getH, INTERACTION, anim

INTERACTION = true
pad = 4
selector = 1

function getW(font, text)
  local width, lines = font:getWrap(text, math.huge)
  return width
end

function getH(font, text, max_width)
  local width, lines = font:getWrap(text, max_width)
  local height = lines * font:getHeight() * font:getLineHeight()

  return height
end

--- Set XYWH of the children of a column out.
function menu.layout(self)
  local y = 0

  for i,o in ipairs(self) do
    o.parent = self
    o.y = y
    if o.type == "range" then
      local x = 0
      o.sub = {}
      o.h = pad*2
      for i,r in ipairs(o.range) do
        local w = getW(o.style.font, r)
        o.sub[i] = {title=r, w=w, x=x}
        x = x + w
        o.h = math.max(o.h, getH(o.style.font, r, self.w) + pad*2)

        if r == o.title then o.sel = i end
      end

    else
      o.h = getH(o.style.font, o.title, self.w) + pad*2
    end
    y = y + o.h
  end

  self.h = y

  return self
end

popping = nil
exiting = nil

function anim (self, hide_show, left_right, onfinished)
  INTERACTION = false
  start = love.timer.getTime()

  local x_diff = left_right=="left" and -10 or 10
  local x_from = self.x - (hide_show=="hide" and 0 or x_diff)

  local a_from = hide_show=="hide" and 1 or 0
  local a_diff = hide_show=="hide" and -1 or 1

  local tmp = self.update
  self.update = function ()
    local x = math.min((love.timer.getTime()-start)*4, 1)
    x = x*x*(3-2*x)

    self.x = x_from + x * x_diff
    self.alpha = a_from + x * a_diff

    if x == 1 then
      INTERACTION = true
      self.update = tmp
      onfinished()
    end
  end
end

---- Widgets

function menu.set (self, k, v)
  if k == "style" then 
    for k,v in pairs(v) do
      self.style[k] = v
    end
  else
    self[k] = v
  end
  return self
end

--- A Column is a container widget. Generate is a function that returns an array of widgets to be displayed vertical.
function menu.column (self)
--- 
  function self.getForm (self)
    local form = {}
    for i,o in ipairs(self) do
      if o.name then
        form[o.name] = o
      end
    end
    return form
  end

--- 
  function self.load (self)
    self.w = 200

    self.x = w/2 - self.w/2
    self.y = 150

    self.alpha = 255

    self.draw = menu.app.draw
    self.update = menu.app.update
    self.mousepressed = menu.app.mousepressed
    self.keypressed = menu.app.keypressed
    self.quit = function ()
      if self.exit then self:exit() end
      menu.app.quit(self)
    end

    self.selector = 1

    if self.enter then self:enter() end
    menu.layout(self)
    menu.app.load(self)

    return self
  end

  self.set = menu.set

  return self
end

--- 
function menu.button(title, func)
  return ({type="button", title=title, action=func,
  style={}, set=menu.set}):set("style", menu.styles.base):set("style", menu.styles.button)
end

--- 
function menu.goto(blueprint) return function ()
  change_app_state(blueprint())
end end

--- 
function menu.label(title)
  return ({type="label", title=title, style={}, set=menu.set}):set("style", menu.styles.base):set("style", menu.styles.label)
end

--- 
function menu.input(name, init)
  return ({type="input", title=init, name=name, action=function (self)
    love.textinput = function (c)
      self.parent[self.parent.selector].title = self.parent[self.parent.selector].title .. c
    end
  end, style={}, set=menu.set}):set("style", menu.styles.base):set("style", menu.styles.input)
end

--- 
function menu.range(name, range, init)
  self = ({type="range", name=name, range=range,
    style={}, set=menu.set, sel=1}):set("style", menu.styles.base):set("style", menu.styles.range)

  function self.left (self)
    self.sel = (self.sel-1-1) % #self.range +1
    if self.change then self:change() end
  end
  function self.right (self)
    self.sel = (self.sel+1-1) % #self.range +1
    if self.change then self:change() end
  end
  self.action = self.right

  return self
end

---- App Interface
-- menu.app = {}
--- 
function menu.app.load (self, hide_show, left_right)
  local x = self.x

  while not self[self.selector].action do
    self.selector = (self.selector+1-1) % #self +1
  end

  anim(self, "show", "left", function () end)
end

menu_app_stack = {}
--- 
function menu.app.quit (self, next_app)
  local old_menu = app_state

  local tmp_p = popping

  popping = function ()
    change_app_state(old_menu)
    popping = tmp_p
  end

  menu.x = x

  anim(self, "hide", "left", next_app)
end

first_draw = true
--- 
function menu.app.draw (self)
  if first_draw then print("first draw") first_draw = false end

  local bars = 50
  for i=0,bars do
    local f = i/bars
    g.setColor(255*0.3, 255*0.6, 255*0.9, 100+100*f)
    g.rectangle("fill", 0, (1-f)*h, w, h/bars)
  end

  g.push()
  g.translate(self.x, self.y)

  g.setColor(255*0.3, 255*0.6, 255*0.9, 255*0.25*self.alpha)
  g.rectangle(love.textinput and "line" or "fill",
    0, self[self.selector].y,
    self.w, self[self.selector].h)

  for i,o in ipairs(self) do
    local style = o.style
    g.setFont(style.font)

    if o.type == "range" then
      for i,s in ipairs(o.sub) do
        g.setColor(style.col[1], style.col[2], style.col[3],
          style.col[4] * self.alpha*(o.sel==i and 1 or 0.5))

        g.print(s.title, s.x, o.y)
      end

    else
      g.setColor(style.col[1], style.col[2], style.col[3], style.col[4] * self.alpha)
      if style.before then g.printf(style.before, -20, o.y+pad, 10, "right") end
      g.printf(o.title, 0, o.y+pad, self.w, "left")
    end
  end

  g.pop()
end

--- 
function menu.app.keypressed (self, e)
  if not INTERACTION then return end

  if love.textinput then
    if e == "backspace" then
      local line = self[self.selector].title
      local last
      repeat
         last = line:sub(-1):byte()
         line = line:sub(1, -2)
      until line == "" or last < 0x80 or last >= 0xc0
      self[self.selector].title = line

    elseif e == "return" then
      love.textinput = nil
      local o = self[self.selector]
      if o.change then o:change() end
    end

  else
    if e == "down" then
      self.selector = (self.selector+1-1) % #self +1
      while not self[self.selector].action do
        self.selector = (self.selector+1-1) % #self +1
      end

    elseif e == "up" then
      self.selector = (self.selector-1-1) % #self +1
      while not self[self.selector].action do
        self.selector = (self.selector-1-1) % #self +1
      end

    elseif e == "left" then
      local o = self[self.selector]
      if o.left then o:left() end

    elseif e == "right" then
      local o = self[self.selector]
      if o.right then o:right() end

    elseif e == " " or e == "return" then
      local action = self[self.selector].action
      if type(action) == "table" then 
        change_app_state(action)

      else
        action(self[self.selector], self)
      end
    end
  end
end

--- 
function menu.app.mousepressed (self)
  if not INTERACTION then return end

  local x, y = love.mouse.getPosition()
  local o = self[self.selector]

  if love.textinput then
    love.textinput = nil
    local o = self[self.selector]
    if o.change then o:change() end

  else
    if o.action
    and self.x < x and x < self.x+self.w
    and self.y+o.y < y and y < self.y+o.y+o.h then
      local action = self[self.selector].action
      if type(action) == "table" then 
        change_app_state(action)

      else
        action(self[self.selector], self)
      end
    end
  end
end

--- 
local lastX = 0
local lastY = 0
function menu.app.update (self)
  if love.textinput then
    menu.layout(self)

  else
    local x, y = love.mouse.getPosition()

    if x ~= lastX or y ~= lastY then
      lastX, lastY = x, y
      if self.x < x and x < self.x+self.w then
        for i, o in ipairs(self) do
          if self[i].action
          and self.y+o.y < y and y < self.y+o.y+o.h then
            self.selector = i
            break
          end
        end
      end
    end
  end
end

---- standard styles
--- 
menu.styles = {
  base   = { col = {255,255,255,255*0.7}, font = g.newFont(12) },
  label  = { col = {200,255,100,255} },
  button = {  },
  input  = { col = {100,255,200,255} },
  range  = { col = {100,255,200,255} },

  header  = { col = {200,255,100,255}, font = g.newFont(18) },
  light   = { col = {200,255,100,255*0.5} },
  primary = { col = {255,255,255,255} },
  push    = { before = ">" },
}


