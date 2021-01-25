FontTestScene = Scene:extend()

function FontTestScene:new()
  self.parity = 0
  self.ttf = 0.5
end

function FontTestScene:update()
  --[[
    To be overwritten by child classes
  --]]
  
  local dt = love.timer.getDelta()
  self.ttf = self.ttf - dt
  if self.ttf < 0 then
    self.ttf = 0.5
    
    if self.parity == 0 then
      self.parity = 1
    elseif self.parity == 1 then
      self.parity = 2
    elseif self.parity == 2 then
      self.parity = 3
    elseif self.parity == 3 then
      self.parity = 0
    end
  end
  
  if inputManager:isPressed('select') then
    if self.force == 0 then
      self.force = 1
    else
      self.force = 0
    end
  end
  
  return self
end

function FontTestScene:drawTopScreen()
  fontManager:setFont('default')
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 30)
  fontManager:setFont('18px')
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 50)
  fontManager:setFont('36px')
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 70)
  fontManager:setFont('18px_bold')
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 120)
  fontManager:setFont('18px_italic')
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 150)
end

function FontTestScene:drawBottomScreen()
  -- love.graphics.setFont(font3)
  love.graphics.print("Testing2", 20, 100)
  love.graphics.print(love.graphics.getFont():getHeight(), 20, 70)
end