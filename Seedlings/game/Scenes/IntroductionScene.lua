IntroductionScene = Object:extend()

function IntroductionScene:new()
  self.textboxList = ArrayList()

  self.width = 200
  self.x = (Constants.TOP_SCREEN_WIDTH - 200) / 2.0
  self.y = 50
  
  local tb1 = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "Welcome to Seedlings!\n This is a game designed to teach programming concepts",
    color = Color.BLACK
  })
  self.textboxList:add(tb1)
  
  local tb2 = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "There are various minigames to play, and each time you'll learn something new",
    color = Color.BLACK
  })
  self.textboxList:add(tb2)
  
  local tb3 = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "Initially, only the first minigame is unlocked. Each time you clear a minigame, you will unlock the next game",
    color = Color.BLACK
  })
  self.textboxList:add(tb3)
  
  self.textboxList:add(TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "Once you unlock a minigame, you can select it from the main menu to replay it anytime that you like. Have fun!",
    color = Color.BLACK
  }))

  self.textboxList:add(TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "This text box only shows up the first time you start up the game. To view it again, select the '?' icon in the main menu",
    color = Color.BLACK
  }))

  self.textboxList:add(TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "You can also clear your save data from the main menu with the 'R' button",
    color = Color.BLACK
  }))
  
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
  local extra = 40;
  draw:brectangle({
    x = self.x - extra, 
    y = 15,
    width = self.width + 2*extra,
    height = 210,
    color = Color.SAND,
    borderColor = Color.BLACK,
    borderWidth = 3,
  })
  self.textboxList:get(self.index):draw()
  
  -- draw page number thing
  local text = tostring(1 + self.index)..' / '..tostring(self.textboxList:getSize())
  draw:print({
    x = 180,
    y = 190,
    color = Color.BLACK,
    font = '18px',
    text = text,
  })
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