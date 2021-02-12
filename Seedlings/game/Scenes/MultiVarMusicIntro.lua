MultiVarMusicIntro = Scene:extend()

function MultiVarMusicIntro:new()
    self.topBG = love.graphics.newImage('Assets/Images/woodbackground.png')
    self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
    self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
    self.greenCircle = love.graphics.newImage('Assets/Images/greenCircle.png')
    self.whiteSquare = love.graphics.newImage('Assets/Images/whiteSquare.png')
    self.yellowSquare = love.graphics.newImage('Assets/Images/yellowSquare.png')
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
    self.squareScaleX = 0.65
    self.squareScaleY = 0.65
    
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
    self.selectedBot = 1
    
    --  Boolean table & flag to check if all notes have been played so we can go to the next scene
    self.noteSelected = {false, false, false, false, false, false, false}
    self.notesPlayed = false
    
    
    -- Boolean flags to switch to matching game
    self.matchingNotes = false
    self.selectingOptions = false
    self.sequencesMatching = false
    self.commandManagerFlag = false
    -- Table for desired sequence of notes to match
    self.desiredSequence = {'A', 'C', 'E', 'G'}
    -- Table for available note options
    self.noteOptions = {'A', 'C', 'E', 'G'}
    -- Table for images for sequence
    self.noteOptionImages = {self.ANote, self.CNote, self.ENote, self.GNote}
    -- Table for note audio for matching
    self.noteOptionAudio = {'audio_A', 'audio_C', 'audio_E', 'audio_G'}
    -- Table for user input (initialized to nil)
    self.userSequence = {nil, nil, nil, nil}
    
    
    
end

