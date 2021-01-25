Touch = Object:extend()

function Touch:new(id, x, y, dx, dy, pressure, eventType)
  self.id = id
  self.x = x
  self.y = y
  self.dx = dx
  self.dy = dy
  self.pressure = pressure
  self.eventType = eventType
end
