MultiVarMelodyMaker = Scene:extend()

function MultiVarMelodyMaker:new()

  self.topBG = love.graphics.newImage('Assets/Images/Panels/top/woodbackground.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.whiteSquare = love.graphics.newImage('Assets/Images/Objects/whiteSquare.png')
  self.yellowSquare = love.graphics.newImage('Assets/Images/Objects/yellowSquare.png')
  self.playButton = love.graphics.newImage('Assets/Images/Objects/GreenPlayButton.png')
  self.arrow = love.graphics.newImage('Assets/Images/Objects/blueArrow.png')
  self.ANote = love.graphics.newImage('Assets/Images/Objects/A_Note.png')
  self.BNote = love.graphics.newImage('Assets/Images/Objects/B_Note.png')
  self.CNote = love.graphics.newImage('Assets/Images/Objects/C_Note.png')
  self.DNote = love.graphics.newImage('Assets/Images/Objects/D_Note.png')
  self.ENote = love.graphics.newImage('Assets/Images/Objects/E_Note.png')
  self.FNote = love.graphics.newImage('Assets/Images/Objects/F_Note.png')
  self.GNote = love.graphics.newImage('Assets/Images/Objects/G_Note.png')
  
  self.noteScaleX = 0.8
  self.noteScaleY =  0.8
  self.squareScaleX = 0.65
  self.squareScaleY = 0.65
  self.arrowScaleX = 0.75
  self.arrowScaleY = 0.75
  
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
    
  self.commandManager:addCommand(SetNoteTo('Note1', nil))
  self.commandManager:addCommand(SetNoteTo('Note2', nil))
  self.commandManager:addCommand(SetNoteTo('Note3', nil))
  self.commandManager:addCommand(SetNoteTo('Note4', nil))
  self.commandManager:addCommand(SetNoteTo('Note5', nil))
  self.commandManager:addCommand(SetNoteTo('Note6', nil))
  self.commandManager:addCommand(SetNoteTo('Note7', nil))
  self.commandManager:addCommand(SetNoteTo('Note8', nil))

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
  
  self.choices = {}
  self.choices[1] = 'Note'
  self.choices[2] = 'Chord'
  
  self.notes = {}
  self.notes[1] = 'A'
  self.notes[2] = 'B'
  self.notes[3] = 'C'
  self.notes[4] = 'D'
  self.notes[5] = 'E'
  self.notes[6] = 'F'
  self.notes[7] = 'G'
  
  self.selectedTop = 0
  self.selectedBot = 1
  
  self.selectingOptions = false
  self.selectingNote = false
  self.selectingChord = false
  
  self.chordCounter = 0
  self.chordNote1 = nil
  self.chordNote2 = nil
  self.chordNote3 = nil
end

function MultiVarMelodyMaker:update()
  self.commandManager:update()
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
  end
  
  if inputManager:isPressed('select') then
    self.commandManager:quit()
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectedTop < self.commandManager:getSize() - 1 then self.selectedTop = self.selectedTop + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedTop > 0 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('dpleft') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
    
    --local command = self.commandManager.commandList:get(self.selectedTop)
    --command.value = self.prevNote[command.value]
  end
  
  if inputManager:isPressed('dpright') then
    if self.selectingNote or self.selectingChord then
      if self.selectedBot < #self.notes then self.selectedBot = self.selectedBot + 1 end
    end
    
    if not self.selectingNote or not self.selectingChord then
      if self.selectedBot < #self.choices then self.selectedBot = self.selectedBot + 1 end
    end
    
    --local command = self.commandManager.commandList:get(self.selectedTop)
    --command.value = self.nextNote[command.value]
  end
  
  if inputManager:isPressed('leftshoulder') then
    self.commandManager.timePerLine = self.commandManager.timePerLine - 0.1
  end
  
  if inputManager:isPressed('rightshoulder') then
    self.commandManager.timePerLine = self.commandManager.timePerLine + 0.1
  end
  
  if inputManager:isPressed('b') then
    
    if self.selectingOptions then
      self.selectingOptions = false
    end
    
    if self.selectingNote then
      self.selectingNote = false
    end
     
    if self.selectingChord then
      self.selectingChord = false
    end
    
  end
  
  
  if inputManager:isPressed('a') then
    if self.selectingChord then
        if self.chordCounter == 0 then
          self.chordNote1 = self.notes[self.selectedBot]
          self.chordCounter = self.chordCounter + 1
        elseif self.chordCounter == 1 then
          self.chordNote2 = self.notes[self.selectedBot]
          self.chordCounter =  self.chordCounter + 1
        elseif self.chordCounter == 2 then
          self.chordNote3 = self.notes[self.selectedBot]
          self.commandManager:removeCommand(self.selectedTop)
          self.commandManager:insertCommand(self.selectedTop, SetChordTo3('chordNote1', self.chordNote1, 'chordNote2', self.chordNote2, 'chordNote3', self.chordNote3))
          self.chordCounter = 0
          self.selectingChord = false
          self.selectedBot = 1
        end
    elseif self.selectingNote then
      self.commandManager:removeCommand(self.selectedTop)
      self.commandManager:insertCommand(self.selectedTop, SetNoteTo('Note'..self.selectedBot, self.notes[self.selectedBot]))
      self.selectingNote = false
      self.selectedBot = 1
    elseif self.selectingOptions then
      if self.selectedBot ==  1 then
        self.selectingNote = true
        self.selectingOptions = false
      elseif self.selectedBot == 2 then 
        self.selectingChord = true
        self.selectingOptions = false
      end
      
    elseif not self.selectingOptions then
      self.selectingOptions = true
    end
    
  end
  
  return self
end

function MultiVarMelodyMaker:drawTopScreen()
  love.graphics.draw(self.topBG)
  
  for i = 0, self.commandManager.commandList:getSize() - 1 do
    local command = self.commandManager.commandList:get(i)
    love.graphics.print(command:toUserString(), 20, 30 * i)
    
    if self.selectedTop == i then
      love.graphics.print('*', 10, 30 * i)
    end
  end
end

function MultiVarMelodyMaker:drawBottomScreen()
  love.graphics.draw(self.bottomBG)
  
  if self.selectingOptions then
    for i = 1, #self.choices do
      local choice = self.choices[i]
      
      draw:print({
          text = choice,
          x = 90 * i,
          y =  80,
          color = Color.BLACK,
          font = '18px_bold',
        })
      
      if i == self.selectedBot then
        draw:print({
            text = '*',
            x = 80 * i,
            y = 80,
            color = Color.BLACK,
            font = '18px_bold',
          })
      end
      
    end
  end
  
  if self.selectingNote then
    draw:print({
            text = 'Select the Note you want.',
            x = 40,
            y = 0,
            color = Color.BLACK,
            font = '18px_bold',
          })
    
    for i = 1, #self.notes do
      draw:print({
          text = self.notes[i],
          x = 28 * i,
          y = 50,
          color = Color.BLACK,
          font = '18px_bold',
        })
      
      if i == self.selectedBot then
        love.graphics.draw(self.arrow, 25 * i, 130, -1.58, self.arrowScaleX, self.arrowScaleY)
      end
    
    end
  end
  
  if self.selectingChord then
    draw:print({
            text = 'Choose 3 notes to make a chord',
            x = 40,
            y = 0,
            color = Color.BLACK,
            font = '18px_bold',
          })
        
    for i = 1, #self.notes do
      draw:print({
          text = self.notes[i],
          x = 28 * i,
          y = 50,
          color = Color.BLACK,
          font = '18px_bold',
        })
      
      if i == self.selectedBot then
        love.graphics.draw(self.arrow, 25 * i, 130, -1.58, self.arrowScaleX, self.arrowScaleY)
      end
    end
  end
  
end