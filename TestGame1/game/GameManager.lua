GameManager = Object:extend()

function GameManager:new()
  self.currentScene = TitleScene()
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
  self.currentScene:drawTopScreen()
  
  fontManager:setFont('default')
  love.graphics.print("dt = "..tostring(dt), 0, 0)
end

function GameManager:drawBottomScreen()
  self.currentScene:drawBottomScreen()
end