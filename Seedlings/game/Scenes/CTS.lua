CTS = Scene:extend()

function CTS:new()
  self.commandUI = CommandUI()
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