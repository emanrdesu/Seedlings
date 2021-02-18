Touch = Object:extend()
Touch.PRESS = "press"
Touch.MOVE = "move"
Touch.RELEASE = "release"

function Touch:new(id, x, y, dx, dy, pressure, eventType)
  self.id = id
  self.x = x
  self.y = y
  self.dx = dx or 0
  self.dy = dy or 0
  self.pressure = pressure
  self.eventType = eventType
end
