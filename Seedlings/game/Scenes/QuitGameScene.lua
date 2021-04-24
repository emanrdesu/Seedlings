QuitGameScene = Object:extend()

function QuitGameScene:new()
  self.textboxList = ArrayList()

  self.width = 200
  self.x = (Constants.TOP_SCREEN_WIDTH - 200) / 2.0
  self.y = 50
  
  self.tb = TextBox({
    x = self.x, 
    y = self.y,
    width = self.width,
    align = 'center',
    text = "Would you like to quit the game?",
    color = Color.BLACK
  })
end

function QuitGameScene:update()
  if inputManager:isPressed('a') then
    love.event.quit()
  end
  
  if inputManager:isPressed('b') then
    return MainMenuScene()
  end
  
  return self
end

function QuitGameScene:drawTopScreen()
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
  self.tb:draw() 
end

function QuitGameScene:drawBottomScreen()

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