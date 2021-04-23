MelodyMakerMakeYourOwn = Scene:extend()

function MelodyMakerMakeYourOwn:new()
  self.topBG = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_2_1_playScreen.png')
  self.bottomBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.bottomBG2 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_RHeavy_green.png')
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
  
  self.choices = {}
  self.choices[1] = 'Note'
  self.choices[2] = 'Chord'
  
  self.noteTable = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}
  self.chordChoices = {'2', '3'}
  
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
  
  self.booleanChordMatching = {false, false, false, false, false, false, false}
  self.sequencesMatching = false
  
  self.selectedTop = 1
  self.selectedBot = 1
  
  self.selectingOptions = false
  self.selectingNote = false
  self.selectingChord = false
  self.chord2Note = false
  self.chord3Note = false
  self.playingNotes = false
  
  self.chordCounter = 0
  self.chordNote1 = nil
  self.chordNote2 = nil
  self.chordNote3 = nil
  self.noteTimer = 8
end

function MelodyMakerMakeYourOwn:update()
  self.commandManager:update()
  
  local dt = love.timer.getDelta()
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
    self.playingNotes = true
  end
  
  if self.playingNotes then
    self.noteTimer = self.noteTimer - dt
  end
  
  if self.noteTimer < 0 or self.commandManager:codeIsRunning() == false then
    self.noteTimer = 8
    self.playingNotes = false
  end
  
  if inputManager:isPressed('dpleft') then
    if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('dpright') then
    if self.selectedTop < #self.userNoteImages then self.selectedTop = self.selectedTop + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectingOptions or self.selectingChord then
      if self.selectedBot < #self.choices then self.selectedBot = self.selectedBot + 1 end
    else
      if self.selectedBot < #self.noteTable then self.selectedBot = self.selectedBot + 1 end
    end
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
    if self.chord3Note then
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
        self.chordCounter = 0
        self.chord3Note = false
        self.selectedBot = 1
      end
    elseif self.chord2Note then
      if self.chordCounter == 0 then
        self.chordNote1 = self.noteTable[self.selectedBot]
        self.chordCounter = self.chordCounter + 1
      elseif self.chordCounter == 1 then
        self.chordNote2 = self.noteTable[self.selectedBot]
        self.commandManager:removeCommand(self.selectedTop - 1)
        self.commandManager:insertCommand(self.selectedTop - 1, SetChordTo2('Note1', self.chordNote1, 'Note2', self.chordNote2))
        self.userInput[self.selectedTop] = Chord(self.chordNote1, self.chordNote2)
        self.chordCounter = 0
        self.chord2Note = false
        self.selectedBot = 1
      end
    elseif self.selectingChord then
      if self.selectedBot == 1 then
        self.chord2Note = true
        self.selectingChord = false
      elseif self.selectedBot == 2 then
        self.chord3Note = true
        self.selectingChord = false
      end
    elseif self.selectingNote then
      self.commandManager:removeCommand(self.selectedTop - 1)
      self.commandManager:insertCommand(self.selectedTop - 1, SetNoteTo('Note'..self.selectedBot, self.noteTable[self.selectedBot]))
      self.userInput[self.selectedTop] = Chord(self.noteTable[self.selectedBot])
      self.selectingNote = false
      self.selectedBot = 1
    elseif self.selectingOptions then
      if self.selectedBot == 1 then
        self.selectingNote = true
        self.selectingOptions = false
      elseif self.selectedBot == 2 then
        self.selectingChord = true
        self.selectingOptions = false
      end
    elseif self.selectingOptions == false then
      self.selectingOptions = true
    end
  end
  
  if inputManager:isPressed('x') then
    return MelodyMakerMenu()
  end
  
  return self
end

