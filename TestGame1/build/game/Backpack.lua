Backpack = Object:extend()

function Backpack:new(backpackColor, numApples)
  self.numApples = numApples
  self.backpackColor = backpackColor
  self.objectName = 'Backpack'
end

function Backpack:toString()
  local s = tostring("numApples = " .. self.numApples .. " \nbackpackColor is " .. self.backpackColor)
  return s
end
