MultiVarMusicGame = Scene:extend()

function MultiVarMusicGame:new()
    self.topBG = love.graphics.newImage('Assets/Images/woodbackground.png')
    self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
    self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
    self.greenCircle = love.graphics.newImage('Assets/Images/greenCircle.png')
    self.playButton = love.graphics.newImage('Assets/Images/GreenPlayButton.png')
    self.ANote = love.graphics.newImage('Assets/Images/A_Note.png')
    self.BNote = love.graphics.newImage('Assets/Images/B_Note.png')
    self.CNote = love.graphics.newImage('Assets/Images/C_Note.png')
    self.DNote = love.graphics.newImage('Assets/Images/D_Note.png')
    self.ENote = love.graphics.newImage('Assets/Images/E_Note.png')
    self.FNote = love.graphics.newImage('Assets/Images/F_Note.png')
    self.GNote = love.graphics.newImage('Assets/Images/G_Note.png')
    
    self.noteScaleX = 0.8
    self.noteScaleY =  0.8
    self.circleScaleX = 0.3
    self.circleScaleY = 0.3

    -- Table to hold note Images
    self.noteImageTable = {self.ANote, self.BNote, self.CNote, self.DNote, self.ENote, self.FNote, self.GNote}
    
    -- Table to hold note audio values
    self.noteAudioTable = {'audio_A', 'audio_B', 'audio_C', 'audio_D', 'audio_E', 'audio_F', 'audio_G'}
    
    -- Table to hold just note name
    self.noteTable = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}

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
  
    self.selectedTop = 1
    self.selectedBot = 0
end

function MultiVarMusicGame:update()
    self.commandManager:update()
  
    if inputManager:isPressed('start') then
      self.commandManager:start()
    end
    
    if inputManager:isPressed('select') then
      self.commandManager:quit()
    end
    --[[
    if inputManager:isPressed('dpdown') then
      if self.selected < self.commandManager:getSize() - 1 then self.selected = self.selected + 1 end
    end
    
    if inputManager:isPressed('dpup') then
      if self.selected > 0 then self.selected = self.selected - 1 end
    end
    --]]
    if inputManager:isPressed('dpleft') then
     --[[ local command = self.commandManager.commandList:get(self.selected)
      command.value = self.prevNote[command.value];--]]
      if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
    end
    
    if inputManager:isPressed('dpright') then
      --[[local command = self.commandManager.commandList:get(self.selected)
      command.value = self.nextNote[command.value];--]]
      if self.selectedTop < #self.noteImageTable then self.selectedTop = self.selectedTop + 1 end
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
      --sandbox['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
      love.audio.play(sandbox[self.noteAudioTable[self.selectedTop]])
    end
    
    return self
end

function MultiVarMusicGame:drawTopScreen()
  love.graphics.draw(self.topBG)
  
  for i = 1, #self.noteImageTable do
      if i == self.selectedTop then 
        love.graphics.draw(self.greenCircle, 48.5 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      else
        love.graphics.draw(self.whiteCircle, 48.5 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      end
      
      love.graphics.draw(self.noteImageTable[i], 50 * i, 80, 0, self.noteScaleX, self.noteScaleY)

  end
  
end

function MultiVarMusicGame:drawBottomScreen()
  love.graphics.draw(self.bottomBG)
  
  for i = 1, #self.noteTable do
    if i == self.selectedTop then
      draw:print({
        text = 'Press A to hear the ' .. self.noteTable[i] .. ' note!',
        x = 40,
        y = 50,
        color = Color.BLACK,
        font = '18px_bold',
        })

    love.graphics.draw(self.noteImageTable[self.selectedTop], 130, 120, 0, 1.1, 1.1)
    end
    
  end
end
