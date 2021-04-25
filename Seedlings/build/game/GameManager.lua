GameManager = Object:extend()

function GameManager:new()
  self.currentScene = TitleScene()
  self.topBG = love.graphics.newImage('Assets/Images/Panels/top/grassB1.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/Panels/bottom/grassB2.png')
end

function GameManager:update()    
  -- Debug quitting
  --[[if inputManager:isDown('start') and inputManager:isDown('select') then
    saveManager:saveData()
    love.event.quit()
  end--]]

  --[[if inputManager:isDown('dpup') and inputManager:isDown('select') then
    saveManager:clearData()
  end--]]
  
  -- If playing on the PC and getting input, don't update the scene
  if not(__PLAYING_ON_PC and inputManager:isReadingInput()) then
      self.currentScene = self.currentScene:update()
  end
end

function GameManager:drawTopScreen()
  local dt = love.timer.getDelta()
  love.graphics.draw(self.topBG, 0, 0)
  self.currentScene:drawTopScreen()
  
  fontManager:setFont('default')
  --local fps = love.timer.getFPS()
  --love.graphics.print("fps = "..tostring(fps), 0, 0)
end

function GameManager:drawBottomScreen()
  love.graphics.draw(self.bottomBG, 0, 0)
  -- If playing on PC and reading input, draw a blank screen with the current text. Otherwise draw scene normally
  if not(__PLAYING_ON_PC and inputManager:isReadingInput()) then
    self.currentScene:drawBottomScreen()
  else 
    draw:rectangle({x=0,y=0,width=Constants.BOTTOM_SCREEN_WIDTH, height = Constants.BOTTOM_SCREEN_HEIGHT, color = Color.WHITE})
    draw:print({x = 10, y = 120, color = Color.BLACK, font = 'default', text = inputManager.pcString})
  end
end