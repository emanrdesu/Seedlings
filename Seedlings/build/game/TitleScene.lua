TitleScene = Scene:extend()

function TitleScene:new()
  -- Number of seconds to display title screen for
  self.timeLeft = 3
end

function TitleScene:update()
  local dt = love.timer.getDelta()
  self.timeLeft = self.timeLeft - dt;
  if self.timeLeft < 0 then
    return MainMenuScene()
  else
    return self
  end
end

function TitleScene:draw()
  love.graphics.print("Title! "..tostring(self.timeLeft), 50, 50)
end