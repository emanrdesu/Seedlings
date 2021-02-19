CommandEditor = Object:extend()

function CommandEditor:new(uiRef, commandRef)
  self.uiRef = uiRef
  self.commandRef = commandRef
  
  self.startX = 0
  self.startY = 0
  self.width = Constants.BOTTOM_SCREEN_WIDTH
  self.height = 240
  
  self.buttonList = ArrayList()
  
  -- Create the Exit button
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
  
  
  -- Create the buttons for the params for this command
  -- The refresh command creates all the buttons for the command. It's called refresh because it needs to be called after the command changes
  self:refresh()
end

function CommandEditor:refresh()
  -- Refreshes the buttons
  self.buttonList:clear()
  self.buttonList:add(self.exitButton)
  
  -- Create the button for the command type
  local cx = self.startX + 10
  local cy = self.startY + 10
  local cw = 200
  local ch = 30
  local cmdButton = Button({
    hitbox = {shape = 'rectangle', x = cx, y = cy, width = cw, height = ch},
    drawNormal = function()
      draw:rectangle({x=cx,y=cy,width=cw,height=ch,color=Color.LIGHT_GRAY})
      draw:print({x=cx+10,y=cy,color=Color.BLACK,font='18px',text='Type: '..self.commandRef.COMMAND_NAME})
    end,
    onClick = function()
      -- Add a command selector onto the stack and pass it the stuff it needs
      self.uiRef.uiStack:addLast(CommandSelector(self.uiRef, self.commandRef, self.uiRef.commandLister.selectedIndex, self))
    end
  })
  self.buttonList:add(cmdButton)
  
  -- Create the buttons for the params for this command
  local paramStartY = self.startY + 50
  local paramList = self.commandRef:getParamList()
  for i = 0, paramList:getSize() - 1, 1 do
    local width = 190
    local height = 30
    local x = self.startX
    local y = paramStartY + i * (height + 5)
    local param = paramList:get(i)
    local btn = Button({
      hitbox = {shape = 'rectangle', x = x, y = y, width = width, height = height},
      drawNormal = function()
        draw:rectangle({x=x,y=y,width=width,height=height,color=Color.LIGHT_GRAY})
        draw:print({x=x+10,y=y,color=Color.BLACK,font='18px',text=param.userString})
      end,
      onClick = function()
        -- Set a receiver in the inputManager (the command and which param we are editing. The love.textinput(text) function will then look at the inputManager and set the value if needed
        inputManager:setReceiver(self.commandRef, paramList:get(i).codeString, self)
        inputManager:setTextInput()
      end
    })
    self.buttonList:add(btn)
  end
end

function CommandEditor:update()
  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):update()
  end
end

function CommandEditor:drawBottomScreen()
  draw:rectangle({
    x = self.startX,
    y = self.startY,
    width = self.width,
    height = self.height,
    color = Color.EIGENGRAU,
  })
  
  -- Draw the buttons
  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):draw()
  end
end