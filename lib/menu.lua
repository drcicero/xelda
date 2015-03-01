local love, w, h = love, w, h
local g = love.graphics
local app = require("frames")
local cron = require("cron")
local audio = require("audio")
local styles = require("menus.style")
local getW, getH
local pad = 4
local lastX, lastY = 0, 0
local doit
doit = function(self)
  if "table" == type(self.action) then
    app.pop()
    return app.push(self.action)
  else
    return self:action(self.parent)
  end
end
local inside
inside = function(self, child, x, y)
  local x_bounds = 0 < x and x < self.x + self.w
  local y_bounds = self.y + child.y < y and y < self.y + child.y + child.h
  return x_bound and y_bounds
end
local mixin_table
mixin_table = function(self, other)
  for k, v in ipairs(other) do
    self[k] = v
  end
  for k, v in pairs(other) do
    self[k] = v
  end
end
local setColor
setColor = function(col, alpha)
  return g.setColor(col[1], col[2], col[3], col[4] * alpha)
end
getW = function(font, text)
  local width, lines
  width, lines = font:getWrap(text, math.huge)
  return width
end
getH = function(font, text, max_width)
  local width, lines
  width, lines = font:getWrap(text, max_width)
  return lines * font:getHeight() * font:getLineHeight()
end
local set
set = function(self, k, v)
  self[k] = v
  return self
end
local usedwidth
usedwidth = function(self)
  local w
  w = 0
  for i, child in ipairs(self.range) do
    w = w + getW(self.style.font, child)
  end
  return w
