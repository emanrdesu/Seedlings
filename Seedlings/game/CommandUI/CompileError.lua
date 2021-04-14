CompileError = Object:extend()

function CompileError:new(uiRef)
  self.uiRef = uiRef
  
  --[[
  self.startX = 3
  self.startY = 3
  self.width = 240
  self.height = 235
  
  self.padX = 10
  self.padY = 10
  --]]
  self.startX = 10
  self.startY = 10
  self.width = 226
  self.height = 219
  
  self.padX = 10
  self.padY = 10
  
  self.tb = TextBox({
    x = self.startX + self.padX,
    y = self.startY + self.padY,
    width = self.width - 2 * self.padX,
    font = 'default',
    align = 'center',
    color = Color.BLACK,
  })
  
  self.tb:setText("It looks like there is an issue with the format of your code. If you need help with how code is formatted, press the HELP button for an example.\n\n(Press 'a' to close this notification)")
  
end

function CompileError:update()
  if inputManager:isPressed('a') then
    self.uiRef.uiStack:pollLast()
  end
end

function CompileError:drawBottomScreen()
  draw:rectangle({
    x = self.startX,
    y = self.startY,
    width = self.width,
    height = self.height,
    color = Color.LIGHT_GRAY,
  })
  self.tb:draw()
end