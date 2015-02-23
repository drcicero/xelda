--- Menu
-- Display a interactive column-based dialog box.
-- It can be used to make menus or other simple guis.
--
-- requires $frames, $cron, $audio

love, w, h = love, w, h
g = love.graphics

app = require "frames"
cron = require "cron"
audio = require "audio"

serialize = (require "serialize").serialize

styles = require "menus.style"


local getW, getH, anim


-- private
pad = 4
lastX, lastY = 0, 0


doit = =>
    if "table" == type @action
        app.pop!
        app.push @action

    else
        @\action @parent


inside = (child, x, y) =>
    x_bounds = 0 < x and x < @x + @w
    y_bounds = @y + child.y < y and y < @y + child.y + child.h


mixin_table = (other) =>
    for k, v in ipairs other
        @[k] = v

    for k, v in pairs other
        @[k] = v


setColor = (col, alpha)->
    g.setColor col[1], col[2], col[3], col[4] * alpha


getW = (font, text)->
    local width, lines
    width, lines = font\getWrap text, math.huge
    width


getH = (font, text, max_width)->
    local width, lines
    width, lines = font\getWrap text, max_width
    lines * font\getHeight! * font\getLineHeight!


set = (k, v)=>
    @[k] = v
    @


usedwidth = =>
    local w
    w = 0
    for i, child in ipairs @range
        w += getW @style.font, child

    w