function MelodyMakerMakeYourOwn:drawTopScreen()
  love.graphics.draw(self.topBG)
  
  for i = 1, 7 do
    if i == self.selectedTop then
      if self.userInput[i] == 'empty' then
        love.graphics.draw(self.emptyNote, 40*i*1.15, 40, 0, self.noteScaleX, self.noteScaleY)
      else
        if self.userInput[i].note1 == "" then
        else
          love.graphics.draw(self.noteImageTable[self.userInput[i].note1], 40*i*1.15, 20, 0, 0.75, 0.75)
        end
        
        if self.userInput[i].note2 == "" then
        else
          love.graphics.draw(self.noteImageTable[self.userInput[i].note2], 40*i*1.15, 40, 0, 0.75, 0.75)
        end
      
        if self.userInput[i].note3 == "" then
        
        else
          love.graphics.draw(self.noteImageTable[self.userInput[i].note3], 40*i*1.15, 60, 0, 0.75, 0.75)
        end
      end
      
      love.graphics.draw(self.blueArrow, 40*i*1.2, 120, -1.55, self.arrowScaleX, self.arrowScaleY)
    else
      love.graphics.draw(self.chordNote, 40*i*1.15, 40, 0, self.noteScaleX, self.noteScaleY)
    end
  end
  
  love.graphics.draw(self.note, 40*1.15, 160)
  love.graphics.draw(self.note, 40*2*1.15, 160)
  love.graphics.draw(self.note, 40*3*1.15, 140)
  love.graphics.draw(self.note, 40*4*1.15, 120)
  love.graphics.draw(self.note, 40*5*1.15, 110)
  love.graphics.draw(self.note, 40*6*1.15, 110)
  love.graphics.draw(self.note, 40*7*1.15, 120)
  
  if self.commandManager:codeIsRunning() then
    if self.noteTimer <= 7 then
      love.graphics.draw(self.blueNote, 43*1.15, 194)
    end
    if self.noteTimer <= 6 then
      love.graphics.draw(self.redNote, 84*1.15, 194)
    end
    if self.noteTimer <= 5 then
      love.graphics.draw(self.orangeNote, 124*1.15, 174)
    end
    if self.noteTimer <= 4 then
      love.graphics.draw(self.purpleNote, 164*1.15, 154)
    end
    if self.noteTimer <= 3 then
      love.graphics.draw(self.greenNote, 204*1.15, 144)
    end
    if self.noteTimer <=2 then 
      love.graphics.draw(self.blueNote, 244*1.15, 144)
    end
    if self.noteTimer <=1 then
      love.graphics.draw(self.redNote, 284*1.15, 154)
    end
  end
end

function MelodyMakerMakeYourOwn:drawBottomScreen()
  love.graphics.draw(self.bottomBG2)
  
  if not self.selectingOptions and not self.selectingNote and not self.selectingChord and not self.chord2Note and not self.chord3Note then
    draw:print({
      text = "Press 'A' to select a sound!\nPress 'X' to go back to the menu.",
      x = 15,
      y = 15,
      color = Color.BLACK,
    })
  end
  
  if self.userInput[self.selectedTop] == 'empty' then
    else
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
        text = "Which would you like to choose,\na Note or a Chord?",
        x = 20,
        y = 15,
        color = Color.BLACK,
      })
    
    for i = 1, #self.choices do
      local choice = self.choices[i]
      
      draw:print({
          text = choice,
          x = 180,
          y =  80 * i,
          color = Color.BLACK,
          font = '18px_bold',
        })
      
      if i == self.selectedBot then
        draw:print({
            text = '*',
            x = 170,
            y = 80 * i,
            color = Color.BLACK,
            font = '18px_bold',
          })
      end
    end
  end
  
  if self.selectingNote then
     draw:print({
            text = 'Select the Note you want.',
            x = 20,
            y = 15,
            color = Color.BLACK,
          })
    
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
  end
  
  if self.selectingChord then
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
            y = 80 * i,
            color = Color.BLACK,
            })
        
         if i == self.selectedBot then
           love.graphics.draw(self.blueArrow, 150, 80 * i, 0, self.arrowScaleX, self.arrowScaleY)
         end
      end
  elseif self.chord2Note then
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
  elseif self.chord3Note then
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
end