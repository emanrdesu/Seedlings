CommandLister = Object:extend()

function CommandLister:new(uiRef)
  self.uiRef = uiRef
  
  -- variables for this listing box
  self.startX = 10
  self.startY = 0
  self.width = 230
  self.height = 240
  self.spacePerIndent = 15
  
  -- Height per command, and border width
  -- Commands are drawn with their borders overlapping, so the effective height is (height - borderWidth)
  self.heightPerCommand = 22
  self.commandBorderWidth = 2
  
  self.selectedIndex = 0
  
  -- The commands will scroll if there are too many. The offset is the current 'scroll'
  self.offsetY = 0
  self.minOffsetY = 0
  
  -- Create an invisible button that functions as the hitbox for the scrolling
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
      -- Update selected index if any commands got clicked
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
  local currentIndent = 0
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
    
    -- Decrease indent if we need to
    local cmd = self.uiRef.commandManager.commandList:get(i)
    if cmd:decreaseIndent() and currentIndent > 0 then currentIndent = currentIndent - 1 end
  
    draw:print({
      x = x + 10 + (currentIndent * self.spacePerIndent),
      y = y + 4,
      color = textColor,
      font = 'consolas_12',
      text = cmd:toUserString(),
    })
  
    -- Increase indent if we need to
    if cmd:increaseIndent() then currentIndent = currentIndent + 1 end
  end
  
end