layout = =>
    if @type == "column"
        local y
        y = 0
        for i,child in ipairs @
            child.parent = @
            child.y = y
            child.style = child.style or {}
            setmetatable child.style, {__index: @styles[child.type]}
            -- TODO do this only once:
            setmetatable @styles[child.type], {__index: @styles.base}
            layout child
            y = y + child.h

        -- TODO if h < maxh then scroll
        @h = y

    elseif @type == "range"
        @sub = {}
        @h = 0

        local gap, x
        gap = (@parent.w - usedwidth @) / (#@range - 1)
        x = 0

        -- TODO if gap < 0 then scroll

        for i, child in ipairs @range
            local w, h
            w = getW @style.font, child
            h = getH @style.font, child, @parent.w

            -- TODO why get height, if it only works with single line anyway?

            @sub[i] = title: child, :w, :h, :x
            @h = math.max @h, h + pad*2
            x = x + w + gap

            child.sel = i  if child == @title

    else 
        @h = (getH @style.font, @title, @parent.w) + pad*2

    @


-- public
--- this is a shortcut for '(f) -> app.pop(); app.push(f())'
goto = (blueprint) -> ->
    app.pop!
    app.push blueprint!


--- 
pop = (selected, self, func, time) ->
    app.stack[#app.stack]\_anim "hide", "left",
        app.stack[#app.stack].noanim and 0 or time, ->
            app.pop!
            func!  if func


---- Widgets
--- 
label = (title) -> 
    {type: "label", :title, style: {}, :set}

button = (title, onclick)->
    {type: "button", :title, style: {}, :set, action: onclick}

--- 
input = (name, title)->
    {type: "input", :title, style: {}, :set, :name
    action: => love.textinput = (c)-> @.title ..= c}


--- 
range = (name, range, onchange)->
		{type: "range", style: {}, :set, :name
		sel: 1, :range
		action: => @right!
		change: onchange

    left: =>
        @sel = (@sel-1-1) % #@range +1
        @change!  if @change

    right: =>
        @sel = (@sel+1-1) % #@range +1
        @change!  if @change}


--- vertical container widget
class column
    type: "column"

    new: (other) =>
        mixin_table @, other
        @styles = @styles or styles
        @name   = @name or "[menu #{@}]"
        @w      = @w or 200
        @alpha  = @alpha or 255
        @clock  = cron.new_clock!

    getForm: =>
        {child.name, child  for i, child in ipairs @ when child.name}

    resize: =>
        @y = h/2 - @h/2
        @x = w/2 - @w/2

    quit: => @\exit!  if @exit
    layout: layout
    set: set

    _findNextSelector: =>
        while true
            @selector = (@selector + 1 - 1) % #self + 1
            break if @[@selector].action

    _findPrevSelector: =>
        while true
            @selector = (@selector - 1 - 1) % #self + 1
            break if @[@selector].action


    ---
    load: =>
        @\enter! if @enter
        @\layout!
        @\resize!
        @\_anim "show", "left", @noanim and 0 or nil

        @selector = @selector or 0
        @\_findNextSelector!

        self


    --- 
    draw: =>
        -- taint screen
        setColor @bg, @alpha
        g.rectangle "fill", 0, 0, w, h

        g.push!
        g.translate @x, @y

        if @fill
            -- background
            setColor @bg, @alpha
            g.rectangle "fill",
                -(@pad or 0),       -(@pad or 0),
                (@pad or 0)*2 + @w, (@pad or 0)*2 + @h

            -- border
            g.setColor 255, 255, 255, 255*.25*@alpha
            g.rectangle "line",
                -(@pad or 0),       -(@pad or 0),
                (@pad or 0)*2 + @w, (@pad or 0)*2 + @h


        -- children
        for i, child in ipairs self
            local style
            style = child.style
            g.setFont style.font

            -- emphase selected?
            if @selector == i
                setColor style.selection, @alpha * (@enabled and 1 or .2) 
                g.rectangle love.textinput and "line" or "fill",
                    0, child.y, @w, child.h

            if child.type == "range"
                for i, s in ipairs child.sub
                    setColor style.col, @alpha * (child.sel==i and 1 or 0.5)
                    g.print s.title, s.x, child.y

            else
                setColor style.col, @alpha

                g.printf style.before,
                    -20, child.y+pad, 10, "right" if style.before

                g.printf child.title .. (style.after or ""),
                    0, child.y+pad, @w, "left"

        g.pop!
        false


    --- 
    keypressed: (e) =>
        return true  unless @enabled

        if love.textinput
            if e == "backspace"
                line = @[@selector].title
                while true
                     last = line\sub(-1)\byte!
                     line = line\sub 1, -2
                     break if line == "" or last < 0x80 or last >= 0xc0

                self[@selector].title = line

            elseif e == "return" then
                love.textinput = nil
                o = @[@selector]
                o\change! if o.change

        else
            play = true
            child = @[@selector]
            switch e
                when "down"  then @\_findNextSelector!
                when "up"    then @\_findPrevSelector!
                when "left"  then child\left!  if child.left
                when "right" then child\right! if child.right

                when " ", "return" then doit child
                else                    play = false

            if play
                audio.play"schwupp", nil, nil, .25  if play

        true


    --- 
    mousepressed: =>
        return true unless @enabled

        x, y = love.mouse.getPosition!
        child = @[@selector]

        if love.textinput
            love.textinput = nil
            child = @[@selector]
            child\change!  if child.change

        elseif child.action and inside @, child, x, y
            doit child

        true


    --- 
    update: =>
        @clock.update! if cron
        return true unless @enabled

        if love.textinput
            self\layout!

        else
            x, y = love.mouse.getPosition!
            if x ~= lastX or y ~= lastY
                lastX, lastY = x, y
                if @x < x and x < @x + @w
                    for i, o in ipairs self
                        if @[i].action and @y + o.y < y and y < @y + o.y + o.h
                            @selector = i
                            break

        true


    _anim: (hide_show, left_right, time, onfinished)=>
        local time, x_diff, alpha_diff
        
        @enabled = false
        time = time or 1/4

        x_diff = left_right == "left" and -10 or 10
        @x = @x - x_diff  if hide_show == "show"

        alpha_diff = hide_show == "hide" and -1 or 1
        @alpha = hide_show == "hide" and 1 or 0

        if cron
            @clock.add dur: time, f: (cron.by @, "x", x_diff)
            @clock.add dur: time, f: (cron.by @, "alpha", alpha_diff), ended: ->
                @enabled = true
                onfinished!  if onfinished

        else
            @x += x_diff
            @alpha += alpha_diff
            @enabled = true
            onfinished!  if onfinished


:column, :range, :input, :label, :button, :pop, :goto, :menuclock
