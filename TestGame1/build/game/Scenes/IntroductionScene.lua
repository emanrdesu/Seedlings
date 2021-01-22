IntroductionScene = Object:extend()

function IntroductionScene:new()
  self.textboxList = ArrayList()
  
  local tb1 = TextBox(30, 30, 200)
  tb1:setAlign('center')
  tb1:setText("Welcome to Seedlings!\n This is a game designed to teach programming concepts")
  self.textboxList:add(tb1)
  
  local tb2 = TextBox(30, 30, 200)
  tb2:setAlign('center')
  tb2:setText("Textbox 2\n yaaaay")
  self.textboxList:add(tb2)
  
  local tb3 = TextBox(30, 30, 200)
  tb3:setAlign('center')
  tb3:setText("Third and final textbox! Hitting 'a' after this should then bring you to the main menu!")
  self.textboxList:add(tb3)
  
  self.index = 0
end

function IntroductionScene:update()
  if inputManager:isPressed('a') then
    self.index = self.index + 1
    if self.index >= self.textboxList:getSize() then 
      saveManager:setValue('read_intro', 1)
      return TestScene1() 
    end
  end
  
  if inputManager:isPressed('b') then
    self.index = self.index - 1
    if self.index < 0 then self.index = 0 end
  end
  
  return self
end

function IntroductionScene:drawTopScreen()
  self.textboxList:get(self.index):draw()
end

function IntroductionScene:drawBottomScreen()

end