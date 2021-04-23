Chord3 = Scene:extend()

function Chord3:new()
  self.topBG1 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_2_1_playScreen.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.botBG2 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_RHeavy_green.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.compyMouthSad = love.graphics.newImage('Assets/Images/Objects/cmouth_sad.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
  self.compyMouthD = love.graphics.newImage('Assets/Images/Objects/cmounth_D.png')
  self.promptArrow = love.graphics.newImage('Assets/Images/Objects/prompt_carrot.png')
  self.whiteSquare = love.graphics.newImage('Assets/Images/Objects/highlight_Note.png')
  self.ANote = love.graphics.newImage('Assets/Images/Objects/A_Note.png')
  self.BNote = love.graphics.newImage('Assets/Images/Objects/B_Note.png')
  self.CNote = love.graphics.newImage('Assets/Images/Objects/C_Note.png')
  self.DNote = love.graphics.newImage('Assets/Images/Objects/D_Note.png')
  self.ENote = love.graphics.newImage('Assets/Images/Objects/E_Note.png')
  self.FNote = love.graphics.newImage('Assets/Images/Objects/F_Note.png')
  self.GNote = love.graphics.newImage('Assets/Images/Objects/G_Note.png')
  self.emptyNote = love.graphics.newImage('Assets/Images/Objects/empty_Note.png')
  self.chordNote = love.graphics.newImage('Assets/Images/Objects/chord_note.png')
  self.blueArrow = love.graphics.newImage('Assets/Images/Objects/blueArrow.png')
  self.note = love.graphics.newImage('Assets/Images/Objects/note_outer.png')
  self.blueNote = love.graphics.newImage('Assets/Images/Objects/note_inner_blue.png')
  self.greenNote = love.graphics.newImage('Assets/Images/Objects/note_inner_green.png')
  self.orangeNote = love.graphics.newImage('Assets/Images/Objects/note_inner_orange.png')
  self.purpleNote = love.graphics.newImage('Assets/Images/Objects/note_inner_purple.png')
  self.redNote = love.graphics.newImage('Assets/Images/Objects/note_inner_red.png')
  self.errorMessage = love.graphics.newImage('Assets/Images/Objects/error_notif_withText.png')
  self.successStar1 = love.graphics.newImage('Assets/Images/Objects/success_stars_topFitted_1.png')
  self.successStar2 = love.graphics.newImage('Assets/Images/Objects/success_stars_topFitted_2.png')
  
  self.noteScaleX = 1
  self.noteScaleY =  1
  self.squareScaleX = 1.25
  self.squareScaleY = 1.25
  self.arrowScaleX = 0.5
  self.arrowScaleY = 0.5
  
  self.starAnimation = {}
  table.insert(self.starAnimation, self.successStar1)
  table.insert(self.starAnimation, self.successStar2)
  
  sandbox = {}
  sandbox['SM'] = sm
  sandbox['audio_A'] = sm.audio['audio_A']
  sandbox['audio_B'] = sm.audio['audio_B']
  sandbox['audio_C'] = sm.audio['audio_C']
  sandbox['audio_D'] = sm.audio['audio_D']
  sandbox['audio_E'] = sm.audio['audio_E']
  sandbox['audio_F'] = sm.audio['audio_F']
  sandbox['audio_G'] = sm.audio['audio_G']
  
  self.commandManager = CommandManager()
  self.commandManager:setTimePerLine(1)
  self.commandManager:addCommand(SetNoteTo('Note1', nil))
  self.commandManager:addCommand(SetNoteTo('Note2', nil))
  self.commandManager:addCommand(SetNoteTo('Note3', nil))
  self.commandManager:addCommand(SetNoteTo('Note4', nil))
  self.commandManager:addCommand(SetNoteTo('Note5', nil))
  self.commandManager:addCommand(SetNoteTo('Note6', nil))
  self.commandManager:addCommand(SetNoteTo('Note7', nil))
  self.commandManager:addCommand(SetNoteTo('Note8', nil))
  
  self.noteTable = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}
  self.chordChoices = {'1', '2', '3'}
  
  self.noteImageTable =  {}
  self.noteImageTable['A'] = self.ANote
  self.noteImageTable['B'] = self.BNote
  self.noteImageTable['C'] = self.CNote
  self.noteImageTable['D'] = self.DNote
  self.noteImageTable['E'] = self.ENote
  self.noteImageTable['F'] = self.FNote
  self.noteImageTable['G'] = self.GNote
  
  self.userNoteImages = {self.emptyNote, self.emptyNote, self.emptyNote, self.emptyNote, self.emptyNote, self.emptyNote, self.emptyNote}
  self.userInput = {'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty'}
  
  self.desiredSequence = {Chord('C'), Chord('D', 'F'), Chord('C', 'F'), Chord('C', 'F'), Chord('C', 'G'), Chord('F', 'A'), Chord('C', 'F', 'A')}
  self.booleanChordMatching = {false, false, false, false, false, false, false}
  self.sequencesMatching = false
  
  self.panel22Flag = true
  self.panel23Flag = false
  
  self.selectedTop = 1
  self.selectedBot = 1
  
  self.chordCounter = 0
  self.chordNote1 = nil
  self.chordNote2 = nil
  self.chordNote3 = nil
  
  self.selectingOptions = false
  self.selectingNotes = false
  self.chord1Note = false
  self.chord2Notes = false
  self.chord3Notes = false
  
  self.playingNotes = false
  self.noteTimer = 8
  self.currentFrame = 1
