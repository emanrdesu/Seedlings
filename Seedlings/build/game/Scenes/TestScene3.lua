TestScene3 = Scene:extend()

function TestScene3:new()
  sandbox = {}
  sandbox['SM'] = sm
  sandbox['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
  sandbox['audio_B'] = love.audio.newSource("Assets/Audio/Piano/b.wav", "static")
  sandbox['audio_C'] = love.audio.newSource("Assets/Audio/Piano/c.wav", "static")
  sandbox['audio_D'] = love.audio.newSource("Assets/Audio/Piano/d.wav", "static")
  sandbox['audio_E'] = love.audio.newSource("Assets/Audio/Piano/e_flat.wav", "static")
  sandbox['audio_F'] = love.audio.newSource("Assets/Audio/Piano/f.wav", "static")
  sandbox['audio_G'] = love.audio.newSource("Assets/Audio/Piano/g.wav", "static")
  
  self.commandManager = CommandManager()
    
  self.commandManager:addCommand(SetNoteTo('firstNote', 'A'))
  self.commandManager:addCommand(SetNoteTo('secondNote', 'B'))
  self.commandManager:addCommand(SetNoteTo('thirdNote', 'C'))
  self.commandManager:addCommand(SetNoteTo('fourthNote', 'B'))
  self.commandManager:addCommand(SetChordTo('chordNote1', 'A', 'chordNote2', 'C', 'chordNote3', 'E'))
  self.commandManager:addCommand(SetNoteTo('fifthNote', 'A'))

  self.nextNote = {}
  self.nextNote['A'] = 'B';
  self.nextNote['B'] = 'C';
  self.nextNote['C'] = 'D';
  self.nextNote['D'] = 'E';
  self.nextNote['E'] = 'F';
  self.nextNote['F'] = 'G';
  self.nextNote['G'] = 'A';
  
  self.prevNote = {}
  self.prevNote['A'] = 'G';
  self.prevNote['B'] = 'A';
  self.prevNote['C'] = 'B';
  self.prevNote['D'] = 'C';
  self.prevNote['E'] = 'D';
  self.prevNote['F'] = 'E';
  self.prevNote['G'] = 'F';

  self.selected = 0
end

function TestScene3:update()
  self.commandManager:update()
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
  end
  
  if inputManager:isPressed('select') then
    self.commandManager:quit()
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selected < self.commandManager:getSize() - 1 then self.selected = self.selected + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selected > 0 then self.selected = self.selected - 1 end
  end
  
  if inputManager:isPressed('dpleft') then
    local command = self.commandManager.commandList:get(self.selected)
    command.value = self.prevNote[command.value];
    command.value1 = self.prevNote[command.value1];
    command.value2 = self.prevNote[command.value2];
    command.value3 = self.prevNote[command.value3];
  end
  
  if inputManager:isPressed('dpright') then
    local command = self.commandManager.commandList:get(self.selected)
    command.value = self.nextNote[command.value];
    command.value1 = self.nextNote[command.value1];
    
    --if not commang.value2 == nil and 
    command.value2 = self.nextNote[command.value2];
    command.value3 = self.nextNote[command.value3];
  end
  
  if inputManager:isPressed('leftshoulder') then
    self.commandManager.timePerLine = self.commandManager.timePerLine - 0.1
  end
  
  if inputManager:isPressed('rightshoulder') then
    self.commandManager.timePerLine = self.commandManager.timePerLine + 0.1
  end
  
  if inputManager:isPressed('b') then
    return TestScene2()
  end
  
  if inputManager:isPressed('a') then
    sandbox['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
    love.audio.play(sandbox['audio_A'])
  end
  
  return self
end

function TestScene3:drawTopScreen()
  love.graphics.print('Time Between Notes: '..tostring(self.commandManager.timePerLine), 150, 10)
  if self.commandManager.isRunning then
    love.graphics.print('running...', 100, 100)
  end
end

function TestScene3:drawBottomScreen()
  
  for i = 0, self.commandManager.commandList:getSize() - 1, 1 do
    local command = self.commandManager.commandList:get(i)
    love.graphics.print(command:toUserString(), 20, 20 * i)
    
    if self.selected == i then
      love.graphics.print('*', 10, 20 * i)
    end
  end
  
end