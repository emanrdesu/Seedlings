MelodyMakerMinigame = Scene:extend()

function MelodyMakerMinigame:new()
  self.topBG1 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_cmdBox.png')
  self.topBG2 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_2_1_playScreen.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.botBG2 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_LHeavy_green.png')
  self.botBG3 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_RHeavy_green.png')
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
  
  self.starAnimation = {}
  table.insert(self.starAnimation, self.successStar1)
  table.insert(self.starAnimation, self.successStar2)
  
  self.noteImageTable = {}
  self.noteImageTable[1] = self.ANote
  self.noteImageTable[2] = self.BNote
  self.noteImageTable[3] = self.CNote
  self.noteImageTable[4] = self.DNote
  self.noteImageTable[5] = self.ENote
  self.noteImageTable[6] = self.FNote
  self.noteImageTable[7] = self.GNote
  
  self.userNotes = {}
  self.userNotes[1] = self.emptyNote
  self.userNotes[2] = self.emptyNote
  self.userNotes[3] = self.emptyNote
  self.userNotes[4] = self.emptyNote
  self.userNotes[5] = self.emptyNote
  self.userNotes[6] = self.emptyNote
  self.userNotes[7] = self.emptyNote
  
  self.noteTable = {}
  self.noteTable[1] = 'A'
  self.noteTable[2] = 'B'
  self.noteTable[3] = 'C'
  self.noteTable[4] = 'D'
  self.noteTable[5] = 'E'
  self.noteTable[6] = 'F'
  self.noteTable[7] = 'G'
  
  self.userInput = {}
  self.userInput[1] = 'empty'
  self.userInput[2] = 'empty'
  self.userInput[3] = 'empty'
  self.userInput[4] = 'empty'
  self.userInput[5] = 'empty'
  self.userInput[6] = 'empty'
  self.userInput[7] = 'empty'
  
  self.desiredSequence = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}
  self.correctChoices = {false, false, false, false, false, false, false}
  
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
  
  self.noteScaleX = 1
  self.noteScaleY =  1
  self.squareScaleX = 1.25
  self.squareScaleY = 1.25
  self.arrowScaleX = 0.5
  self.arrowScaleY = 0.5
  
  self.panel9Flag = true
  self.panel10Flag = false
  self.panel11Flag = false
  self.panel12Flag = false
  
  self.aCounter = 0
  self.selectedTop = 1
  self.selectedBot = 1
  self.noteTimer = 8
  self.playingNotes = false
  
  self.selectingValue = false
  self.sequencesMatch = false
  
  self.currentFrame = 1
end

function MelodyMakerMinigame:update()
  self.commandManager:update()
  local dt = love.timer.getDelta()
  
  self.currentFrame = self.currentFrame + 3*dt
  if self.currentFrame >= 3 then
    self.currentFrame = 1
  end
  
  if inputManager:isPressed('start') then
    self.commandManager:start()
    self.playingNotes = true
    self.sequencesMatch = false
    
    for i,v in ipairs(self.userInput) do
      self.correctChoices[i] = false
    end
    
    local counter = 0
    for i,v in ipairs(self.userInput) do
      if self.userInput[i] == self.desiredSequence[i] then
        counter = counter + 1
        self.correctChoices[i] = true
      end
    end
    
    if counter == 7 then
      self.sequencesMatch = true
    end
  end
  
  if self.playingNotes then
    self.noteTimer = self.noteTimer - dt
  end
  
  if self.noteTimer < 0 then
    self.noteTimer = 8
    self.playingNotes = false
  end
  
  if inputManager:isPressed('dpright') then
    if self.selectedTop < #self.userNotes then self.selectedTop = self.selectedTop + 1 end
  end
  
  if inputManager:isPressed('dpleft') then
    if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectedBot < #self.noteTable then self.selectedBot = self.selectedBot + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
  end
  
  if inputManager:isPressed('b') then
    if self.selectingValue then
      self.selectingValue = false
    end
  end
  
  if inputManager:isPressed('a') then
    
    if self.panel12Flag then
      self.panel11Flag = true
      self.panel12Flag = false
    elseif self.selectingValue then
      self.userNotes[self.selectedTop] = self.noteImageTable[self.selectedBot]
      self.userInput[self.selectedTop] = self.noteTable[self.selectedBot]
      self.commandManager:removeCommand(self.selectedTop-1)
      self.commandManager:insertCommand(self.selectedTop-1, SetNoteTo('Note'..self.selectedBot, self.noteTable[self.selectedBot]))
      self.selectingValue = false
    elseif self.panel11Flag then
      self.selectingValue = true
    elseif self.panel10Flag then
      self.panel11Flag = true
      self.panel10Flag = false
    elseif self.panel9Flag and self.aCounter == 1 then
      self.panel10Flag = true
      self.panel9Flag = false
      self.aCounter = 0
    elseif self.panel9Flag then
      self.aCounter = 1
    end
  end
  
  if inputManager:isPressed('x') then
    if self.panel12Flag and self.sequencesMatch then
      return MelodyMakerMenu()
    end
  end
  
  return self
end

