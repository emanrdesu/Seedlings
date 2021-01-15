TitleScene = Scene:extend()

function TitleScene:new()
  -- Number of seconds to display title screen for
  self.apple = {
    x = 0.7 * Constants.TOP_SCREEN_WIDTH,
    y = -100,
    r = 0,
    vx = 0,
    vy = 180,
    vr = 0,
    scaleX = 0.4,
    scaleY = 0.4,
    state = "FALLING",
    stopY = 0.25 * Constants.TOP_SCREEN_HEIGHT,
    stopX = 0.3 * Constants.TOP_SCREEN_WIDTH,
    img = love.graphics.newImage('Assets/Images/apple.png')
  }
  self.waitUntilCanStart = 1.5
  self.topBG = love.graphics.newImage('Assets/Images/grassB1.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/grassB2.png')
end

function TitleScene:update()
  local dt = love.timer.getDelta()
  
  self.apple.x = self.apple.x + dt * self.apple.vx
  self.apple.y = self.apple.y + dt * self.apple.vy
  self.apple.r = self.apple.r + dt * self.apple.vr  
  
  if self.apple.state == "FALLING" then 
    if self.apple.y >= self.apple.stopY then 
      self.apple.state = "ROLLING" 
      self.apple.vx = -130
      self.apple.vy = 0
      self.apple.vr = -6.5
    end
  elseif self.apple.state == "ROLLING" then
    if math.abs(self.apple.r % (2 * math.pi)) <= 0.13 and self.apple.x <= self.apple.stopX then
      self.apple.state = "STATIONARY"
      self.apple.r = 0
      self.apple.vx = 0
      self.apple.vy = 0
      self.apple.vr = 0
    end
  else 
    self.waitUntilCanStart = self.waitUntilCanStart - dt
  end
  
  if self.waitUntilCanStart < 0 and inputManager:isPressed('start')  then
    return TestScene1()
  else
    return self
  end
end

function drawRotatedAroundCenter(img, x, y, r, scaleX, scaleY)
  -- Rotates image about the CENTER point
  local w, h = img:getDimensions()
  w = w * scaleX
  h = h * scaleY
  
  local cx = x + (w / 2)
  local cy = y + (h / 2)
  
  local vecX = x - cx
  local vecY = y - cy
  
  -- rotate vecX by r degrees
  local newVecX = vecX * math.cos(r) - vecY * math.sin(r)
  local newVecY = vecX * math.sin(r) + vecY * math.cos(r)
  
  local dx = newVecX - vecX
  local dy = newVecY - vecY
  
  love.graphics.draw(img, x + dx, y + dy, r, scaleX, scaleY)
end

function TitleScene:drawTopScreen()
  love.graphics.draw(self.topBG, 0, 0)
  drawRotatedAroundCenter(self.apple.img, self.apple.x, self.apple.y, self.apple.r, self.apple.scaleX, self.apple.scaleY)
  if self.apple.state == "STATIONARY" then
    local w, h = self.apple.img:getDimensions()
    w = w * self.apple.scaleX
    h = h * self.apple.scaleY
    fontManager:setFont('36px')
    love.graphics.print("Seedlings", self.apple.x + w, self.apple.y + 30, 0)
  end
end

function TitleScene:drawBottomScreen()
  love.graphics.draw(self.bottomBG, 0, 0)
  if self.waitUntilCanStart <= 0 then
    fontManager:setFont('18px')
    local w = fontManager:getWidth("Press start to play!")
    local h = fontManager:getHeight("Press start to play!")
    local offsetX = (Constants.BOTTOM_SCREEN_WIDTH - w) / 2.0
    local offsetY = (Constants.BOTTOM_SCREEN_HEIGHT - h) / 2.0
    love.graphics.print("Press start to play!", offsetX, offsetY)
  end
end