end
local layout
layout = function(self)
  if self.type == "column" then
    local y
    y = 0
    for i, child in ipairs(self) do
      child.parent = self
      child.y = y
      child.style = child.style or { }
      setmetatable(child.style, {
        __index = self.styles[child.type]
      })
      setmetatable(self.styles[child.type], {
        __index = self.styles.base
      })
      layout(child)
      y = y + child.h
    end
    self.h = y
  elseif self.type == "range" then
    self.sub = { }
    self.h = 0
    local gap, x
    gap = (self.parent.w - usedwidth(self)) / (#self.range - 1)
    x = 0
    for i, child in ipairs(self.range) do
      local w, h
      w = getW(self.style.font, child)
      h = getH(self.style.font, child, self.parent.w)
      self.sub[i] = {
        title = child,
        w = w,
        h = h,
        x = x
      }
      self.h = math.max(self.h, h + pad * 2)
      x = x + w + gap
      if child == self.title then
        child.sel = i
      end
    end
  else
    self.h = (getH(self.style.font, self.title, self.parent.w)) + pad * 2
  end
  return self
end
local goto
goto = function(blueprint)
  return function()
    app.pop()
    return app.push(blueprint())
  end
end
local pop
pop = function(selected, self, func, time)
  return app.stack[#app.stack]:_anim("hide", "left", app.stack[#app.stack].noanim and 0 or time, function()
    app.pop()
    if func then
      return func()
    end
  end)
end
local label
label = function(title)
  return {
    type = "label",
    title = title,
    style = { },
    set = set
  }
end
local button
button = function(title, onclick)
  return {
    type = "button",
    title = title,
    style = { },
    set = set,
    action = onclick
  }
end
local input
input = function(name, title)
  return {
    type = "input",
    title = title,
    style = { },
    set = set,
    name = name,
    action = function(self)
      love.textinput = function(c)
        self.title = self.title .. c
      end
    end
  }
end
local range
range = function(name, range, onchange)
  return {
    type = "range",
    style = { },
    set = set,
    name = name,
    sel = 1,
    range = range,
    action = function(self)
      return self:right()
    end,
    change = onchange,
    left = function(self)
      self.sel = (self.sel - 1 - 1) % #self.range + 1
      if self.change then
        return self:change()
      end
    end,
    right = function(self)
      self.sel = (self.sel + 1 - 1) % #self.range + 1
      if self.change then
        return self:change()
      end
    end
  }
end
local column
do
  local _base_0 = {
    type = "column",
    getForm = function(self)
      local _tbl_0 = { }
      for i, child in ipairs(self) do
        if child.name then
          _tbl_0[child.name] = child
        end
      end
      return _tbl_0
    end,
    resize = function(self)
      self.y = h / 2 - self.h / 2
      self.x = w / 2 - self.w / 2
    end,
    quit = function(self)
      if self.exit then
        return self:exit()
      end
    end,
    layout = layout,
    set = set,
    _findNextSelector = function(self)
      while true do
        self.selector = (self.selector + 1 - 1) % #self + 1
        if self[self.selector].action then
          break
        end
      end
    end,
    _findPrevSelector = function(self)
      while true do
        self.selector = (self.selector - 1 - 1) % #self + 1
        if self[self.selector].action then
          break
        end
      end
    end,
    load = function(self)
      if self.enter then
        self:enter()
      end
      self:layout()
      self:resize()
      self:_anim("show", "left", self.noanim and 0 or nil)
      self.selector = self.selector or 0
      self:_findNextSelector()
      return self
    end,
    draw = function(self)
      setColor(self.bg, self.alpha)
      g.rectangle("fill", 0, 0, w, h)
      g.push()
      g.translate(self.x, self.y)
      if self.fill then
        setColor(self.bg, self.alpha)
        g.rectangle("fill", -(self.pad or 0), -(self.pad or 0), (self.pad or 0) * 2 + self.w, (self.pad or 0) * 2 + self.h)
        g.setColor(255, 255, 255, 255 * .25 * self.alpha)
        g.rectangle("line", -(self.pad or 0), -(self.pad or 0), (self.pad or 0) * 2 + self.w, (self.pad or 0) * 2 + self.h)
      end
      for i, child in ipairs(self) do
        local style
        style = child.style
        g.setFont(style.font)
        if self.selector == i then
          setColor(style.selection, self.alpha * (self.enabled and 1 or .2))
          g.rectangle(love.textinput and "line" or "fill", 0, child.y, self.w, child.h)
        end
        if child.type == "range" then
          for i, s in ipairs(child.sub) do
            setColor(style.col, self.alpha * (child.sel == i and 1 or 0.5))
            g.print(s.title, s.x, child.y)
          end
        else
          setColor(style.col, self.alpha)
          if style.before then
            g.printf(style.before, -20, child.y + pad, 10, "right")
          end
          g.printf(child.title .. (style.after or ""), 0, child.y + pad, self.w, "left")
        end
      end
      g.pop()
      return false
    end,
    keypressed = function(self, e)
      if not (self.enabled) then
        return true
      end
      if love.textinput then
        if e == "backspace" then
          local line = self[self.selector].title
          while true do
            local last = line:sub(-1):byte()
            line = line:sub(1, -2)
            if line == "" or last < 0x80 or last >= 0xc0 then
              break
            end
          end
          self[self.selector].title = line
        elseif e == "return" then
          love.textinput = nil
          local o = self[self.selector]
          if o.change then
            o:change()
          end
        end
      else
        local play = true
        local child = self[self.selector]
        local _exp_0 = e
        if "down" == _exp_0 then
          self:_findNextSelector()
        elseif "up" == _exp_0 then
          self:_findPrevSelector()
        elseif "left" == _exp_0 then
          if child.left then
            child:left()
          end
        elseif "right" == _exp_0 then
          if child.right then
            child:right()
          end
        elseif " " == _exp_0 or "return" == _exp_0 then
          doit(child)
        else
          play = false
        end
        if play then
          if play then
            local _ = audio.play("schwupp"), nil, nil, .25
          end
        end
      end
      return true
    end,
    mousepressed = function(self)
      if not (self.enabled) then
        return true
      end
      local x, y = love.mouse.getPosition()
      local child = self[self.selector]
      if love.textinput then
        love.textinput = nil
        child = self[self.selector]
        if child.change then
          child:change()
        end
      elseif child.action and inside(self, child, x, y) then
        doit(child)
      end
      return true
    end,
    update = function(self)
      if cron then
        self.clock.update()
      end
      if not (self.enabled) then
        return true
      end
      if love.textinput then
        self:layout()
      else
        local x, y = love.mouse.getPosition()
        if x ~= lastX or y ~= lastY then
          lastX, lastY = x, y
          if self.x < x and x < self.x + self.w then
            for i, o in ipairs(self) do
              if self[i].action and self.y + o.y < y and y < self.y + o.y + o.h then
                self.selector = i
                break
              end
            end
          end
        end
      end
      return true
    end,
    _anim = function(self, hide_show, left_right, time, onfinished)
      local time, x_diff, alpha_diff
      self.enabled = false
      time = time or 1 / 4
      x_diff = left_right == "left" and -10 or 10
      if hide_show == "show" then
        self.x = self.x - x_diff
      end
      alpha_diff = hide_show == "hide" and -1 or 1
      self.alpha = hide_show == "hide" and 1 or 0
      if cron then
        self.clock.add({
          dur = time,
          f = (cron.by(self, "x", x_diff))
        })
        return self.clock.add({
          dur = time,
          f = (cron.by(self, "alpha", alpha_diff)),
          ended = function()
            self.enabled = true
            if onfinished then
              return onfinished()
            end
          end
        })
      else
        self.x = self.x + x_diff
        self.alpha = self.alpha + alpha_diff
        self.enabled = true
        if onfinished then
          return onfinished()
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, other)
      mixin_table(self, other)
      self.styles = self.styles or styles
      self.name = self.name or "[menu " .. tostring(self) .. "]"
      self.w = self.w or 200
      self.alpha = self.alpha or 255
      self.clock = cron.new_clock()
    end,
    __base = _base_0,
    __name = "column"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  column = _class_0
end
return {
  column = column,
  range = range,
  input = input,
  label = label,
  button = button,
  pop = pop,
  goto = goto,
  menuclock = menuclock
}