end

function Chord3:update()
  self.commandManager:update()
  local dt = love.timer.getDelta()
  
  self.currentFrame = self.currentFrame + 3*dt
  if self.currentFrame >= 3 then
    self.currentFrame = 1
  end
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
    self.playingNotes = true
    self.sequencesMatching = false
    
    for i,v in ipairs(self.booleanChordMatching) do
      self.booleanChordMatching[i] = false
    end
    
    for i = 1, #self.userInput do
      if self.userInput[i] == 'empty' then
        
      else 
        if self.userInput[i]:getSize() == 3 then
          if self.userInput[i].note1 == self.desiredSequence[i].note1 and self.userInput[i].note2 == self.desiredSequence[i].note2 and self.userInput[i].note3 == self.desiredSequence[i].note3 then
            self.booleanChordMatching[i] = true
          else
            self.booleanChordMatching[i] = false
          end
        elseif self.userInput[i]:getSize() == 2 then 
          if self.userInput[i].note1 == self.desiredSequence[i].note1 and self.userInput[i].note2 == self.desiredSequence[i].note2 then
            self.booleanChordMatching[i] = true
          else
            self.booleanChordMatching[i] = false
          end
        elseif self.userInput[i]:getSize() == 1 then
          if self.userInput[i].note1 == self.desiredSequence[i].note1 then
            self.booleanChordMatching[i] = true
          else
            self.booleanChordMatching[i] = false
          end
        end
      end
    end
  
    local counter = 0
    for i,v in ipairs(self.booleanChordMatching) do
      if self.booleanChordMatching[i] == true then
        counter = counter + 1
      end
    end
    if counter == 7 then
      self.sequencesMatching = true
    end
  
  end
  
  if self.playingNotes then
    self.noteTimer = self.noteTimer - dt
  end
  
  if self.noteTimer < 0 then
    self.noteTimer = 8
    self.playingNotes = false
  end
  
  if inputManager:isPressed('select') then
    self.commandManager:quit()
  end

  if inputManager:isPressed('y') then
    return MelodyMakerMenu()
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectingOptions then
      if self.selectedBot < #self.chordChoices then self.selectedBot = self.selectedBot + 1 end
    else
      if self.selectedBot < #self.noteTable then self.selectedBot = self.selectedBot + 1 end
    end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
  end
  
  if inputManager:isPressed('dpleft') then
    if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('dpright') then
    if self.selectedTop < #self.userNoteImages then self.selectedTop = self.selectedTop + 1 end
  end
  
  if inputManager:isPressed('x') then
    if self.panel23Flag and self.sequencesMatching then
      return MelodyMakerMenu()
    end
  end
  
  if inputManager:isPressed('b') then
   
  end
  
  if inputManager:isPressed('a') then
    if self.panel23Flag then 
      self.panel22Flag = true
      self.panel23Flag = false
    elseif self.chord3Notes then
      if self.chordCounter == 0 then
        self.chordNote1 = self.noteTable[self.selectedBot]
        self.chordCounter = self.chordCounter + 1
      elseif self.chordCounter == 1 then
        self.chordNote2 = self.noteTable[self.selectedBot]
        self.chordCounter = self.chordCounter + 1
      elseif self.chordCounter == 2 then
        self.chordNote3 = self.noteTable[self.selectedBot]
        self.commandManager:removeCommand(self.selectedTop - 1)
        self.commandManager:insertCommand(self.selectedTop - 1, SetChordTo3('Note1', self.chordNote1, 'Note2', self.chordNote2, 'Note3', self.chordNote3))
        self.userInput[self.selectedTop] = Chord(self.chordNote1, self.chordNote2, self.chordNote3)
        self.userNoteImages[self.selectedTop] = self.chordNote
        self.chordCounter = 0
        self.chord3Notes = false
        self.selectingNotes = false
        self.selectedBot = 1
      end
    elseif self.chord2Notes then
      if self.chordCounter == 0 then
        self.chordNote1 = self.noteTable[self.selectedBot]
        self.chordCounter = self.chordCounter + 1
      elseif self.chordCounter == 1 then
        self.chordNote2 = self.noteTable[self.selectedBot]
        self.commandManager:removeCommand(self.selectedTop - 1)
        self.commandManager:insertCommand(self.selectedTop - 1, SetChordTo2('Note1', self.chordNote1, 'Note2', self.chordNote2))
        self.userInput[self.selectedTop] = Chord(self.chordNote1, self.chordNote2)
        self.userNoteImages[self.selectedTop] = self.chordNote
        self.chordCounter = 0
        self.chord2Notes = false
        self.selectingNotes = false
        self.selectedBot = 1
      end
    elseif self.chord1Note then
        self.chordNote1 = self.noteTable[self.selectedBot]
        self.commandManager:removeCommand(self.selectedTop - 1)
        self.commandManager:insertCommand(self.selectedTop -1, SetChordTo2('Note1', self.chordNote1, 'Note2', self.chordNote1))
        self.userInput[self.selectedTop] = Chord(self.chordNote1)
        self.userNoteImages[self.selectedTop] = self.chordNote
        self.chord1Note = false
        self.selectingNotes = false
        self.selectedBot = 1
    elseif self.selectingOptions then
      self.selectingOptions = false
      if self.selectedBot == 1 then
        self.chord1Note = true
        self.selectingNotes = true
      elseif self.selectedBot == 2 then
        self.chord2Notes = true
        self.selectingNotes = true
      elseif self.selectedBot == 3 then
        self.chord3Notes = true
        self.selectingNotes = true
      end
    elseif self.panel22Flag then
      self.selectingOptions = true
    end
  end
  
  return self