function MelodyMakerMinigame:drawTopScreen()
  --Panel 9
  if self.panel9Flag and self.aCounter == 0 then
    love.graphics.draw(self.topBG1)
    love.graphics.draw(self.promptArrow, 105, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    draw:print({
        text = "Okay! Let's make a song!",
        x = 120,
        y = 15,
        color = Color.WHITE,
      })
    draw:print({
        text = "My program has 7 note variables\nthat all need values. You know what\nto do!",
        x = 120,
        y = 45,
        color = Color.WHITE,
      })
    draw:print({
        text = "Follow the pattern at the top and\ngive those notes all the right values,\nyou know what to do!",
        x = 120,
        y = 135,
        color = Color.WHITE,
        })
  elseif self.panel9Flag and self.aCounter == 1 then
    love.graphics.draw(self.topBG1)
    love.graphics.draw(self.promptArrow, 105, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthD, 20, 80)
    
    draw:print({
        text = "run MakeASong.exe",
        x = 120, 
        y = 15,
        color = Color.WHITE,
        })
  --Panel 10
  elseif self.panel10Flag then
    love.graphics.draw(self.topBG2)
    
    for i,v in ipairs(self.noteImageTable) do
      love.graphics.draw(self.noteImageTable[i], 40*i*1.15, 10*i, 0, self.noteScaleX, self.noteScaleY)
    end
    
    for i,v in ipairs(self.userNotes) do
      love.graphics.draw(self.userNotes[i], 40*i*1.15, 140, 0, self.noteScaleX, self.noteScaleY)
    end
  --Panel 11
  elseif self.panel11Flag then
    love.graphics.draw(self.topBG2)
    
    for i,v in ipairs(self.noteImageTable) do
      love.graphics.draw(self.noteImageTable[i], 40*i*1.15, 10*i, 0, self.noteScaleX, self.noteScaleY)
    end
    
    if self.commandManager:codeIsRunning() then
      
      love.graphics.draw(self.note, 40*1.15, 160)
      love.graphics.draw(self.note, 40*2*1.15, 160)
      love.graphics.draw(self.note, 40*3*1.15, 140)
      love.graphics.draw(self.note, 40*4*1.15, 120)
      love.graphics.draw(self.note, 40*5*1.15, 110)
      love.graphics.draw(self.note, 40*6*1.15, 110)
      love.graphics.draw(self.note, 40*7*1.15, 120)
      
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
      if self.noteTimer <= 0.1 then
        self.panel12Flag = true
        self.panel11Flag = false
      end
    else
      for i,v in ipairs(self.userNotes) do
        love.graphics.draw(self.userNotes[i], 40*i*1.15, 140, 0, self.noteScaleX, self.noteScaleY)
      end
      
      for i = 1, #self.userNotes do
        if i == self.selectedTop then
          love.graphics.draw(self.blueArrow, 40*i*1.2, 215, -1.55, self.arrowScaleX, self.arrowScaleY)
        end
      end
    end
  --Panel 12
  elseif self.panel12Flag then
    love.graphics.draw(self.topBG2)
    
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

    if self.sequencesMatch then
      --love.graphics.print("Yay! the sequences match!", 150, 150)
      love.graphics.draw(self.starAnimation[math.floor(self.currentFrame)])
    else
      --love.graphics.print("Error! The sequences don't match! Try again.", 150, 150)
      love.graphics.draw(self.errorMessage, 90, 90)
    end
  end
end

function MelodyMakerMinigame:drawBottomScreen()
  --Panel 9
  if self.panel9Flag and self.aCounter == 0 then
    love.graphics.draw(self.botBG1)
  elseif self.panel9Flag and self.aCounter == 1 then
    love.graphics.draw(self.botBG1)
    
    draw:print({
        text = "Compy's running a program that\nwill let us fix all the variables in his\nprogram, let's get to it!",
        x = 30,
        y = 25,
        color = Color.BLACK,
      })
    draw:print({
        text = "Press 'A' to continue",
        x = 80,
        y = 120,
        color = Color.BLACK,
        })
  
  elseif self.panel10Flag then
    love.graphics.draw(self.botBG1)
    
    draw:print({
        text = "To help Compy play music, we\nneed to give all those note\nvariables on the second row some\ncorrect sounds!",
        x = 30,
        y = 25,
        color = Color.BLACK,
      })
    draw:print({
        text = "Take a look at how to do that.",
        x = 47,
        y = 127,
        color = Color.BLACK,
        })
    draw:print({
        text = "Press'A' to continue.",
        x = 80,
        y = 160,
        color = Color.BLACK,
        })
  --Panel 11
  elseif self.panel11Flag then
    love.graphics.draw(self.botBG3)
  
    draw:print({
        text = "Give this variable a value that matches the song above!",
        x = 25,
        y = 15,
        color = Color.BLACK,
      })
    draw:print({
        text = "Variable",
        x = 35,
        y = 70,
        color = Color.BLACK,
      })
    draw:print({
        text = "Value",
        x = 200,
        y = 70,
        color = Color.BLACK,
      })
    for i = 1, #self.noteTable do
      if i == self.selectedTop then
        draw:print({
            text = "Note" .. i,
            x = 35,
            y = 130,
            color = Color.BLACK,
            font = '18px_italic',
          })
      end
    end
    draw:print({
        text = "=",
        x = 110,
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
      })
    
    if self.selectingValue then
      for i = 1, #self.noteTable do
        draw:print({
            text = 'Sound' .. self.noteTable[i],
            x = 200,
            y = 75 + (17*i),
            color = Color.BLACK,
          })
        
        if i == self.selectedBot then
          love.graphics.draw(self.blueArrow, 150, 75 + (17*i), 0, self.arrowScaleX, self.arrowScaleY)
        end
      end
    end
  --Panel 12
  elseif self.panel12Flag then
    love.graphics.draw(self.botBG1)
    
    if self.sequencesMatch then
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