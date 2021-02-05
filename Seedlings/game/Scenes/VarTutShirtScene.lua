VarTutShirtScene = Scene:extend()

function VarTutShirtScene:new()
  self.topBG = love.graphics.newImage('Assets/Images/woodbackground.png')
  self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
  self.shirtImage = love.graphics.newImage('Assets/Images/BlueShirt6_Transparent.png')
  self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
  self.arrow = love.graphics.newImage('Assets/Images/blueArrow.png')
  
  self.shirtScaleX = 1.15
  self.shirtScaleY = 1.15
  self.circleScaleX = 0.5
  self.circleScaleY = 0.5
  
  -- Get the shirt object generated in last scene
  self.shirtObject = TestScene4.shirtObject
  
  -- Table that holds the correct values of the shirt
  self.correctValues = {}
  self.correctValues[1] = shirtObject.shirtColor
  self.correctValues[2] = shirtObject.shirtNumber
  
  -- Table that holds the correct variable names of the shirt
  self.correctVariables = {}
  self.correctVariables[1] = 'shirtColor'
  self.correctVariables[2] = 'shirtNumber'
  
  -- Table to hold user's answer for matching the value to the corresponding variable
  self.userValues = {}
  self.userValues['shirtColor'] = nil
  self.userValues['shirtNumber'] = nil
  
  -- Table to hold user's answer for matching variable name to corresponding value
  self.userVariables = {}
  self.userVariables[shirtObject.shirtColor] = nil
  self.userVariables[shirtObject.shirtNumber] = nil
  --
  
  self.selected = 1
  self.selectedBot = 1
  
  self.selectingValues = true
  self.selectingVariables = false
  
  self.shirtColorSelected = false
  self.shirtNumberSelected = false
  
  self.shirtColorMatched = false
  self.shirtNumberMatched = false

  self.colorValueSelected = false
  self.numberValueSelected = false

  self.colorValueMatched = false
  self.numberValueMatched = false
  
end

function VarTutShirtScene:update()
  
  -- Using dpad to select both which variable and value to choose from
  if inputManager:isPressed('dpdown') then 
    if self.shirtColorSelected or self.shirtNumberSelected or self.colorValueSelected or self.numberValueSelected then
      if self.selectedBot < #self.correctValues then self.selectedBot =  self.selectedBot + 1 end
    else
      if self.selected < #self.correctVariables then self.selected = self.selected + 1 end
    end
  end 
  
  if inputManager:isPressed('dpup') then
    if self.shirtColorSelected or self.shirtNumberSelected or self.colorValueSelected or self.numberValueSelected then
      if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
    else
      if self.selected > 1 then self.selected = self.selected - 1 end
    end
  end
  --[[
  if inputManager:isPressed('dpleft') then
    if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
  end
  
  if inputManager:isPressed('dpright') then
    if self.selectedBot < #self.correctValues then self.selectedBot = self.selectedBot + 1 end
  end
  ]]--
  if inputManager:isPressed('a') then
    
    if self.shirtColorSelected then
      self.userValues['shirtColor'] = self.correctValues[self.selectedBot]
      self.shirtColorSelected = false
    
    elseif self.shirtNumberSelected then
      self.userValues['shirtNumber'] = self.correctValues[self.selectedBot]
      self.shirtNumberSelected = false

    elseif self.colorValueSelected then
      self.userVariables[shirtObject.shirtColor] = self.correctVariables[self.selectedBot]
      self.colorValueSelected = false
    
    elseif self.numberValueSelected then
      self.userVariables[shirtObject.shirtNumber] = self.correctVariables[self.selectedBot]
      self.numberValueSelected = false
    
    elseif self.selected == 1 then
      if self.selectingValues then
        self.shirtColorSelected = true
      elseif self.selectingVariables then
        self.colorValueSelected = true
      end

    elseif self.selected == 2 then
      if self.selectingValues then
        self.shirtNumberSelected = true
      elseif self.selectingVariables then
        self.numberValueSelected = true 
      end
    end
    
  end
  
  if inputManager:isPressed('b') then
    
    if self.selected == 1 then
      if self.selectingValues then
        self.shirtColorSelected = false
      elseif self.selectingVariables then
        self.colorValueSelected = false
      end
    end
    
    if self.selected == 2 then
      if self.selectingValues then
        self.shirtNumberSelected = false
      elseif self.selectingVariables then
        self.numberValueSelected = false
      end
    end
    
  end
  
  if self.userValues['shirtColor'] == self.correctValues[1] then
    self.shirtColorMatched = true
  end
  
  if self.userValues['shirtNumber'] == self.correctValues[2] then
    self.shirtNumberMatched = true
  end

  if self.userVariables[shirtObject.shirtColor] == self.correctVariables[1] then
    self.colorValueMatched = true
  end

  if self.userVariables[shirtObject.shirtNumber] == self.correctVariables[2] then
    self.numberValueMatched = true
  end
  
  if self.shirtColorMatched and self.shirtNumberMatched and inputManager:isPressed('start') then
    self.selectingValues = false
    self.selectingVariables = true
  end 

  if self.shirtColorMatched and self.shirtNumberMatched and self.colorValueMatched and self.numberValueMatched and inputManager:isPressed('start') then
    return VarTutBackpackScene()
  end

  return self
