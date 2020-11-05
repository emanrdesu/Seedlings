GameManager = Object:extend()

function GameManager:new()
  self.currentScene = TitleScene()
  
  
  sm = SoundManager()
  
  test = {}
  test['SM'] = sm
  f = loadstring("SM:play('audio_A')")
  setfenv(f, test)
  f()
end

function GameManager:update()
  -- Debug quitting
  if inputManager:isDown('start') and inputManager:isDown('select') then
    love.event.quit()
  end
  
  self.currentScene = self.currentScene:update()
end

function GameManager:drawTopScreen()
  self.currentScene:drawTopScreen()
  local dt = love.timer.getDelta()
  love.graphics.print("dt = "..tostring(dt), 0, 0)
end

function GameManager:drawBottomScreen()
  self.currentScene:drawBottomScreen()
end