MelodyMakerIntro = Scene:extend()

function MelodyMakerIntro:new()
  self.topBGblueScreen = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_0_blueScreen.png')
  self.topBGcmdBox = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_cmdBox.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
  self.compyMouthO = love.graphics.newImage('Assets/Images/Objects/cmouth_O.png')
  self.compyMouthSad = love.graphics.newImage('Assets/Images/Objects/cmouth_sad.png')
  self.whiteTextBox = love.graphics.newImage('Assets/Images/Panels/variable_panels/Tutorial/small_whiteTextBox.png')
  self.promptArrow = love.graphics.newImage('Assets/Images/Objects/prompt_carrot.png')
  
  introFrames = {}
  table.insert(introFrames, love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mmOpen_1_sparkle.png'))
  table.insert(introFrames, love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mmOpen_2_sparkle.png'))
  
  compyFrames = {}
  table.insert(compyFrames, love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png'))
  table.insert(compyFrames, love.graphics.newImage('Assets/Images/Objects/ceyes_blink.png'))
  
  self.currentFrame = 1
  self.panel4Counter = 0
  
  self.introFlag = false
  self.bootingUpFlag = false
  self.helloExeFlag = false
  self.panel3Flag = false
  self.panel4Flag = false
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 1 then lock = 1 end
  saveManager:setValue('lock', lock)
end

function MelodyMakerIntro:update()
  dt = love.timer.getDelta()
  
  self.currentFrame = self.currentFrame + 2*dt
  if self.currentFrame >= 3 then
    self.currentFrame = 1
  end
  
  if inputManager:isPressed('start') then
    if self.introFlag == false then
      self.introFlag = true
    end
  end
  
  if inputManager:isPressed('a') then
    if self.panel4Flag and self.panel4Counter == 2 then
      return MelodyMakerTut()
    end
    
    if self.panel4Flag then
      if self.panel4Counter < 2 then
        self.panel4Counter = self.panel4Counter + 1
      end
    end
    
    if self.panel3Flag and self.introFlag == false and self.bootingUpFlag and self.helloExeFlag then
      self.panel3Flag = false
      self.panel4Flag = true
    end
    
    if self.introFlag and self.bootingUpFlag and self.helloExeFlag then
      self.panel3Flag = true
      self.introFlag = false
    end
    
    if self.introFlag and self.bootingUpFlag then
      self.helloExeFlag = true
    end
    
    if self.introFlag and self.bootingUpFlag == false then
      self.bootingUpFlag = true
    end    
  end
  
  return self
end

function MelodyMakerIntro:drawTopScreen()
  
  if self.introFlag == false then
    love.graphics.draw(introFrames[math.floor(self.currentFrame)])
  
    love.graphics.draw(compyFrames[math.floor(self.currentFrame)], 290, 35)
    
    love.graphics.draw(self.compyMouthSmile, 295, 70)
  end
  
  if self.introFlag and self.bootingUpFlag == false then
    love.graphics.draw(self.topBGblueScreen)
    
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.draw(self.whiteTextBox, 100, 70)
    love.graphics.setColor(1, 1, 1, 1)
    
    draw:print({
        text = '\tHello!\nBooting up...',
        x = 145,
        y = 75,
        color = Color.WHITE,
        font = '18px_bold',
        })
  end
  
  --Panel 3.1
  if self.introFlag and self.bootingUpFlag and self.helloExeFlag == false then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    draw:print({
        text = 'run Hello.exe',
        x = 120,
        y = 15,
        color = Color.WHITE,
      })
    
  --Panel 3.1  
  elseif self.introFlag and self.bootingUpFlag and self.helloExeFlag then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    draw:print({
        text = "run Hello.exe",
        x = 120,
        y = 15,
        color = Color.WHITE,
      })
    
    draw:print({
        text = "... Oh Hello! My name is Compy!\nI'm really glad you're here.",
        x = 120, 
        y = 45,
        color = Color.WHITE,
      })
    
    draw:print({
        text = "Can you help me with my program?",
        x = 120,
        y = 120,
        color = Color.WHITE,
        })
  
  --Panel 3.2
  elseif self.panel3Flag then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    draw:print({
        text = "Start helping Compy right now!",
        x = 120, 
        y = 15, 
        color = Color.WHITE,
      })
    
    draw:print({
        text = "Listen to Compy to show you how\nto help!",
        x = 120,  
        y = 45, 
        color = Color.WHITE,
        })
    
  --Panel 4
  elseif self.panel4Flag and self.panel4Counter == 0 then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthO, 23, 80)
    
    draw:print({
        text = "I love music! Have you heard it\nbefore? It's amazing!\nIt goes: Do  do da do ta ta!",
        x = 120, 
        y = 15,
        color = Color.WHITE,
        })
    
  elseif self.panel4Flag and self.panel4Counter == 1 then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSad, 23, 80)
    
    draw:print({
        text = "I love music! Have you heard it\nbefore? It's amazing!\nIt goes: Do  do da do ta ta!",
        x = 120, 
        y = 15,
        color = Color.WHITE,
      })
    
    draw:print({
      text = "...",
      x = 120, 
      y = 85,
      color = Color.WHITE,
    })
  
    draw:print({
        text = "Well, I think that's how it would go,\nbut I'm having trouble with my\nprogram that lets me play music.",
        x = 120, 
        y = 135, 
        color = Color.WHITE,
      })
    
  elseif self.panel4Flag and self.panel4Counter == 2 then
    love.graphics.draw(self.topBGcmdBox)
    love.graphics.draw(self.promptArrow, 100, 20)
    love.graphics.draw(self.compyEyes, 20, 30)
    love.graphics.draw(self.compyMouthSmile, 20, 80)
    
    draw:print({
        text = "But if you could help me finish my\nprogram, I think I could play lots of\nmusic!",
        x = 120, 
        y = 15,
        color = Color.WHITE,
      })
    
    draw:print({
        text = "Let me show you how to help!",
        x = 120, 
        y = 95,
        color = Color.WHITE,
        })
  end
end

function MelodyMakerIntro:drawBottomScreen()
  love.graphics.draw(self.botBG1)
  
  --Panel 1
  if self.introFlag == false and self.panel3Flag == false and self.panel4Flag == false then
    draw:print({
        text = "Press 'Start' to begin!",
        x = 80,
        y = 40,
        color = Color.BLACK,
        })
  end
  
  --Panel 2
  if self.introFlag and self.bootingUpFlag == false then
    draw:print({
        text = "Your computer is booting, which\nmeans it's starting up!",
        x = 40, 
        y = 40,
        color = Color.BLACK,
      })
    
    draw:print({
        text = "Let's see what we can do with \nour computer today.",
        x = 40,
        y = 110,
        color = Color.BLACK,
        })
  end
  
  --Panel 3.1
  if self.introFlag and self.bootingUpFlag and self.helloExeFlag then
    draw:print({
        text = "Wow! Look! It's a computer\nprogram that our computer is\nusing, or running for us.",
        x = 30,
        y = 20, 
        color = Color.BLACK,
      })
    
    draw:print({
        text = "The program is called 'Hello.exe',\nand is saying hello! Let's see what\nCompy wants to do today.",
        x = 30,
        y = 120,
        color = Color.BLACK,
      })
    
    draw:print({
        text = "Press 'A' to continue",
        x = 90, 
        y = 210,
        color = Color.BLACK,
        })
  --Panel 3.2
  elseif self.panel3Flag then
    draw:print({
        text = "Press 'A' to continue",
        x = 90,
        y = 30,
        color = Color.BLACK,
        })
  elseif self.panel4Flag then
    draw:print({
        text = "Press 'A' to continue",
        x = 90,
        y = 30,
        color = Color.BLACK,
        })
  end
end
