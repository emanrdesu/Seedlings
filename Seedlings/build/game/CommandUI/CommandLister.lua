CommandLister = Object:extend()

function CommandLister:new(uiRef)
  self.uiRef = uiRef
  
  self.startX = 10
  self.startY = 0
  self.width = 230
  self.height = 240
  
  self.heightPerCommand = 22
  self.commandBorderWidth = 2
  
  self.selectedIndex = 0
  
  self.offsetY = 0
  self.minOffsetY = 0
  
  self.buttonHitbox = Button({
    hitbox = {shape = 'rectangle', x = self.startX, y = self.startY, width = self.width, height = self.height}
  })
  
end

function CommandLister:update()
  -- Update the max scroll based on number of commands
  local extra = ((self.heightPerCommand-self.commandBorderWidth) * self.uiRef.commandManager.commandList:getSize()) - self.height
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
  
  -- Check if any of the commands got clicked
  if lt ~= nil and lt.eventType == Touch.PRESS then
    for i = 0, self.uiRef.commandManager.commandList:getSize() - 1, 1 do
      local x = self.startX
      local y = self.startY + (i * (self.heightPerCommand - self.commandBorderWidth)) + self.offsetY
      local xi = lt.x > x and lt.x < x + self.width
      local yi = lt.y > y and lt.y < y + self.heightPerCommand
      if xi and yi then self.selectedIndex = i end
    end
  end
end

function CommandLister:drawBottomScreen()
  -- Draw border
  draw:rectangle({
    mode = 'fill',
    x = self.startX,
    y = self.startY,
    width = self.width,
    height = self.height,
    color = Color.LIGHT_GRAY
  })
  
  -- Draw commands
  for i = 0, self.uiRef.commandManager.commandList:getSize() - 1, 1 do
    local x = self.startX
    local y = self.startY + (i * (self.heightPerCommand - self.commandBorderWidth)) + self.offsetY
    draw:brectangle({
      x = x, y = y, width = self.width, height = self.heightPerCommand, 
      color = Color.LIGHT_GRAY,
      borderColor = Color.BLACK,
      borderWidth = self.commandBorderWidth
    })
    
    local textColor = Color.BLACK
    if i == self.selectedIndex then textColor = Color.BLUE end
  
    draw:print({
      x = x + 10,
      y = y,
      color = textColor,
      font = 'default',
      text = self.uiRef.commandManager.commandList:get(i):toUserString(),
    })
  end
  
end