end

function VarTutShirtScene:drawTopScreen()  
  love.graphics.setColor(0.25, 0.25, 0.67, 0.8)
  love.graphics.draw(self.topBG, 0, 0)
  love.graphics.draw(self.whiteCircle, 160, 140, 0, self.circleScaleX, self.circleScaleY)
  love.graphics.draw(self.shirtImage, 160, 150, 0, self.shirtScaleX, self.shirtScaleY)
  fontManager:setFont('36px')
  love.graphics.print('Choose the correct one!', 0, 20)
  fontManager:setFont('18px_italic')
  love.graphics.print('Can you remember all of the "things" \nfor your friends Shirt?', 55, 80)
  
end

function VarTutShirtScene:drawBottomScreen()
  love.graphics.draw(self.bottomBG, 0, 0)
  
  if self.selectingValues then
    fontManager:setFont('18px_italic')
    love.graphics.print('Select the correct VALUE from the list \nfor each "thing"')
    
    fontManager:setFont('18px_bold')
    for i,v in ipairs(self.correctVariables) do
      if i == 1 then
        love.graphics.print(v ..  ' is', 20, 70)
      elseif i == 2 then
        love.graphics.print(v .. ' is', 20, 180)
      end
      
      if self.selected == 1 then
        love.graphics.print('*', 10, 70)
      elseif self.selected == 2 then
        love.graphics.print('*', 10, 180)
      end
    end
    
    love.graphics.rectangle('fill', 200, 50, 100,  40)
    love.graphics.print('VALUES', 217, 53)
    love.graphics.rectangle('line', 200, 90, 100, 40)
    love.graphics.rectangle('line', 200, 130, 100, 40)
    
    for i,v in ipairs(self.correctValues) do
      if i == 1 then
        love.graphics.print(v, 210, 93)
      end
      if i == 2  then
        love.graphics.print(v,  210, 133)
      end
    end
    
    -- Draw arrows for when they're selecting values
    if self.shirtColorSelected or self.shirtNumberSelected then
      for i,v in ipairs(self.correctValues) do
        if self.selectedBot == 1 then
          love.graphics.draw(self.arrow, 130, 93, 0, 0.75, 0.75) 
        elseif self.selectedBot == 2 then
          love.graphics.draw(self.arrow, 130, 127, 0, 0.75, 0.75)
        end
      end
    end
    
    -- If they've chosen a correct answer, print the one they got correct
    -- If both are correct, tell them they got them both correct
    if self.shirtColorMatched or self.shirtNumberMatched then
      fontManager:setFont('18px_italic')
      if self.shirtColorMatched and self.shirtNumberMatched then 
        love.graphics.print('Congrats you matched both values! \nPress start to continue', 0, 200)
      elseif self.shirtColorMatched then
        love.graphics.print('You matched shirtColor correctly!', 0, 215)
      elseif self.shirtNumberMatched then 
        love.graphics.print('You matched shirtNumber correctly!', 0, 215)
      end
      
    end
  
  end

  if self.selectingVariables then
    fontManager:setFont('18px_italic')
    love.graphics.print('Select the correct "name" from the list \nwhich matches the value')

    fontManager:setFont('18px_bold')
    for i,v in ipairs(self.correctValues) do
      if i == 1 then
        love.graphics.print('is ' .. v, 210, 70)
      elseif i == 2 then
        love.graphics.print('is ' ..  v, 210, 180)
      end
      
      if self.selected == 1 then
        love.graphics.print('*', 200, 70)
      elseif self.selected == 2 then
        love.graphics.print('*', 200, 180)
      end
    end

    love.graphics.rectangle('fill', 20, 50, 120,  40)
    love.graphics.print('NAMES', 35, 53)
    love.graphics.rectangle('line', 20, 90, 120, 40)
    love.graphics.rectangle('line', 20, 130, 120, 40)

    for i,v in ipairs(self.correctVariables) do
      if i == 1 then
        love.graphics.print(v, 25, 93)
      end
      if i == 2  then
        love.graphics.print(v,  25, 133)
      end
    end

    if self.colorValueSelected or self.numberValueSelected then
      for i,v in ipairs(self.correctValues) do
        if self.selectedBot == 1 then
          love.graphics.draw(self.arrow, 140, 93, 0, -0.75, 0.75) 
        elseif self.selectedBot == 2 then
          love.graphics.draw(self.arrow, 140, 127, 0, -0.75, 0.75)
        end
      end
    end

    -- If they've chosen a correct answer, print the one they got correct
    -- If both are correct, tell them they got them both correct
    if self.colorValueMatched or self.numberValueMatched then
      fontManager:setFont('18px_italic')
      if self.colorValueMatched and self.numberValueMatched then 
        love.graphics.print('Congrats you matched both Variables!\nPress Start', 0, 195)
      elseif self.colorValueMatched then
        love.graphics.print('You matched the color correctly!', 0, 215)
      elseif self.numberValueMatched then 
        love.graphics.print('You matched the number correctly!', 0, 215)
      end
      
    end
    
  end 
     
end