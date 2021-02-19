FallingAppleScene = Scene:extend()

function FallingAppleScene:new()
  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(AppleMoveLeft)
  self.commandUI:addAvailableCommand(AppleMoveRight)
  self.commandUI.commandManager:setTimePerLine(0)
  
  -- Create sandbox environment
  -- Stores the position of the person
  sandbox = {
    position = 'left'
  }
end

function FallingAppleScene:update()
  self.commandUI:update()
  
  return self
end

function FallingAppleScene:drawTopScreen()

end

function FallingAppleScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
end