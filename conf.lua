function love.conf(t)
  t.title  = "Xeldas Saga"
  t.author = "David Richter"
  t.version = "0.9.1"
  t.identity = "Xeldas Saga"


  t.window.width = 800
  t.window.height = 400
  t.window.fullscreen = false
  t.window.vsync = true

  t.modules.physics    = false
  t.modules.joystick   = false
  t.modules.thread     = false
end

