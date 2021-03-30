MelodyMakerTut = Scene:extend()

function MelodyMakerTut:new()
  self.topBG = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_2_tutorialPlay.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.botBG2 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_layout_LHeavy_green.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.compyMouthSad = love.graphics.newImage('Assets/Images/Objects/cmouth_sad.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
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

  
  self.noteScaleX = 1.13
  self.noteScaleY =  1.13
  self.squareScaleX = 1.25
  self.squareScaleY = 1.25
  self.arrowScaleX = 0.55
  self.arrowScaleY = 0.55
  
  self.panel5Flag = true
  self.panel6Flag = false
  self.panel7Flag = false
  
  self.selectingValue = false
  self.valuesMatching = false
  self.valueSelected = false
  
  self.variableOptions = {}
  self.variableOptions[1] = 'Note1'
  
  self.valueOptions = {}
  self.valueOptions[1] = 'SoundA'
  self.valueOptions[2] = 'SoundB'
  self.valueOptions[3] = 'SoundC'
  
  self.noteTable = {}
  self.noteTable['SoundA'] = 'A'
  self.noteTable['SoundB'] = 'B'
  self.noteTable['SoundC'] = 'C'
  
  self.noteImageTable = {}
  self.noteImageTable['SoundA'] = self.ANote
  self.noteImageTable['SoundB'] = self.BNote
  self.noteImageTable['SoundC'] = self.CNote
  
  self.commandManager = CommandManager()
  self.commandManager:setTimePerLine(0.01)
  
  sandbox = {}
  sandbox['SM'] = sm
  --[[
  sandbox['SoundA'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
  sandbox['SoundB'] = love.audio.newSource("Assets/Audio/Piano/b.wav", "static")
  sandbox['SoundC'] = love.audio.newSource("Assets/Audio/Piano/c.wav", "static")
  --]]
  sandbox['SoundA'] = sm.audio['audio_A']
  sandbox['SoundB'] = sm.audio['audio_B']
  sandbox['SoundC'] = sm.audio['audio_C']
  
  self.desiredValue = 'SoundA'
  self.userValue = 'empty'
  
  self.selectedVariable = 1
  
  self.timerFlag = false
  self.pauseFlag = false  
  self.playTimer = 1.75
end

function MelodyMakerTut:update()
  self.commandManager:update()
  local dt = love.timer.getDelta()
  
  if self.userValue == 'empty' then
    self.valueSelected = false
  else
    self.valueSelected = true
  end
  
  if self.desiredValue == self.userValue then
    self.valuesMatching = true
  else
    self.valuesMatching = false
  end
  
  if inputManager:isPressed('select') then
    if self.valueSelected and self.pauseFlag and self.valuesMatching and self.panel7Flag then
      return MelodyMakerMinigame()
    end
  end
  
  if inputManager:isPressed('start') then
      self.timerFlag = false
      self.pauseFlag = false
      
      if self.commandManager.commandList:getSize() >  0 then
        self.commandManager:removeCommand(0)
        self.commandManager:insertCommand(0, SetNoteTo('Note1', self.noteTable[self.userValue]))
      else
        self.commandManager:insertCommand(0, SetNoteTo('Note1', self.noteTable[self.userValue]))
      end
      self.commandManager:start()
      
     self.timerFlag = true
  end
  
  if self.timerFlag and self.playTimer > 0 then
    self.playTimer = self.playTimer - dt
    self.pauseFlag = true
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectedVariable < #self.valueOptions then self.selectedVariable = self.selectedVariable + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedVariable > 1 then self.selectedVariable = self.selectedVariable - 1 end
  end
  
  if inputManager:isPressed('b') then
    if self.panel7Flag and self.selectingValue then
      self.selectingValue = false
    end
  end
  
  if inputManager:isPressed('a') then
      
       --Selecting Values
      if self.panel7Flag and self.selectingValue == false then
        self.selectingValue = true      
      --Assinging Values
      elseif self.panel7Flag and self.selectingValue then
        self.selectingValue = false
        self.userValue = self.valueOptions[self.selectedVariable]
        self.playTimer = 1.75
      end
      
      --Moving from panel 7 from panel 6
      if self.panel6Flag and self.panel5Flag == false and self.panel7Flag == false then
        self.panel6Flag = false
        self.panel7Flag = true
      end
      
      --Moving to panel 6 from panel 5
      if self.panel5Flag and self.panel6Flag == false and self.panel7Flag == false then
        self.panel5Flag = false
        self.panel6Flag = true
      end
      
  end
  
  return self
end

function MelodyMakerTut:drawTopScreen()
  love.graphics.draw(self.topBG)
  love.graphics.draw(self.promptArrow, 100, 20)
  
  --Panel 5
  if self.panel5Flag then
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    
    draw:print({
        text = "show PlayMusic.exe",
        x = 120, 
        y = 15,
        color = Color.WHITE,
      })
    
    draw:print({
        text = "{",
        x = 120, 
        y = 35, 
        color = Color.WHITE,
      })
    
    draw:print({
        text = "play note1\nplay note2\nplay note3\nplay note4\nplay note5\nplay note6\nplay note7",
        x = 135,
        y = 45,
        color = Color.WHITE,
      })
    
    draw:print({
        text = "}",
        x = 120,
        y = 190,
        color = Color.WHITE,
        })

  --Panel 6
  elseif self.panel6Flag then
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSad, 23, 80)
    
    draw:print({
        text = "But my program doesn't play music!\nI think it's because my note\nvariables don't have any values.",
        x = 118, 
        y = 15, 
        color = Color.WHITE,
      })
    
    love.graphics.draw(self.whiteSquare, 217, 100, 0, self.squareScaleX, self.squareScaleY)
    love.graphics.draw(self.emptyNote, 220, 100, 0, self.noteScaleX, self.noteScaleY)
  
  --Panel 7
  elseif self.panel7Flag then
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    if self.userValue == 'empty' then
      draw:print({
          text = "See? This note doesn't have a value,\nand can't play sound.",
          x = 115, 
          y = 15, 
          color = Color.WHITE,
        })
      
      draw:print({
          text = "Can you help me make this note play",
          x = 112, 
          y = 65,
          color = Color.WHITE,
        })
      draw:print({
          text = "soundA?",
          x = 112,
          y = 85,
          color = Color.WHITE,
          font = '18px_italic',
        })
      
      love.graphics.draw(self.whiteSquare, 217, 100, 0, self.squareScaleX, self.squareScaleY)
      love.graphics.draw(self.emptyNote, 220, 100, 0, self.noteScaleX, self.noteScaleY)
    else
      draw:print({
          text = "run PlayNote1.exe",
          x = 120,
          y = 15
        })
      
      love.graphics.draw(self.whiteSquare, 217, 60, 0, self.squareScaleX, self.squareScaleY)
      love.graphics.draw(self.noteImageTable[self.userValue], 220, 60, 0, self.noteScaleX, self.noteScaleY)
      
      if self.valueSelected and self.pauseFlag and self.valuesMatching and self.playTimer <=0 then
        love.graphics.print("Yay!! That was awesome!", 110, 115)
        love.graphics.print("Can you believe it? I played a sound!\nNow that you are here, we can help\nmy program play music, thank you!", 110, 140)
      elseif self.valueSelected and self.pauseFlag and self.valuesMatching == false and self.playTimer <= 0 then
        love.graphics.print("Uh oh, that doesn't seem to be  the\nright sound. This variable should be\nequal to the value", 110, 140)
        draw:print({
            text = "soundA!",
            x = 250,
            y = 182,
            font = '18px_italic',
            })
      end
      
    end
  end
  
end


function MelodyMakerTut:drawBottomScreen()
  love.graphics.draw(self.botBG1)
  
  --Panel 5
  if self.panel5Flag then 
    draw:print({
        text = "Press 'A' to continue.",
        x = 90, 
        y = 30,
        color = Color.BLACK,
      })
   
  --Panel 6 
  elseif self.panel6Flag then
    love.graphics.draw(self.botBG2)
    
    draw:print({
        text = "This variable doesn't have a value!",
        x = 30, 
        y = 20,
        color = Color.BLACK,
      })
    
    draw:print({
        text = "Variable",
        x = 70, 
        y = 80,
        color = Color.BLACK,
      })
    
    draw:print({
        text = "Value",
        x = 230,
        y = 80,
        color = Color.BLACK,
        })
    
    draw:print({
        text = "Note1",
        x = 70,
        y = 130, 
        color = Color.BLACK,
        font = '18px_italic',
      })
    
    draw:print({
        text = "=",
        x = 180, 
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
      })
    
    draw:print({
        text = self.userValue,
        x = 230, 
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
        })
  
  --Panel 7
  elseif self.panel7Flag then
    love.graphics.draw(self.botBG2)
    
    if not self.selectingValue then
      if self.valueSelected then
        draw:print({
            text = "Okay! Press 'Start' to finish!",
            x = 30, 
            y = 15,
            color = Color.BLACK,
          })
        draw:print({
            text = self.userValue,
            x = 230,
            y = 130,
            color = Color.BLACK,
            font = '18px_italic',
          })
        
        if self.pauseFlag and self.valuesMatching and self.playTimer <=0 then
          draw:print({
              text = "Press 'Select' to continue!",
              x = 30,
              y = 35,
              color = Color.BLACK,
            })
        end
      else
        draw:print({
            text = "Give this variable a value equal to",
            x = 30,
            y = 15,  
            color = Color.BLACK,
          })
        draw:print({
            text = "soundA!",
            x = 30,
            y = 40,
            color = Color.BLACK,
            font = '18px_italic',
          })
        draw:print({
            text = "Press 'A' to give it a value.",
            x = 100, 
            y = 40,
            color = Color.BLACK,
          })
      end
    end
      
    draw:print({
        text = "Variable",
        x = 70, 
        y = 80,
        color = Color.BLACK,
      })
    
    draw:print({
        text = "Value",
        x = 230,
        y = 80,
        color = Color.BLACK,
        })
    
    love.graphics.draw(self.blueArrow, 30, 130, 0, self.arrowScaleX, self.arrowScaleY)
    draw:print({
      text = self.variableOptions[1],
      x = 70,
      y = 130,
      color = Color.BLACK,
      font = '18px_italic',
    })
  
    draw:print({
        text = "=",
        x = 180, 
        y = 130,
        color = Color.BLACK,
        font = '18px_italic',
      })
    
    if self.selectingValue then
      draw:print({
          text = "Give this variable a value equal to",
          x = 30,
          y = 15,  
          color = Color.BLACK,
        })
      draw:print({
          text = "soundA!",
          x = 30,
          y = 40,
          color = Color.BLACK,
          font = '18px_italic',
        })
      draw:print({
          text = "Press 'A' on your choice.",
          x = 100, 
          y = 40,
          color = Color.BLACK,
        })
      
      draw:print({
          text = self.valueOptions[1],
          x = 240, 
          y = 100,
          color = Color.BLACK,
          font = '18px_italic',
        })
      draw:print({
          text = self.valueOptions[2],
          x = 240, 
          y = 140,
          color = Color.BLACK,
          font = '18px_italic',
        })
      draw:print({
          text = self.valueOptions[3],
          x = 240, 
          y = 180,
          color = Color.BLACK,
          font = '18px_italic',
        })
      
      if self.selectedVariable == 1 then
        love.graphics.draw(self.blueArrow, 200, 100, 0, self.arrowScaleX, self.arrowScaleY)
      elseif self.selectedVariable == 2 then
        love.graphics.draw(self.blueArrow, 200, 140, 0, self.arrowScaleX, self.arrowScaleY)
      elseif self.selectedVariable == 3 then
        love.graphics.draw(self.blueArrow, 200, 180, 0, self.arrowScaleX, self.arrowScaleY)
      end
    end
  end
end