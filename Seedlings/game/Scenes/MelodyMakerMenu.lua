MelodyMakerMenu = Scene:extend()

function MelodyMakerMenu:new()
  sm.playStart = true
  self.topBG1 = love.graphics.newImage('Assets/Images/Panels/melodymak_panels/mm_1_cmdBox.png')
  self.compyEyes = love.graphics.newImage('Assets/Images/Objects/ceyes_normal.png')
  self.compyMouthSmile = love.graphics.newImage('Assets/Images/Objects/cmouth_smile.png')
  self.promptArrow = love.graphics.newImage('Assets/Images/Objects/prompt_carrot.png')
  self.botBG1 = love.graphics.newImage('Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png')
  
  options = {"Introduction", "Variable Tutorial", "Chord Tutorial", "Main Menu"}
  
  self.selectedTop = 1
  chordFlag = false
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 2 then lock = 2 end
  saveManager:setValue('lock', lock)
end

function MelodyMakerMenu:update()
  if self.chordFlag then
    options[5] = "Next Game"
  end
  
  if inputManager:isPressed('dpdown') then
    if self.selectedTop < #options then self.selectedTop = self.selectedTop + 1 end
  end
  
  if inputManager:isPressed('dpup') then
    if self.selectedTop > 1 then self.selectedTop = self.selectedTop - 1 end
  end
  
  if inputManager:isPressed('a') then
    if self.selectedTop == 1 then
       return Trans(MelodyMakerIntro)
    elseif self.selectedTop == 2 then
       return Trans(MelodyMakerTut)
    elseif self.selectedTop == 3 then
      self.chordFlag = true
      return Trans(MelodyMakerChordTut)
    elseif self.selectedTop == 4 then
       return Trans(MainMenuScene)
    elseif self.selectedTop == 5 then
       return Trans(CodeIntroductionScene)
    end
  end
  
  return self
end

function MelodyMakerMenu:drawTopScreen()
  love.graphics.draw(self.topBG1)
  love.graphics.draw(self.compyEyes, 20, 30)
  love.graphics.draw(self.compyMouthSmile, 20, 80)
  
  for i,v in ipairs(options) do
    love.graphics.print(v, 170, 30 * i)
    
    if i == self.selectedTop then
      love.graphics.draw(self.promptArrow, 150, 31 * i)
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