end

function Chord3:drawTopScreen()
  love.graphics.draw(self.topBG1)
  
  if self.panel22Flag then
    
    for i = 1, 7 do
      if i == self.selectedTop then
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      else
        love.graphics.draw(self.chordNote, 40*i*1.15, 40, 0, self.noteScaleX, self.noteScaleY)
      end
    end
    
    if self.commandManager:codeIsRunning() then
      
      love.graphics.draw(self.topBG1)

      love.graphics.draw(self.note, 40*1.15, 160)
      love.graphics.draw(self.note, 40*2*1.15, 160)
      love.graphics.draw(self.note, 40*3*1.15, 140)
      love.graphics.draw(self.note, 40*4*1.15, 120)
      love.graphics.draw(self.note, 40*5*1.15, 110)
      love.graphics.draw(self.note, 40*6*1.15, 110)
      love.graphics.draw(self.note, 40*7*1.15, 120)
      
      if self.noteTimer <= 7 then
        i = 1
        love.graphics.draw(self.blueNote, 43*1.15, 194)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <= 6 then
        i = 2
        love.graphics.draw(self.redNote, 84*1.15, 194)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <= 5 then
        i = 3
        love.graphics.draw(self.orangeNote, 124*1.15, 174)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <= 4 then
        i = 4
        love.graphics.draw(self.purpleNote, 164*1.15, 154)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <= 3 then
        i = 5
        love.graphics.draw(self.greenNote, 204*1.15, 144)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <=2 then
        i = 6 
        love.graphics.draw(self.blueNote, 244*1.15, 144)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <=1 then
        i = 7
        love.graphics.draw(self.redNote, 284*1.15, 154)
        love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note1], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1], 0, 0.75, 0.75)
        if self.desiredSequence[i].note2 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note2], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 20, 0, 0.75, 0.75)
        if self.desiredSequence[i].note3 == "" then
          
        else
          love.graphics.draw(self.noteImageTable[self.desiredSequence[i].note3], 40*i*1.15, self.notePosTable[self.desiredSequence[i].note1] + 40, 0, 0.75, 0.75)
        end
      end
      if self.noteTimer <= 0.1 then
        self.panel23Flag = true
        self.panel22Flag = false
      end
    else
      for i,v in ipairs(self.userNoteImages) do
        love.graphics.draw(self.userNoteImages[i], 40*i*1.15, 140, 0, self.noteScaleX, self.noteScaleY)
        
        if i == self.selectedTop then
          love.graphics.draw(self.blueArrow, 40*i*1.2, 215, -1.55, self.arrowScaleX, self.arrowScaleY)
        end
      end
    end
  --Panel 23
  elseif self.panel23Flag then
    love.graphics.draw(self.topBG1)
    
    for i,v in ipairs(self.noteImageTable) do
      love.graphics.draw(self.noteImageTable[i], 40*i*1.15, 10*i, 0, self.noteScaleX, self.noteScaleY)
    end
    
    love.graphics.draw(self.note, 40*1.15, 160)
    love.graphics.draw(self.note, 40*2*1.15, 160)
    love.graphics.draw(self.note, 40*3*1.15, 140)
    love.graphics.draw(self.note, 40*4*1.15, 120)
    love.graphics.draw(self.note, 40*5*1.15, 110)
    love.graphics.draw(self.note, 40*6*1.15, 110)
    love.graphics.draw(self.note, 40*7*1.15, 120)
      
    love.graphics.draw(self.blueNote, 43*1.15, 194)
    love.graphics.draw(self.redNote, 84*1.15, 194)
    love.graphics.draw(self.orangeNote, 124*1.15, 174)
    love.graphics.draw(self.purpleNote, 164*1.15, 154)
    love.graphics.draw(self.greenNote, 204*1.15, 144)
    love.graphics.draw(self.blueNote, 244*1.15, 144)
    love.graphics.draw(self.redNote, 284*1.15, 154)

    if self.sequencesMatching then
      --love.graphics.print("Yay! the sequences match!", 150, 150)
      love.graphics.draw(self.starAnimation[math.floor(self.currentFrame)])
    else
      --love.graphics.print("Error! The sequences don't match! Try again.", 150, 150)
      love.graphics.draw(self.errorMessage, 90, 90)
    end
  end
