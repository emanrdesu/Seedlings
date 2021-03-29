TextBoxList = Object:extend()

function TextBoxList:new(args)
  if args == nil then args = {} end
  self.textY = args.textY or 50
  self.textWidth = args.textWidth or 220
  self.spacing = args.spacing or 0
  self.font = args.font or 'default'
  self.align = args.align or 'center'
  self.textColor = args.textColor or Color.BLACK
  self.bgColor = args.bgColor or Color.SAND
  self.borderColor = args.borderColor or Color.BLACK
  self.borderWidth = args.borderWidth or 3
  self.spaceLeft = args.spaceLeft or 40
  self.spaceUp = args.spaceUp or 35
  self.spaceDown = args.spaceDown or 175
  self.dim = args.dim or 0.85
  self.textX = args.textX or (Constants.TOP_SCREEN_WIDTH - self.textWidth) / 2.0


  self.textboxList = ArrayList()
  self.index = 0
end

function TextBoxList:addText(text)
  self.textboxList:add(TextBox({
    x = self.textX, 
    y = self.textY,
    width = self.textWidth,
    align = self.align,
    text = text,
    color = self.textColor,
  }))
end

function TextBoxList:addTextAlign(text, align)
  self.textboxList:add(TextBox({
    x = self.textX, 
    y = self.textY,
    width = self.textWidth,
    align = align,
    text = text,
    color = self.textColor,
  }))
end

function TextBoxList:reset()
  self.index = 0
end

-- Returns true if the user completes all text entries
function TextBoxList:update()
  if inputManager:isPressed('a') then
    self.index = self.index + 1
    if self.index >= self.textboxList:getSize() then 
      self.index = self.textboxList:getSize() - 1
      return true
    end
  end
  
  if inputManager:isPressed('b') then
    self.index = self.index - 1
    if self.index < 0 then self.index = 0 end
  end
  
  return false
end

function TextBoxList:drawTopScreen()
  local extra = self.spaceLeft
  draw:brectangle({
    x = self.textX - extra,
    y = self.textY - self.spaceUp, 
    width = self.textWidth + 2*extra,
    height = self.spaceUp + self.spaceDown,
    color = self.bgColor,
    borderColor = self.borderColor,
    borderWidth = self.borderWidth,
  })

  self.textboxList:get(self.index):draw()
  
  -- draw page number thing
  local text = tostring(1 + self.index)..' / '..tostring(self.textboxList:getSize())
  
  local middle = math.floor(self.textX + (self.textWidth / 2))
  
  draw:print({
    x = middle - 19,
    y = (self.textY + self.spaceDown) - 30,
    color = Color.BLACK,
    font = '18px',
    text = text,
  })
end

function TextBoxList:drawBottomScreen()
  -- Dim the bottom screen
  draw:rectangle({
    x = 0,
    y = 0,
    width = Constants.BOTTOM_SCREEN_WIDTH,
    height = Constants.BOTTOM_SCREEN_HEIGHT,
    color = Color.BLACK:withAlpha(self.dim),
  })
  
  
  function btn(x, y, text, text2)
  local rad = 15
  draw:rectangle({x=x-20, y=y-20, width=90, height = 40, color = Color:byte(84, 164, 73)})
  draw:circle({x=x, y=y, radius = rad, color = Color.GRAY})
  draw:print({x = x - 5, y = y - 12, color = Color.BLACK, text = text, font = 'default'})
  draw:print({x = x + 2 * rad - 5, y = y - 12, color = Color.BLACK, text = text2, font = 'default'})
  end
  
  btn(30, 200, 'B', 'Back')
  btn(240, 200, 'A', 'Next')
end