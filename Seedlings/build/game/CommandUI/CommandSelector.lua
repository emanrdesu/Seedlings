CommandSelector = Object:extend()

function CommandSelector:new(uiRef, commandRef, commandIndex, editorRef)
  -- If the commandRef is nil, then this is inserting something at the index
  -- otherwise, it is modifying the command at this index
  
  self.uiRef = uiRef
  self.commandRef = commandRef
  self.commandIndex = commandIndex
  self.editorRef = editorRef
  
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
        if self.commandRef == nil then
          -- Insert this command at this index then increment the index afterwards if we did not add the 1st command
          self.uiRef.commandManager:insertCommand(1 + self.commandIndex, self.uiRef.availableCommands:get(self.selectedIndex)()) 
          if self.uiRef.commandManager.commandList:getSize() > 1 then self.uiRef.commandLister.selectedIndex = self.uiRef.commandLister.selectedIndex + 1 end
        else
          -- Modify the current command
          local newCommand = self.uiRef.availableCommands:get(self.selectedIndex)()
          self.uiRef.commandManager:replaceCommand(self.commandIndex, newCommand)
          -- Set the command reference and then refresh the editor
          self.editorRef.commandRef = newCommand
          self.editorRef:refresh()
        end
        self.uiRef.uiStack:pollLast()
      end,
  })
  self.buttonList:add(self.confirmButton)
  
  
  -- Create the values for the list of available commands
  -- Unlike the lister, here the height per command is the effective height
  self.cmdListWidth = self.width - xwidth - 50
  self.heightPerCommand = 40
  
  self.selectedIndex = 0
  
  self.offsetY = 0
  self.minOffsetY = 0
  
  -- Create a hitbox so that this can scroll as well
  self.buttonHitbox = Button({
    hitbox = {shape = 'rectangle', x = self.startX, y = self.startY, width = self.cmdListWidth, height = self.height}
  })
end

function CommandSelector:update()
  -- Update the max scroll based on number of commands
  local extra = (self.heightPerCommand * self.uiRef.availableCommands:getSize()) - self.height
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
    
  -- Check if any of the commands got clicked
  if lt ~= nil and lt.eventType == Touch.PRESS then
    for i = 0, self.uiRef.availableCommands:getSize() - 1, 1 do
      local x = self.startX
      local y = self.startY + (i * self.heightPerCommand) + self.offsetY
      local xi = lt.x > x and lt.x < x + self.cmdListWidth
      local yi = lt.y > y and lt.y < y + self.heightPerCommand
      if xi and yi then self.selectedIndex = i end
    end
  end
  
end

function CommandSelector:drawBottomScreen()
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
  
  -- Draw commands
  for i = 0, self.uiRef.availableCommands:getSize() - 1, 1 do
    local x = self.startX
    local y = self.startY + (i * self.heightPerCommand) + self.offsetY
    draw:brectangle({
      x = x, y = y, width = self.cmdListWidth, height = self.heightPerCommand, 
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
      text = self.uiRef.availableCommands:get(i).COMMAND_NAME,
    })
  end
end