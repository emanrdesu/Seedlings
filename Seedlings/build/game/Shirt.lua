Shirt = Object:extend()

function Shirt:new(shirtColor, shirtNumber)
  self.shirtColor = shirtColor
  self.shirtNumber = shirtNumber
  self.objectName = 'Shirt'
end

function Shirt:toString()
  local s = tostring("shirtColor is " .. self.shirtColor .. " \nshirtNumber = " .. self.shirtNumber)
  return s
end