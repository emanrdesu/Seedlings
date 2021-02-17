Button = Object:extend()

function Button:setCircleHitbox(x, y, r) 
  self.hitbox = 'circle'
  self.hitbox_x = x
  self.hitbox_y = y
  self.hitbox_r = r
  self.hitbox_pressed = false
end

function Button:setRectangleHitbox(x, y, width, height)
  self.hitbox = 'rectangle'
  self.hitbox_x = x
  self.hitbox_y = y
  self.hitbox_width = width
  self.hitbox_height = height
  self.hitbox_pressed = false
end

function Button:update()
  
end

function Button:draw()
  
end

function Button:pointInside(x, y)
  if self.hitbox == 'circle' then
    local dx = x - self.hitbox_x
    local dy = y - self.hitbox_y
    if dx*dx + dy*dy <= self.hitbox_r * self.hitbox_r then return true end
  if self.hitbox == 'rectangle' then
    local xi = x >= self.hitbox_x and x <= self.hitbox_x + self.hitbox_width
    local yi = y >= self.hitbox_y and y <= self.hitbox_y + self.hitbox_width
    return xi and yi
  end
  return false
end