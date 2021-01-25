GameManager = Object:extend()

function GameManager:new()
  self.currentScene = TitleScene()
  self.topBG = love.graphics.newImage('Assets/Images/grassB1.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/grassB2.png')
end

function GameManager:update()    
  -- Debug quitting
  if inputManager:isDown('start') and inputManager:isDown('select') then
    love.event.quit()
  end

  if inputManager:isDown('dpup') and inputManager:isDown('select') then
    saveManager:clearData()
  end

  self.currentScene = self.currentScene:update()
end

function GameManager:drawTopScreen()
  local dt = love.timer.getDelta()
  love.graphics.draw(self.topBG, 0, 0)
  self.currentScene:drawTopScreen()
  
  fontManager:setFont('default')
  love.graphics.print("dt = "..tostring(dt), 0, 0)
end

function GameManager:drawBottomScreen()
  love.graphics.draw(self.bottomBG, 0, 0)
  self.currentScene:drawBottomScreen()
end