Button = Object:extend()

function Button:new(args)
  self.hitbox = args.hitbox or {shape = 'circle', x = 0, y = 0, r = 0}
  self.__onClick = args.onClick or function() end
  self.__drawNormal = args.drawNormal or function() end
  self.__drawHovered = args.drawHovered or self.__drawNormal
  self.hitbox_pressed = false
  self.is_hovered = false
end

function Button:update()
  local lt = inputManager:getLastTouch()
  --[[
    When you tap the screen, you may tap on some button X.
    When moving the tap, only button X switched between held/not held while the touch moves around
    When the touch is released, if it is released over button X then button X activates. No other button may activate
  --]]
  
  if lt ~= nil then
    if lt.eventType == Touch.PRESS then
      -- If we touched this button then set it's hitbox pressed to be true and set us to be hovered
      if self:pointInside(lt.x, lt.y) then 
        self.hitbox_pressed = true 
        self.is_hovered = true 
      else
        self.hitbox_pressed = false
      end
    elseif lt.eventType == Touch.MOVE then
      -- If we moved the mouse, if this button was the one initially pressed then make it hovered. Else it is not hovered
      if self:pointInside(lt.x, lt.y) and self.hitbox_pressed then
        self.is_hovered = true
      else
        self.is_hovered = false
      end
    elseif lt.eventType == Touch.RELEASE then
      -- If this button was the one touched initially and the release is inside it, activate it. Set hover/pressed to false afterwards
      if self:pointInside(lt.x, lt.y) and self.hitbox_pressed then
        self:onClick()
      end
      self.is_hovered = false
      self.hitbox_pressed = false
    end
  end
  
end

function Button:draw()
  if self.is_hovered then
    self.__drawHovered()
  else
    self.__drawNormal()
  end
end

function Button:onClick()
  self.__onClick()
end

function Button:pointInside(x, y)
  if self.hitbox.shape == 'circle' then
    local dx = x - self.hitbox.x
    local dy = y - self.hitbox.y
    if dx*dx + dy*dy <= self.hitbox.r * self.hitbox.r then return true end
  end
  if self.hitbox.shape == 'rectangle' then
    local xi = x >= self.hitbox.x and x <= self.hitbox.x + self.hitbox.width
    local yi = y >= self.hitbox.y and y <= self.hitbox.y + self.hitbox.width
    return xi and yi
  end
  return false
end