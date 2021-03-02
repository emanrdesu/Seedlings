Touch = Object:extend()
Touch.PRESS = "press"
Touch.MOVE = "move"
Touch.RELEASE = "release"

function Touch:new(id, x, y, dx, dy, pressure, eventType)
  self.id = id or -1
  self.x = x or -1
  self.y = y or -1
  self.dx = dx or 0
  self.dy = dy or 0
  self.pressure = pressure or -1
  self.eventType = eventType or "NIL"
end
