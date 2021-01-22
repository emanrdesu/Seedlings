MainMenuScene = Scene:extend()

function MainMenuScene:new()
  self.timeLeft = 2
end

function MainMenuScene:update()
  local dt = love.timer.getDelta()
  self.timeLeft = self.timeLeft - dt;
  
  if self.timeLeft < 0 then
    love.event.quit()
    return self
  else 
    return self
  end
end

function MainMenuScene:drawTopScreen()

end

function MainMenuScene:drawBottomScreen()
  love.graphics.print("Menu! "..tostring(self.timeLeft), 50, 50)
end