TitleScene = Scene:extend()

function TitleScene:new()
  -- Number of seconds to display title screen for
  self.timeLeft = 2
end

function TitleScene:update()
  local dt = love.timer.getDelta()
  self.timeLeft = self.timeLeft - dt;
  if self.timeLeft < 0 then
    return TestScene1()
  else
    return self
  end
end

function TitleScene:drawTopScreen()

end

function TitleScene:drawBottomScreen()
  love.graphics.print("Title! "..tostring(self.timeLeft), 50, 50)
end