function MultiVarMusicIntro:update()
    self.commandManager:update()
  
    if inputManager:isPressed('start') then
      self.commandManager:start()
    end
    
    if inputManager:isPressed('select') then
      self.commandManager:quit()
    end
    
    if inputManager:isPressed('dpleft') then
     --[[ local command = self.commandManager.commandList:get(self.selected)
      command.value = self.prevNote[command.value];--]]
      if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
    end
    
    if inputManager:isPressed('dpright') then
      --[[local command = self.commandManager.commandList:get(self.selected)
      command.value = self.nextNote[command.value];--]]
      if not self.matchingNotes then
        if self.selectedTop < #self.noteImageTable then self.selectedTop = self.selectedTop + 1 end
      end
      
      if self.matchingNotes then
        if self.selectedTop < #self.noteOptionImages then self.selectedTop = self.selectedTop + 1 end
      end
    end
    
    if inputManager:isPressed('dpup') then
      if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
    end
    
    if inputManager:isPressed('dpdown') then
      if self.selectedBot < #self.noteOptions then self.selectedBot = self.selectedBot + 1 end
    end
    
    if inputManager:isPressed('leftshoulder') then
      self.commandManager.timePerLine = self.commandManager.timePerLine - 0.1
    end
    
    if inputManager:isPressed('rightshoulder') then
      self.commandManager.timePerLine = self.commandManager.timePerLine + 0.1
    end
    
    if inputManager:isPressed('b') then
      if self.matchingNotes then
        self.selectingOptions = false
      end
    end
    
    if inputManager:isPressed('a') then
      --sandbox['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
      if self.matchingNotes and self.selectingOptions then
        self.userSequence[self.selectedTop] = self.noteOptions[self.selectedBot]
        self.selectingOptions = false
      elseif self.matchingNotes then
        self.selectingOptions = true
      end
      
      if not self.matchingNotes then
        love.audio.play(sandbox[self.noteAudioTable[self.selectedTop]])
        self.noteSelected[self.selectedTop] = true
      end
      
    end
    
    local counter = 0
    for i = 1, #self.noteSelected do
      if self.noteSelected[i] then
        counter = counter + 1
      end
    end
    
    if counter == #self.noteSelected then
      self.notesPlayed = true
    end
    
    if counter == #self.noteSelected and self.notesPlayed and inputManager:isPressed('start') then
      self.matchingNotes = true
      self.selectedTop = 1
    end
    
    local counter2 = 0
    for i = 1, #self.desiredSequence do
      if self.userSequence[i] == self.desiredSequence[i] then
        counter2 = counter2 + 1
      end
    end
    
    if counter2 == #self.desiredSequence then
      self.sequencesMatching = true
    end
    
    if self.sequencesMatching and not self.commandManagerFlag then
      for i = 1, #self.desiredSequence do
        self.commandManager:addCommand(SetNoteTo(i .. 'Note', self.userSequence[i]))
      end
      self.commandManagerFlag = true
    --[[
    self.commandManager:addCommand(SetNoteTo('firstNote', 'A'))
    self.commandManager:addCommand(SetNoteTo('secondNote', 'B'))
    self.commandManager:addCommand(SetNoteTo('thirdNote', 'C'))
    self.commandManager:addCommand(SetNoteTo('fourthNote', 'B'))
    self.commandManager:addCommand(SetNoteTo('fifthNote', 'A'))
    --]]
    end
    
    return self
end

function MultiVarMusicIntro:drawTopScreen()
  love.graphics.draw(self.topBG)
  
  if not self.matchingNotes then
    for i = 1, #self.noteImageTable do
        if i == self.selectedTop then 
          love.graphics.draw(self.greenCircle, 48.5 * i, 80, 0, self.circleScaleX, self.circleScaleY)
        else
          love.graphics.draw(self.whiteCircle, 48.5 * i, 80, 0, self.circleScaleX, self.circleScaleY)
        end
        
        love.graphics.draw(self.noteImageTable[i], 50 * i, 80, 0, self.noteScaleX, self.noteScaleY)

    end
  end
  
  if self.matchingNotes then
    
    for i =  1, #self.desiredSequence do
      
      if i == self.selectedTop then
        love.graphics.draw(self.yellowSquare, 70 * i, 120, 0, self.squareScaleX, self.squareScaleY)
      else
        love.graphics.draw(self.whiteSquare, 70 * i, 120, 0, self.squareScaleX, self.squareScaleY)
      end
      
      local note = self.userSequence[i]
      if not note == nil then
        if note == 'A' then
          love.graphics.draw(self.ANote, 70 * i, 120)
        elseif note == 'C' then
          love.graphics.draw(self.CNote, 70 * i, 120)
        elseif note == 'E' then
          love.graphics.draw(self.ENote, 70 * i, 120)
        elseif note == 'G' then
          love.graphics.draw(self.GNote, 70 * i, 120)
        end
      end
            
      love.graphics.draw(self.noteOptionImages[i], 70 *  i, 70)
    end
    
  end
end

function MultiVarMusicIntro:drawBottomScreen()
  love.graphics.draw(self.bottomBG)
  
  if not self.matchingNotes then
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
      
      if self.notesPlayed then
        draw:print({
            text = "Now that you've listened to all the notes,\npress START to continue",
            x = 3,
            y = 170,
            color = Color.BLACK,
            font = '18px_italic',
            })
      end
    end
  end
  
  if self.matchingNotes then
    if self.selectingOptions then
      for i = 1, #self.noteOptions do
        
        draw:print({
            text = "Select the note using up and down\non the dpad",
            x = 5,
            y = 5,
            color = Color.BLACK,
            font = '18px_italic',
          })
        
        love.graphics.draw(self.noteOptionImages[i], 60 * i,  70)
        
        if i == self.selectedBot then
          love.graphics.print('*', 60 * i, 90)
        end
      end
    end
    
    if self.sequencesMatching then
      draw:print({
          text = "Congrats you matched the melody!\nPress start to play it",
          x = 5,
          y = 5,
          color = Color.BLACK,
          font = '18px_italic',
          })
    end
  end
end
