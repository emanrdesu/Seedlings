ClearDataScene = Object:extend()

function ClearDataScene:new()
  self.textboxList = ArrayList()

  self.width = 200
  self.x = (Constants.TOP_SCREEN_WIDTH - 200) / 2.0
  self.y = 50
  
  self.tb = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "Would you like to clear your data?\n\nAll minigames will need to be unlocked again",
    color = Color.BLACK
  })
  self.sure = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "\n\nAre you sure?",
    color = Color.BLACK
  })
  self.id = 0
end

function ClearDataScene:update()
  if inputManager:isPressed('a') then
    if self.id == 0 then
      self.id = 1
    else
      saveManager:clearData()
      return TitleScene()
    end
  end
  
  if inputManager:isPressed('b') then
    if self.id == 0 then
      return MainMenuScene()
    else
      self.id = 0
    end
  end
  
  return self
end

function ClearDataScene:drawTopScreen()
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
  if self.id == 0 then 
    self.tb:draw() 
  else
    self.sure:draw()
  end
end

function ClearDataScene:drawBottomScreen()

  function btn(x, y, text, text2)
    local rad = 15
    draw:rectangle({x=x-20, y=y-20, width=90, height = 40, color = Color.GREEN:withAlpha(0.15)})
    draw:circle({x=x, y=y, radius = rad, color = Color.GRAY})
    draw:print({x = x - 5, y = y - 12, color = Color.BLACK, text = text, font = 'default'})
    draw:print({x = x + 2 * rad - 5, y = y - 12, color = Color.BLACK, text = text2, font = 'default'})
  end
  
  btn(30, 200, 'B', 'No')
  btn(240, 200, 'A', 'Yes')

end