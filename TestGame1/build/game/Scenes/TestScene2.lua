TestScene2 = Scene:extend()

function TestScene2:new()
  sandbox = {}
  sandbox['x'] = 5
  sandbox['y'] = 5
  self.commandManager = CommandManager()
  self.selected = 0
end

function TestScene2:update()
  self.commandManager:update()
  
  if inputManager:isPressed('a') then
    if self.commandManager:getSize() > 0 then
      local command = self.commandManager.commandList:get(self.selected)
      command.value = command.value + 1
    end
  end
  
  if inputManager:isPressed('x') then
    self.commandManager:addCommand(SetValTo('x', 0))
  end
  
  if inputManager:isPressed('y') then
    self.commandManager:addCommand(SetValTo('y', 0))
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selected < self.commandManager:getSize() - 1 then self.selected = self.selected + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selected > 0 then self.selected = self.selected - 1 end
  end
  
  if inputManager:isPressed('b') then
    self.commandManager:removeCommand(self.selected)
    if self.selected > 0 and self.selected > self.commandManager:getSize() - 1 then self.selected = self.selected - 1 end
  end
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
  end
  
  if inputManager:isPressed('select') then
    self.commandManager:quit()
  end
  
  if sandbox['x'] == 7 then
    return TestScene3()
  end
  
  return self
end

function TestScene2:drawTopScreen()
  love.graphics.print("x = "..tostring(sandbox['x']), 50, 50)
  love.graphics.print("y = "..tostring(sandbox['y']), 200, 50)
  
  if self.commandManager.isRunning then
    love.graphics.print('running...', 100, 100)
  end
end

function TestScene2:drawBottomScreen()
  
  for i = 0, self.commandManager.commandList:getSize() - 1, 1 do
    local command = self.commandManager.commandList:get(i)
    love.graphics.print(command:toUserString(), 20, 20 * i)
    
    if self.selected == i then
      love.graphics.print('*', 10, 20 * i)
    end
  end
  
end