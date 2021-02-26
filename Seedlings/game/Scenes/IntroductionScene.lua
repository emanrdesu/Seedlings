IntroductionScene = Object:extend()

function IntroductionScene:new()
  self.textboxList = ArrayList()
  
  local tb1 = TextBox({
    x = 30, 
    y = 30, 
    width = 200,
    align = 'center',
    text = "Welcome to Seedlings!\n This is a game designed to teach programming concepts"
  })
  self.textboxList:add(tb1)
  
  local tb2 = TextBox({
    x = 30, 
    y = 30, 
    width = 200,
    align = 'center',
    text = "Textbox 2\n yaaaay"
  })
  self.textboxList:add(tb2)
  
  local tb3 = TextBox({
    x = 30, 
    y = 30, 
    width = 200,
    align = 'center',
    text = "Third and final textbox! Hitting 'a' after this should then bring you to the main menu!"
  })
  self.textboxList:add(tb3)
  
  self.index = 0
end

function IntroductionScene:update()
  if inputManager:isPressed('a') then
    self.index = self.index + 1
    if self.index >= self.textboxList:getSize() then 
      saveManager:setValue('read_intro', 1)
      return MainMenuScene() 
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

  function btn(x, y, text, text2)
    local rad = 15
    draw:rectangle({x=x-20, y=y-20, width=90, height = 40, color = Color.GREEN:withAlpha(0.15)})
    draw:circle({x=x, y=y, radius = rad, color = Color.GRAY})
    draw:print({x = x - 5, y = y - 12, color = Color.BLACK, text = text, font = 'default'})
    draw:print({x = x + 2 * rad - 5, y = y - 12, color = Color.BLACK, text = text2, font = 'default'})
  end
  
  btn(30, 200, 'B', 'Back')
  btn(240, 200, 'A', 'Next')

end