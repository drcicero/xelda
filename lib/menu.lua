--- Menu
-- Display a interactive column-based dialog box.
-- It can be used to make menus or other simple guis.
--
-- requires $app, $cron

local app = require "frames"
local cron = require "cron"
local audio = require "audio"

local M = {app={}}
M.styles = require "menus.style"

local menuclock
if cron then
  menuclock = cron.new_clock()
  M.menuclock = menuclock
end

local g = love.graphics
local getW, getH, anim
local INTERACTION, pad = true, 4

local function getW(font, text)
  local width, lines = font:getWrap(text, math.huge)
  return width
end

local function getH(font, text, max_width)
  local width, lines = font:getWrap(text, max_width)
  local height = lines * font:getHeight() * font:getLineHeight()

  return height
end

function anim (self, hide_show, left_right, onfinished, time)
  INTERACTION = false

  time = time or 1/4

  local x_diff = left_right=="left" and -10 or 10
  if hide_show == "show" then
    self.x = self.x - x_diff
  end
  self.alpha = hide_show=="hide" and 1 or 0

  if cron then
    menuclock.add {dur=time, f=cron.by(self, "x", x_diff)}
    menuclock.add {dur=time, f=cron.by(self, "alpha", hide_show=="hide" and -1 or 1), ended=function ()
      INTERACTION = true
      if onfinished then onfinished() end
    end}

  else
    self.x = x_diff
    self.alpha = hide_show=="hide" and -1 or 1
    INTERACTION = true
    if onfinished then onfinished() end
  end
end

--- this is a shortcut for 'function (f) app.pop() app.push(f()) end'
function M.goto(blueprint) return function ()
  app.pop()
  app.push(blueprint())
end end