end

function Chord3:drawBottomScreen()
  if self.panel22Flag then
    love.graphics.draw(self.botBG2)
    
    if self.userInput[self.selectedTop] == 'empty' then
    else
      draw:print({
        text = "Press 'Y' to return to the menu.",
        x = 20,
        y = 210,
        color = Color.BLACK,
      })
      draw:print({
          text = "Sound"..self.userInput[self.selectedTop].note1,
          x = 50,
          y = 130,
          color = Color.GREEN,
          font = '18px_italic',
        })
      draw:print({
          text = "+ " .. "Sound".. self.userInput[self.selectedTop].note2,
          x = 50,
          y = 150,
          color = Color.GREEN,
          font = '18px_italic',
        })
      
      if self.userInput[self.selectedTop].note3 == "" then
        
      else
        draw:print({
          text = "+ " .. "Sound".. self.userInput[self.selectedTop].note3,
          x = 50,
          y = 170,
          color = Color.GREEN,
          font = '18px_italic',
        })
      end
    end
    
    for i = 1, #self.noteTable do
      if i == self.selectedTop then
        draw:print({
            text = "Note" .. i,
            x = 35,
            y = 100,
            color = Color.BLACK,
            font = '18px_italic',
          })
      end
    end
    
    if self.selectingOptions then
      draw:print({
          text = "How many notes do you want to put in\nyour Chord?",
          x = 20,
          y = 15,
          color = Color.BLACK,
        })
      
      for i,v in ipairs(self.chordChoices) do 
        draw:print({
            text = v,
            x = 190, 
            y = 50 + (40*i),
            color = Color.BLACK,
            })
        
       if i == self.selectedBot then
         love.graphics.draw(self.blueArrow, 150, 50 + (40*i), 0, self.arrowScaleX, self.arrowScaleY)
       end
      end
    elseif self.selectingNotes then
      if self.chord1Note then
        draw:print({
            text = "Select a note!",
            x = 30, 
            y = 25,
            color = Color.BLACK,
            })
      elseif self.chord2Notes then
        if self.chordCounter == 0 then
          draw:print({
            text = "Select 2 notes! Select note 1!",
            x = 30,
            y = 25,
            color = Color.BLACK,
          })
        elseif self.chordCounter == 1 then
          draw:print({
              text = "Select note 2!",
              x = 30,
              y = 25,
              color = Color.BLACK,
            })
        end
      elseif self.chord3Notes then
        if self.chordCounter == 0 then
          draw:print({
            text = "Select 3 notes! Select note 1!",
            x = 30,
            y = 25,
            color = Color.BLACK,
          })
        elseif self.chordCounter == 1 then
          draw:print({
              text = "Select note 2!",
              x = 30,
              y = 25,
              color = Color.BLACK,
            })
        elseif self.chordCounter == 2 then
          draw:print({
              text = "Select note 3!",
              x = 30,
              y = 25,
              color = Color.BLACK,
            })
        end
      end
    
      for i = 1, #self.noteTable do
        if i <=  4 then
          draw:print({
              text = 'Sound' .. self.noteTable[i],
              x = 145,
              y = 75 + (20*i),
              color = Color.BLACK,
            })
          
          if i == self.selectedBot then
            love.graphics.draw(self.blueArrow, 105, 75 + (20*i), 0, self.arrowScaleX, self.arrowScaleY)
          end
        else 
          draw:print({
              text = 'Sound' .. self.noteTable[i],
              x = 250, 
              y = 75 + (20 * (i-4)),
              color = Color.BLACK,
            })
          
          if i == self.selectedBot then
            love.graphics.draw(self.blueArrow, 215, 75 + (20* (i-4)), 0, self.arrowScaleX, self.arrowScaleY)
          end
        end
      end
    else
      draw:print({
        text = "Give this variable a value that matches\nthe song above!",
        x = 13,
        y = 15,
        color = Color.BLACK,
      })
    end
  --Panel 23
  elseif self.panel23Flag then
    love.graphics.draw(self.botBG1)
    
    if self.sequencesMatching then
      draw:print({
          text = "Amazing! Great Job!",
          x = 70,
          y = 30,
          color = Color.BLACK,
        })
      draw:print({
          text = "Press 'A' to try again.",
          x = 70,
          y = 150,
          color = Color.BLACK,
        })
      draw:print({
          text = "Press 'X' to continue.",
          x = 70,
          y = 170,
          color = Color.BLACK,
          })
      
      love.graphics.draw(self.compyEyes, 125, 55)
      love.graphics.draw(self.compyMouthD, 125, 115)
    else
      draw:print({
          text = "Uh oh, something is wrong, and\nthe program had an error!",
          x = 30,
          y = 30,
          color = Color.BLACK,
        })
      draw:print({
          text = "Read the message and see if you\ncan fix the problem! Press 'A' to\ncontinue.",
          x = 30,
          y = 90,
          color = Color.BLACK,
          })
    end
      
  end
end
