CTS = Scene:extend()

function CTS:new()
  self.commandUI = CommandUI()
  for i = 0, 10, 1 do
    self.commandUI:addAvailableCommand(SetValTo2)
  end
end

function CTS:update()
  self.commandUI:update()
  
  return self
end

function CTS:drawTopScreen()

end

function CTS:drawBottomScreen()
  self.commandUI:drawBottomScreen()
end