FillBowlScene = Object:extend()

function FillBowlScene:new()
  
  
  
  
  self.intro = true
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Fill Bowl")
end

function FillBowlScene:update()
  if self.intro then
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
    return self
  end
  
  
  
  if inputManager:isPressed('b') then return MainMenuScene() end
  
  return self
end

function FillBowlScene:drawTopScreen()
  
  if self.intro then self.textBoxes:drawTopScreen() end
end

function FillBowlScene:drawBottomScreen()
  
  if self.intro then self.textBoxes:drawBottomScreen() end
end