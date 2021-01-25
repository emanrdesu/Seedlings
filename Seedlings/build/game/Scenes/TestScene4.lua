TestScene4 = Scene:extend()

function TestScene4:new()
  self.topBG1 = love.graphics.newImage('Assets/Images/woodbackground.png')
  self.topBG2 = love.graphics.newImage('Assets/Images/greybkg.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
  self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
  self.greenCircle = love.graphics.newImage('Assets/Images/greenCircle.png')
  self.shirt = love.graphics.newImage('Assets/Images/BlueShirt6_Transparent.png')
  self.backpack = love.graphics.newImage('Assets/Images/backpackScaled.png')
  self.greenApple = love.graphics.newImage('Assets/Images/appleGreenScaled.png')
  self.redApple = love.graphics.newImage('Assets/Images/appleRedScaled.png')
  self.friend = love.graphics.newImage('Assets/Images/boyblue.png')
  
  self.backpackScaleX = 0.6
  self.backpackScaleY = 0.6
  self.friendScaleX = 0.4
  self.friendScaleY = 0.4
  self.shirtScaleX = 1.15
  self.shirtScaleY = 1.15
  self.circleScaleX = 0.5
  self.circleScaleY = 0.5
  
  shirtObject = Shirt('blue', 6)
  backpackObject = Backpack('red', 20)
  friendObject = Friend('Luke', false)
  
  self.gameObjects = {}
  self.gameObjects[1] = shirtObject
  self.gameObjects[2] = backpackObject
  self.gameObjects[3] = friendObject
  
  self.gameObjectImages = {}
  self.gameObjectImages[1] = self.shirt
  self.gameObjectImages[2] = self.backpack
  self.gameObjectImages[3] = self.friend
  
  self.selected = 1
  
  -- Table to see if all objects have been selected
  self.objectSelector = {}
  self.objectSelector[1] = false
  self.objectSelector[2] = false
  self.objectSelector[3] = false
  
end

function TestScene4:update()
  local dt = love.timer.getDelta()

  if inputManager:isPressed('dpright') then 
    if self.selected < #self.gameObjects then self.selected = self.selected + 1 end
  end 
  
  if inputManager:isPressed('dpleft') then
    if self.selected > 1 then self.selected = self.selected - 1 end
  end 
  
  if inputManager:isPressed('a') then
    self.objectSelector[self.selected] = true
  end
  
  if inputManager:isPressed('b') then 
    self.objectSelector[self.selected] = false
  end
  
  if self.objectSelector[1] and self.objectSelector[2] and self.objectSelector[3] and inputManager:isPressed('start') then
    return VarTutShirtScene()
  end
   
  return self
  
end

function TestScene4:drawTopScreen()
  love.graphics.setColor(0.25, 0.25, 0.67, 0.8)
  love.graphics.draw(self.topBG1, 0, 0)
  fontManager:setFont('18px_italic')
  love.graphics.print('Each of these things have something about \nthemselves they remember.', 0, 15)
  love.graphics.print('Use the dpad to select an object and press A to \nlearn more about it', 0, 195)
  
  for i = 1, #self.gameObjects do
    
    local object = self.gameObjects[i]
    local objectImage = self.gameObjectImages[i]
    fontManager:setFont('18px_bold')
    
    -- if/else conditionals to print the objects to the top screen,
    -- have to draw the circles first before drawing the object, used unique spacing for each object
    if objectImage == self.backpack then
      if self.selected == i then
        love.graphics.draw(self.greenCircle, 80 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      else
        love.graphics.draw(self.whiteCircle, 80 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      end
      love.graphics.draw(objectImage, 80 * i, 60, 0, self.backpackScaleX, self.backpackScaleY)
      love.graphics.print(object.objectName, 80 * i, 150)
    elseif objectImage == self.friend then
      if self.selected == i then
        love.graphics.draw(self.greenCircle, 90 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      else
        love.graphics.draw(self.whiteCircle, 90 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      end
      love.graphics.draw(objectImage, 95 * i, 60, 0, self.friendScaleX, self.friendScaleY)
      love.graphics.print(object.objectName, 95 * i, 150)
    else
      if self.selected == i then
        love.graphics.draw(self.greenCircle, 30 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      else
        love.graphics.draw(self.whiteCircle, 30 * i, 80, 0, self.circleScaleX, self.circleScaleY)
      end
      love.graphics.draw(objectImage, 30 * i, 80, 0, self.shirtScaleX, self.shirtScaleY)
      love.graphics.print(object.objectName, 45 * i, 150)
    end 
  end
  
end

function TestScene4:drawBottomScreen()
  love.graphics.draw(self.bottomBG, 0, 0)
  
  for i = 1, #self.objectSelector do
    if self.objectSelector[i] == true then
      fontManager:setFont('18px_bold')
      local object = self.gameObjects[i]
      love.graphics.print(object:toString(), 10, 55 * i)
    end
  end
  
  if self.objectSelector[1] and self.objectSelector[2] and self.objectSelector[3] then
    fontManager:setFont('18px_italic')
    love.graphics.print('Press START to continue (make sure you \nremember all the things!)')
  end
    
end