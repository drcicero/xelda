function love.conf(t)
  t.title  = "Xeldas Saga"
  t.author = "David Richter"
  t.version = "0.9.1"
  t.identity = "Xelda"

  t.window.resizable = true
--  t.window.minwidth = 400
--  t.window.minheight = 250

  t.window.width  = 0 --600
  t.window.height = 0 --400
  t.window.fullscreentype = "desktop"
  t.window.fullscreen = true
  t.window.vsync = true

  t.modules.physics    = false
  t.modules.joystick   = false
  t.modules.thread     = false
end
