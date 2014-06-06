---- App States
app_states = {}
app_state = nil


--- 
function change_app_state (new_state)
  pop_app_state ()
  push_app_state (new_state)

  build_app_states()
end

--- 
function build_app_states ()
  love.draw = function (...)
    tweens.update()

    for i = 1, #app_states do
      local app_state = app_states[i]
      if app_state.draw then
        app_state.draw(app_state, ...)
      end
    end
  end

  for i,name in ipairs({
    "update", "keypressed", "keyreleased",
    "mousepressed", "mousereleased", "quit"
  }) do

    love[name] = function (...)
      for i = #app_states, 1, -1 do
        local app_state = app_states[i]
        if app_state[name] then
          local nobubble = app_state[name](app_state, ...)
          if nobubble==true then break end
        end
      end
    end

  end
end

--- 
function push_app_state (new_state)
  if app_state and app_state.blur then app_state:blur() end
  app_state = new_state:load()
  table.insert(app_states, app_state)

  build_app_states()
end

--- 
function pop_app_state ()
  if app_state and app_state.quit then app_state:quit() end
  table.remove(app_states)
  app_state = app_states[#app_states]
  if app_state and app_state.focus then app_state:focus() end

  build_app_states()
end

