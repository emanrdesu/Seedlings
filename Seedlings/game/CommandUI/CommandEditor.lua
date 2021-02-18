CommandEditor = Object:extend()

function CommandEditor:new(uiRef, commandRef)
  self.uiRef = uiRef
  self.commandRef = commandRef
  
  self.startX = 0
  self.startY = 0
  self.width = Constants.BOTTOM_SCREEN_WIDTH
  self.height = 240
  
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
  
  -- Create the buttons for this command
  local paramList = self.commandRef:getParamList()
  for i = 0, paramList:getSize() - 1, 1 do
    local width = 30
    local height = 30
    local x = self.startX
    local y = self.startY + i * (height + 5)
    local btn = Button({
      hitbox = {shape = 'rectangle', x = x, y = y, width = width, height = height},
      drawNormal = function()
        draw:rectangle({x=x,y=y,width=width,height=height,color=Color.BLUE})
      end,
      onClick = function()
        inputManager:setReadingInput(true)
        love.keyboard.setTextInput({isPassword=false, hint=''})
        -- Set a receiver in the inputManager (the command and which param we are editing. The love.textinput(text) function will then look at the inputManager and set the value if needed
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