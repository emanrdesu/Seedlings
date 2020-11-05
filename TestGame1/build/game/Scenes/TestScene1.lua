TestScene1 = Scene:extend()

function TestScene1:new()
  self.persistTime = 1.5
  self.commandList = ArrayList()
  self.commandTimes = ArrayList()
end

function TestScene1:update()
  local dt = love.timer.getDelta()
  
  --[[
  local joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  
  if joystick ~= nil and joystick:isGamepadDown('a') then
    self.commandList:add('a')
  end
  
  if joystick ~= nil and joystick:isGamepadDown('b') then
    self.commandList:add('b')
  end
  
  if joystick ~= nil and joystick:isGamepadDown('x') then
    self.commandList:add('x')
  end
  
  if joystick ~= nil and joystick:isGamepadDown('y') then
    self.commandList:add('y')
  end
  --]]
  
  while true do
    if self.commandTimes:getSize() == 0 then break end
    local lastTime = self.commandTimes:get(0)
    
    if love.timer.getTime() - lastTime > self.persistTime then
      self.commandList:remove(0)
      self.commandTimes:remove(0)
    else
      break
    end
  end
  
  if inputManager:isPressed('a') then
    self.commandList:add('a')
    self.commandTimes:add(love.timer.getTime())
    local touch = inputManager:getLastTouch()
    if touch == nil then 
      self.commandList:add('nil') 
      self.commandTimes:add(love.timer.getTime())
    else
      self.commandList:add(tostring(touch.x).."   "..tostring(touch.y).."   "..touch.eventType)
      self.commandTimes:add(love.timer.getTime())
    end
    
  end
  
  if inputManager:isPressed('b') then
    self.commandList:add('b')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:isPressed('x') then
    self.commandList:add('x')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:isPressed('y') then
    self.commandList:add('y')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:isPressed('start') then
    self.commandList:add('start')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:isPressed('select') then
    self.commandList:add('select')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:hasTouchPress() then
    self.commandList:add('press')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if inputManager:hasTouchRelease() then
    self.commandList:add('release')
    self.commandTimes:add(love.timer.getTime())
  end
  
  if self.commandList:getSize() > 5 then
    return TestScene2()
  end
  
  return self
end

function TestScene1:drawTopScreen()
  local size = self.commandList:getSize()
  for i = 0, size - 1, 1 do
    love.graphics.print(self.commandList:get0Indexed(i).."  "..tostring(self.commandTimes:get(i)), 50, 20*(i+1))
  end
end

function TestScene1:drawBottomScreen()
end