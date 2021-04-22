MelodyMakerMenu = Scene:extend()

function MelodyMakerMenu:new()
  self.topBG1 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_cmdBox.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.promptArrow = love.graphics.newImage('Assets/Images/Objects/prompt_carrot.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  
  options = {"Song1", "Song2", "Song3", "Chord1", "Chord2", "Chord3", "Variable Tutorial", "Try something new", "Main Menu", "Next Game", "Make your own!"}
  
  self.selectedTop = 1
  chordFlag = false
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 2 then lock = 2 end
  saveManager:setValue('lock', lock)
end

function MelodyMakerMenu:update()
  if self.chordFlag then
    options[8] = "Chord Tutorial"
  end
  
  if inputManager:isPressed('dpdown') then
    if self.chordFlag then 
      if self.selectedTop < #options then self.selectedTop = self.selectedTop + 1 end
    else
      if self.selectedTop < #options - 2 then self.selectedTop = self.selectedTop + 1 end
    end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('a') then
    if self.selectedTop == 1 then
      return Song1()
    elseif self.selectedTop == 2 then
      return Song2()
    elseif self.selectedTop == 3 then
      return Song3()
    elseif self.selectedTop == 7 then
      return MelodyMakerTut()
    elseif self.selectedTop == 8 then
      self.chordFlag = true
      return MelodyMakerChordTut()
    elseif self.selectedTop == 9 then
      return MainMenuScene()
    elseif self.selectedTop == 10 and self.chordFlag then
      return CodeIntroductionScene()      
    elseif self.selectedTop == 11 and self.chordFlag then
      return MelodyMakerMakeYourOwn()
    end
  end
  
  return self
end

function MelodyMakerMenu:drawTopScreen()
  love.graphics.draw(self.topBG1)
  love.graphics.draw(self.compyEyes, 20, 30)
  love.graphics.draw(self.compyMouthSmile, 20, 80)
  
  for i = 1, 3 do 
    love.graphics.print(options[i], 105, 30 * i)
  end
  
  for i = 4, 6 do 
    love.graphics.print(options[i], 250, 30 * (i-3))
  end
  
  love.graphics.print(options[7], 105, 120)
  love.graphics.print(options[8], 240, 120)
  love.graphics.print(options[9], 105, 150)
  
  if self.chordFlag then
    love.graphics.print(options[10], 240, 150)
    love.graphics.print(options[11], 105, 180)
  end
  
  for i,v in ipairs(options) do
    if i == self.selectedTop then
      if i > 0 and i <= 3 then
        love.graphics.draw(self.promptArrow, 90, 30*i)
      elseif i > 3 and i <= 6 then
        love.graphics.draw(self.promptArrow, 230, 30 * (i-3))
      elseif i == 7 then
        love.graphics.draw(self.promptArrow, 90, 120)
      elseif i == 8 then
        love.graphics.draw(self.promptArrow, 225, 120)
      elseif i == 9 then 
        love.graphics.draw(self.promptArrow, 90, 150)
      elseif self.chordFlag and i == 10 then
        love.graphics.draw(self.promptArrow, 225, 150)
      elseif self.chordFlag and i == 11 then
        love.graphics.draw(self.promptArrow, 90, 180)
      end
    end
  end
end

function MelodyMakerMenu:drawBottomScreen()
  love.graphics.draw(self.botBG1)
  draw:print({
      text = "Pick a song you want to try by\nusing the D-pad and pressing 'A'.",
      x = 40,
      y = 30,
      color = Color.BLACK,
      })
end