--- 
function M.pop(selected, self, func, time)
  anim(app.stack[#app.stack], "hide", "left", function ()
    app.pop()
    if func then func() end
  end, app.stack[#app.stack].noanim and 0 or time)
end

function M.set (self, k, v)
  if k == "style" then 
    for k,v in pairs(v) do
      self.style[k] = v
    end
  else
    self[k] = v
  end
  return self
end


local function usedwidth(range)
  local usedwidth = 0
  for i,child in ipairs(range.range) do
    local w = getW(range.style.font, child)
    usedwidth = usedwidth + getW(range.style.font, child)
  end
  return usedwidth
end


local function layout (self)
  if self.type == "column" then
    local y = 0
    for i,child in ipairs(self) do
      child.parent = self
      child.y = y
      child:set("style", self.styles.base)
      child:set("style", self.styles[child.type])
      layout(child)
      y = y + child.h
    end
    self.h = y

  elseif self.type == "range" then
    self.sub = {}
    self.h = 0

    local gap = (self.parent.w - usedwidth(self)) / (#self.range-1)

    local x = 0
    for i,child in ipairs(self.range) do
      local w = getW(self.style.font, child)
      local h = getH(self.style.font, child, self.parent.w)
      self.sub[i] = {title=child, w=w, h=h, x=x}
      self.h = math.max(self.h, h + pad*2)
      x = x + w + gap

      if child == self.title then o.sel = i end
    end

  else 
    self.h = getH(self.style.font, self.title, self.parent.w) + pad*2
  end

  return self
end


---- Widgets

--- A Column is a container widget. self is a list of widgets to be displayed
-- vertically.
function M.column (self)
  self.type = "column"
  self.styles = self.styles or M.styles
  self.name = self.name or "[menu "..tostring(self).."]"
  self.w = self.w or 200

--  --- returns a map of all widgets with names by name
  function self.getForm (self)
    local form = {}
    for i,o in ipairs(self) do
      if o.name then
        form[o.name] = o
      end
    end
    return form
  end
  function self.resize (self)
    self.y = h/2 - self.h/2
    self.x = w/2 - self.w/2
  end
  self.layout = layout

  self.alpha = self.alpha or 255

  self.set = M.set
  self.load = M.app.load
  self.draw = M.app.draw
  self.update = M.app.update
  self.mousepressed = M.app.mousepressed
  self.keypressed = M.app.keypressed
  self.quit = function ()
    if self.exit then self:exit() end
  end


  return self
end


--- title is the label of the button, func is a function to be called when the
-- button is activated. the function will get the button as first argument.
function M.button(title, func)
  return ({type="button", title=title, action=func, style={}, set=M.set})
end

--- 
function M.label(title)
  return ({type="label", title=title, style={}, set=M.set})
end

--- 
function M.input(name, init)
  return ({type="input", title=init, name=name, action=function (self)
    love.textinput = function (c)
      self.parent[self.parent.selector].title = self.parent[self.parent.selector].title .. c
    end
  end, style={}, set=M.set})
end

--- 
function M.range(name, range, init)
  self = ({type="range", name=name, range=range, style={}, set=M.set, sel=1})

  function self.left (self)
    self.sel = (self.sel-1-1) % #self.range +1
    if self.change then self:change() end
  end
  function self.right (self)
    self.sel = (self.sel+1-1) % #self.range +1
    if self.change then self:change() end
  end
  self.action = self.right
  self.change = init

  return self
end

---- App Interface
-- M.app = {}
--- 
function M.app.load (self) --, hide_show, left_right)
  self.selector = self.selector or 1

  if self.enter then self:enter() end
  self:layout()
  self:resize()

  local x = self.x

  while not self[self.selector].action do
    self.selector = (self.selector+1-1) % #self +1
  end

  anim(self, "show", "left", nil, self.noanim and 0 or nil)
  return self
end


--- 
function M.app.draw (self)
--  if false then
  g.setColor(self.bg[1], self.bg[2], self.bg[3], self.bg[4]*self.alpha)
  g.rectangle("fill", 0, 0, w, h)

--  else
--    local bars = 50
--    for i=0,bars do
--      local f = i/bars
--      g.setColor(255*0.5, 255*0.55, 255*0.6, 150+100*f)
--      g.rectangle("fill", 0, (1-f)*h, w, h/bars)
--    end

--    g.setColor(255,255,255,255)
--    g.draw(xelda, w/2-xelda:getWidth()-150, h-xelda:getHeight()+50)
--    g.draw(watson, w/2+watson:getWidth()/2+150, h-watson:getHeight()/2-150, math.sin(love.timer.getTime())/3, 1, 1, watson:getWidth()/2, watson:getHeight()/2)
--  end

  if self.fill then
    g.setColor(self.bg[1], self.bg[2], self.bg[3], self.bg[4]*self.alpha)
    g.rectangle("fill",
      self.x -(self.pad or 0),
      self.y -(self.pad or 0),
      self.w + 2*(self.pad or 0),
      self.h + 2*(self.pad or 0))
    g.setColor(255, 255, 255, 255*.25*self.alpha)
    g.rectangle("line",
      self.x -(self.pad or 0),
      self.y -(self.pad or 0),
      self.w + 2*(self.pad or 0),
      self.h + 2*(self.pad or 0))
  end

  g.push()
  g.translate(self.x, self.y)

  g.setColor(255*0.3, 255*0.6, 255*0.9, 255*0.25*self.alpha * (INTERACTION and 1 or .2))
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
      g.printf(o.title .. (style.after or ""), 0, o.y+pad, self.w, "left")
    end
  end

  g.pop()

  return false
end


--- 
function M.app.keypressed (self, e)
  if not INTERACTION then return true end

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
    local play = true
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
      doit(self[self.selector])
    else
      play = false
    end
    if play then audio.play("schwupp", nil, nil, .25) end
  end

  return true
end

function doit(self)
  if type(self.action) == "table" then 
    app.pop()
    app.push(self.action)

  else
    self.action(self, self.parent)
  end
end

--- 
function M.app.mousepressed (self)
  if not INTERACTION then return true end

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
      doit(self[self.selector])
    end
  end

  return true
end


--- 
local lastX, lastY = 0, 0
function M.app.update (self)
  if cron then menuclock.update() end
  if not INTERACTION then return true end

  if love.textinput then
    self:layout()

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

  return true
end

return M
