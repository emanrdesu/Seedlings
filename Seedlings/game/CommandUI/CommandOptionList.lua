CommandOptionList = Object:extend()

function CommandOptionList:new(uiRef, editorRef, commandRef, paramTable)
  self.uiRef = uiRef
  self.editorRef = editorRef
  self.commandRef = commandRef
  self.paramTable = paramTable
  
  self.startX = 0
  self.startY = 0
  self.width = Constants.BOTTOM_SCREEN_WIDTH
  self.height = Constants.BOTTOM_SCREEN_HEIGHT
  
  self.buttonList = ArrayList()
  
  -- Create the X button
  local xwidth = 30
  local xheight = 30
  local buttonX = self.startX + self.width - xwidth
  local buttonY = self.startY
  self.exitButton = Button({
    hitbox = {
      shape = 'rectangle',
      x = buttonX,
      y = buttonY,
      width = xwidth,
      height = xheight,
    },
    drawNormal = function()
      draw:rectangle({
        x = buttonX,
        y = buttonY,
        width = xwidth,
        height = xheight,
        color = Color.GRAY
      })
      draw:print({
        x = buttonX + 10,
        y = buttonY,
        font = '18px',
        text = 'X',
        color = Color.BLACK,
      })
    end,
    onClick = function()
      self.uiRef.uiStack:pollLast()
    end
  })
  self.buttonList:add(self.exitButton)
  
  -- Create the confirm button
  local confirmW = 50
  local confirmH = 50
  local confirmX = Constants.BOTTOM_SCREEN_WIDTH - confirmW
  local confirmY = Constants.BOTTOM_SCREEN_HEIGHT - confirmH
  self.confirmButton = Button({
      hitbox = {
          shape = 'rectangle',
          x = confirmX,
          y = confirmY,
          width = confirmW,
          height = confirmH
      },
      drawNormal = function()
        draw:rectangle({
          x = confirmX,
          y = confirmY,
          width = confirmW,
          height = confirmH,
          color = Color.GRAY
        })
        draw:print({
          x = confirmX + 10,
          y = confirmY,
          font = '18px',
          text = 'Y',
          color = Color.BLACK,
        })
      end,
      onClick = function()
        local paramOption = self.paramTable.optionList:get(self.selectedIndex)
        self.commandRef:setParameter(paramTable.codeString, paramOption.codeString)
        self.editorRef:refresh()
        self.uiRef.uiStack:pollLast()
      end,
  })
  self.buttonList:add(self.confirmButton)
  
  -- Create the values for the list of available options
  -- Unlike the lister, here the height per command is the effective height
  self.optionListWidth = self.width - xwidth - 50
  self.heightPerOption = 40
  
  self.selectedIndex = 0
  
  self.offsetY = 0
  self.minOffsetY = 0
  
  -- Create a hitbox so that this can scroll as well
  self.buttonHitbox = Button({
    hitbox = {shape = 'rectangle', x = self.startX, y = self.startY, width = self.optionListWidth, height = self.height}
  })
  
end

function CommandOptionList:update()
    -- Update the max scroll based on number of commands
  local extra = (self.heightPerOption * self.paramTable.optionList:getSize()) - self.height
  if extra < 0 then extra = 0 end
  self.minOffsetY = -1.0 * extra
  
  -- Update the offset (scrolling)
  self.buttonHitbox:update()
  local lt = inputManager:getLastTouch()
  if self.buttonHitbox.is_hovered then
    if lt ~= nil and lt.eventType == Touch.MOVE then
      self.offsetY = self.offsetY + lt.dy
    end
  end
  if self.offsetY > 0 then self.offsetY = 0 end
  if self.offsetY < self.minOffsetY then self.offsetY = self.minOffsetY end
  
  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):update()
  end  
  
    -- Check if any of the options got clicked
  if lt ~= nil and lt.eventType == Touch.PRESS then
    for i = 0, self.paramTable.optionList:getSize() - 1, 1 do
      local x = self.startX
      local y = self.startY + (i * self.heightPerOption) + self.offsetY
      local xi = lt.x > x and lt.x < x + self.optionListWidth
      local yi = lt.y > y and lt.y < y + self.heightPerOption
      if xi and yi then self.selectedIndex = i end
    end
  end
  
  
end

function CommandOptionList:drawBottomScreen()
  draw:rectangle({
    x = self.startX,
    y = self.startY,
    width = self.width,
    height = self.height,
    color = Color.EIGENGRAU,
  })

  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):draw()
  end  
  
  -- Draw options
  for i = 0, self.paramTable.optionList:getSize() - 1, 1 do
    local x = self.startX
    local y = self.startY + (i * self.heightPerOption) + self.offsetY
    draw:brectangle({
      x = x, y = y, width = self.optionListWidth, height = self.heightPerOption, 
      color = Color.LIGHT_GRAY,
      borderColor = Color.BLACK,
      borderWidth = 2
    })
    
    local textColor = Color.BLACK
    if i == self.selectedIndex then textColor = Color.BLUE end
  
    draw:print({
      x = x + 10,
      y = y,
      color = textColor,
      font = '18px',
      text = self.paramTable.optionList:get(i).userString,
    })
  end
end