MelodyMakerChordTut = Scene:extend()

function MelodyMakerChordTut:new()
  self.topBG1 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_cmdBox.png')
  self.topBG2 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_2_1_playScreen.png')
  self.topBG3 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_2_tutorialPlay.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.botBG2 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_LHeavy_green.png')
  self.botBG3 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_RHeavy_green.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.compyMouthSad = love.graphics.newImage('Assets/Images/Objects/cmouth_sad.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
  self.compyMouthD = love.graphics.newImage('Assets/Images/Objects/cmounth_D.png')
  self.compyMouthO = love.graphics.newImage('Assets/Images/Objects/cmouth_O.png')
  self.promptArrow = love.graphics.newImage('Assets/Images/Objects/prompt_carrot.png')
  self.whiteSquare = love.graphics.newImage('Assets/Images/Objects/highlight_Note.png')
  self.ANote = love.graphics.newImage('Assets/Images/Objects/A_Note.png')
  self.BNote = love.graphics.newImage('Assets/Images/Objects/B_Note.png')
  self.CNote = love.graphics.newImage('Assets/Images/Objects/C_Note.png')
  self.DNote = love.graphics.newImage('Assets/Images/Objects/D_Note.png')
  self.ENote = love.graphics.newImage('Assets/Images/Objects/E_Note.png')
  self.FNote = love.graphics.newImage('Assets/Images/Objects/F_Note.png')
  self.GNote = love.graphics.newImage('Assets/Images/Objects/G_Note.png')
  self.chordNote = love.graphics.newImage('Assets/Images/Objects/chord_note.png')
  self.emptyNote = love.graphics.newImage('Assets/Images/Objects/empty_Note.png')
  self.blueArrow = love.graphics.newImage('Assets/Images/Objects/blueArrow.png')
  self.xNote = love.graphics.newImage('Assets/Images/Objects/X_note.png')
  self.note = love.graphics.newImage('Assets/Images/Objects/note_outer.png')
  self.blueNote = love.graphics.newImage('Assets/Images/Objects/note_inner_blue.png')
  self.greenNote = love.graphics.newImage('Assets/Images/Objects/note_inner_green.png')
  self.orangeNote = love.graphics.newImage('Assets/Images/Objects/note_inner_orange.png')
  self.purpleNote = love.graphics.newImage('Assets/Images/Objects/note_inner_purple.png')
  self.redNote = love.graphics.newImage('Assets/Images/Objects/note_inner_red.png')
  self.errorMessage = love.graphics.newImage('Assets/Images/Objects/error_notif_withText.png')
  self.successStar1 = love.graphics.newImage('Assets/Images/Objects/success_stars_topFitted_1.png')
  self.successStar2 = love.graphics.newImage('Assets/Images/Objects/success_stars_topFitted_2.png')
  
  sandbox = {}
  sandbox['SM'] = sm
  --[[
  sandbox['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
  sandbox['audio_B'] = love.audio.newSource("Assets/Audio/Piano/b.wav", "static")
  sandbox['audio_C'] = love.audio.newSource("Assets/Audio/Piano/c.wav", "static")
  sandbox['audio_D'] = love.audio.newSource("Assets/Audio/Piano/d.wav", "static")
  sandbox['audio_E'] = love.audio.newSource("Assets/Audio/Piano/e_flat.wav", "static")
  sandbox['audio_F'] = love.audio.newSource("Assets/Audio/Piano/f.wav", "static")
  sandbox['audio_G'] = love.audio.newSource("Assets/Audio/Piano/g.wav", "static")
  --]]
  sandbox['audio_A'] = sm.audio['audio_A']
  sandbox['audio_B'] = sm.audio['audio_B']
  sandbox['audio_C'] = sm.audio['audio_C']
  sandbox['audio_D'] = sm.audio['audio_D']
  sandbox['audio_E'] = sm.audio['audio_E']
  sandbox['audio_F'] = sm.audio['audio_F']
  sandbox['audio_G'] = sm.audio['audio_G']
  
  self.commandManager = CommandManager()
  self.commandManager:addCommand(SetChordTo2('chordNote1', nil, 'chordNote2', nil))
  
  self.desiredSequence = {'A', 'F'}
  self.userInput = {'empty', 'empty'}
  self.notes = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}
  
  
  self.noteScaleX = 1
  self.noteScaleY =  1
  self.squareScaleX = 1
  self.squareScaleY = 1
  self.arrowScaleX = 0.5
  self.arrowScaleY = 0.5
  
  self.panel18Flag = true
  self.panel19Flag = false
  
  self.selectedBot = 1
  
  self.selectingNotes = false
  
  self.chordCounter = 0
  self.chordNote1 = nil
  self.chordNote2 = nil
  
  self.timerFlag = false
  self.playTimer = 2
  self.sequencesMatching = false
end

function MelodyMakerChordTut:update()
  if self.panel19Flag and self.playTimer <=0 and self.sequencesMatching and inputManager:isPressed('a') then return MainMenuScene() end

  self.commandManager:update()
  local dt = love.timer.getDelta()
  
  local counter = 0
  if inputManager:isPressed('start') then
    self.commandManager:start()
    
    self.timerFlag = true
    
    for i = 1, #self.desiredSequence do
      if self.userInput[i] == self.desiredSequence[i] then
        counter = counter + 1
      end
    end
    
    if counter == 2 then
      self.sequencesMatching = true
    end
  end
  
  if self.timerFlag and self.playTimer > 0 then
    self.playTimer = self.playTimer - dt
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectedBot < #self.notes then self.selectedBot = self.selectedBot + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
  end
  
  if inputManager:isPressed('b') then
    if self.selectingNotes then
      self.selectingNotes = false
    end
  end
  
  if inputManager:isPressed('a') then
    
    if self.panel19Flag and self.playTimer <= 0 then
      self.sequencesMatching = false
      self.userInput[1] = 'empty'
      self.userInput[2] = 'empty'
      self.timerFlag = false
      self.playTimer = 2
    end
    
    if self.selectingNotes and self.chordCounter == 1 then
      self.chordNote2 = self.notes[self.selectedBot]
      self.userInput[2] = self.notes[self.selectedBot]
      self.commandManager:removeCommand(0)
      self.commandManager:insertCommand(0, SetChordTo2('chordNote1', self.chordNote1, 'chordNote2', self.chordNote2))
      self.selectingNotes = false
      self.chordCounter = 0
    elseif self.selectingNotes and self.chordCounter == 0 then
      self.chordNote1 = self.notes[self.selectedBot]
      self.userInput[1] = self.notes[self.selectedBot]
      self.chordCounter = self.chordCounter + 1
    elseif self.panel19Flag then
      self.selectingNotes = true
    elseif self.panel18Flag then
      self.panel19Flag = true
      self.panel18Flag = false
    end
  end
    
  return self
end

function MelodyMakerChordTut:drawTopScreen()
  --Panel 18
  if self.panel18Flag then
    love.graphics.draw(self.topBG1)
    love.graphics.draw(self.promptArrow, 105, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthO, 20, 80)
    
    draw:print({
        text = "You know what would be fun to try?",
        x = 117,
        y = 15,
      })
    draw:print({
        text = "I heard that you can add more than\none value to a variable, and it will do\nsomething new!",
        x = 117,
        y = 55,
      })
    draw:print({
        text = "Let's try it! Add more than one\nsound to a note variable!",
        x = 117,
        y = 145,
      })
  --Panel 19
  elseif self.panel19Flag and self.userInput[1] == 'empty' or self.userInput[2] == 'empty' then
    love.graphics.draw(self.topBG3)
    love.graphics.draw(self.promptArrow, 105, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    love.graphics.draw(self.whiteSquare, 220, 150, 0, self.squareScaleX, self.squareScaleY)
    love.graphics.draw(self.emptyNote, 220, 150, 0, self.noteScaleX, self.noteScaleY)
    
    draw:print({
        text = "Give this note variable a value with\n2 sounds: SoundA and SoundF",
        x = 117,
        y = 15,
      })
    draw:print({
        text = "Press 'Start' to play your note!",
        x = 135,
        y = 105,
      })
  elseif self.panel19Flag and not(self.userInput[1] == 'empty' and self.userInput[2] == 'empty') then
    love.graphics.draw(self.topBG3)
    love.graphics.draw(self.promptArrow, 105, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    love.graphics.draw(self.whiteSquare, 220, 175, 0, self.squareScaleX, self.squareScaleY)
    love.graphics.draw(self.chordNote, 220, 175, 0, self.noteScaleX, self.noteScaleY)
    
    draw:print({
        text = "run PlayChord.exe",
        x = 117,
        y = 15,
      })
    
    if self.playTimer <= 0 and self.sequencesMatching then
      draw:print({
          text = "Wow! Did you hear that? It played all\nthe values at the same time! It's\ncalled a CHORD. I know! Let's go back\ninto my program and give all the\nvariables more than one value and\nmake songs with chords!",
          x = 110, 
          y = 40,
          })
    elseif self.playTimer <= 0 and not self.sequencesMatching then
      love.graphics.draw(self.xNote, 220, 175, 0, self.noteScaleX, self.noteScaleY)
      
      draw:print({
          text = "Uh oh, that doesn't seem to be the\nright sounds. Press 'A' to try again!",
          x = 110,
          y = 70,
          })
    end
  end 
end

function MelodyMakerChordTut:drawBottomScreen()
  --Panel 18
  if self.panel18Flag then
    love.graphics.draw(self.botBG1)
    
    draw:print({
        text = "That looks like fun, what do you\nthink will happen if we give a note\nmore than one sound?",
        x = 35,
        y = 30,
        color = Color.BLACK,
      })
    draw:print({
        text = "Press 'A' to continue.",
        x = 80,
        y = 140,
        color = Color.BLACK,
      })
  --Panel 19
  elseif self.panel19Flag then
    love.graphics.draw(self.botBG3)
    
    if not self.selectingNotes then
      draw:print({
          text = "Give this variable TWO sounds, SoundA\nand SoundF!",
          x = 15,
          y = 15,
          color = Color.BLACK,
          })
    end
    
    draw:print({
        text = "Variable",
        x = 35,
        y = 75,
        color = Color.BLACK,
      })
    draw:print({
        text = "Value",
        x = 200,
        y = 75,
        color = Color.BLACK,
      })
    draw:print({
        text = "Note1",
        x = 50,
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
      })
    draw:print({
        text = "=",
        x = 110,
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
      })
    love.graphics.draw(self.blueArrow, 15, 130, 0, self.arrowScaleX, self.arrowScaleY)

    if self.userInput[1] == 'empty' then
      
    else
      draw:print({
          text = "Sound"..self.userInput[1],
          x = 50,
          y = 160,
          color = Color.GREEN,
          font = '18px_italic',
          })
    end
    
    if self.userInput[2] == 'empty' then
     
    else
       draw:print({
          text = "+ " .. "Sound".. self.userInput[2],
          x = 50,
          y = 180,
          color = Color.GREEN,
          font = '18px_italic',
        })
    end
    
    if self.selectingNotes then
      for i = 1, #self.notes do
        draw:print({
            text = 'Sound' .. self.notes[i],
            x = 200,
            y = 75 + (17*i),
            color = Color.BLACK,
          })
        
        if i == self.selectedBot then
          love.graphics.draw(self.blueArrow, 150, 75 + (17*i), 0, self.arrowScaleX, self.arrowScaleY)
        end
      end  
      
      if self.chordCounter == 0 then
        draw:print({
            text = "Choose the FIRST sound!",
            x = 15, 
            y = 15,
            color = Color.BLACK,
            })
      elseif self.chordCounter == 1 then
        draw:print({
            text = "Now choose the SECOND sound!",
            x = 15,
            y = 15,
            color = Color.BLACK,
            })
      end
    end

  end
end

