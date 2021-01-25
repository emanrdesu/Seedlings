VarTutBackpackScene = Scene:extend()

function VarTutBackpackScene:new()

    self.topBG = love.graphics.newImage('Assets/Images/woodbackground.png')
    self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
    self.backpackImage = love.graphics.newImage('Assets/Images/backpackScaled.png')
    self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
    self.arrow = love.graphics.newImage('Assets/Images/blueArrow.png')

    self.backpackScaleX = 0.6
    self.backpackScaleY = 0.6
    self.circleScaleX = 0.5
    self.circleScaleY = 0.5

    -- Get the backpack object generated in last scene
    self.backpackObject = TestScene4.backpackObject

    -- Table that holds the correct values of the backpack
    self.correctValues = {}
    self.correctValues[1] = backpackObject.numApples
    self.correctValues[2] = backpackObject.backpackColor

    -- Table that holds the correct variable names of the backpack
    self.correctVariables = {}
    self.correctVariables[1] = 'numApples'
    self.correctVariables[2] = 'backpackColor'

    -- Table to hold user's answer for matching the value to the corresponding variable
    self.userValues = {}
    self.userValues['numApples'] = nil
    self.userValues['backpackColor'] = nil

    -- Table to hold user's answer for matching variable name to corresponding value
    self.userVariables = {}
    self.userVariables[backpackObject.numApples] = nil
    self.userVariables[backpackObject.backpackColor] = nil
    --

    self.selected = 1
    self.selectedBot = 1

    self.selectingValues = true
    self.selectingVariables = false

    self.numApplesSelected = false
    self.backpackColorSelected = false

    self.numApplesMatched = false
    self.backpackColorMatched = false

    self.applesValueSelected = false
    self.backpackColorValueSelected = false

    self.applesValueMatched = false
    self.backpackColorValueMatched = false

end 

function VarTutBackpackScene:update()

    -- Using dpad to select both which variable and value to choose from
  if inputManager:isPressed('dpdown') then 
    if self.numApplesSelected or self.backpackColorSelected or self.applesValueSelected or self.backpackColorValueSelected then
      if self.selectedBot < #self.correctValues then self.selectedBot =  self.selectedBot + 1 end
    else
      if self.selected < #self.correctVariables then self.selected = self.selected + 1 end
    end
  end 
  
  if inputManager:isPressed('dpup') then
    if self.numApplesSelected or self.backpackColorSelected or self.applesValueSelected or self.backpackColorValueSelected then
      if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
    else
      if self.selected > 1 then self.selected = self.selected - 1 end
    end
  end
  
  if inputManager:isPressed('a') then
    
    if self.numApplesSelected then
      self.userValues['numApples'] = self.correctValues[self.selectedBot]
      self.numApplesSelected = false
    
    elseif self.backpackColorSelected then
      self.userValues['backpackColor'] = self.correctValues[self.selectedBot]
      self.backpackColorSelected = false

    elseif self.applesValueSelected then
      self.userVariables[backpackObject.numApples] = self.correctVariables[self.selectedBot]
      self.applesValueSelected = false
    
    elseif self.backpackColorValueSelected then
      self.userVariables[backpackObject.backpackColor] = self.correctVariables[self.selectedBot]
      self.backpackColorValueSelected = false
    
    elseif self.selected == 1 then
      if self.selectingValues then
        self.numApplesSelected = true
      elseif self.selectingVariables then
        self.applesValueSelected = true
      end

    elseif self.selected == 2 then
      if self.selectingValues then
        self.backpackColorSelected = true
      elseif self.selectingVariables then
        self.backpackColorValueSelected = true 
      end
    end
    
  end
  
  if inputManager:isPressed('b') then
    
    if self.selected == 1 then
      if self.selectingValues then
        self.numApplesSelected = false
      elseif self.selectingVariables then
        self.applesValueSelected = false
      end
    end
    
    if self.selected == 2 then
      if self.selectingValues then
        self.backpackColorSelected = false
      elseif self.selectingVariables then
        self.backpackColorValueSelected = false
      end
    end
    
  end
  
  if self.userValues['numApples'] == self.correctValues[1] then
    self.numApplesMatched = true
  end
  
  if self.userValues['backpackColor'] == self.correctValues[2] then
    self.backpackColorMatched = true
  end

  if self.userVariables[backpackObject.numApples] == self.correctVariables[1] then
    self.applesValueMatched = true
  end

  if self.userVariables[backpackObject.backpackColor] == self.correctVariables[2] then
    self.backpackColorValueMatched = true
  end
  
  if self.numApplesMatched and self.backpackColorMatched and inputManager:isPressed('start') then
    self.selectingValues = false
    self.selectingVariables = true
  end 
  
  if self.numApplesMatched and self.backpackColorMatched and self.applesValueMatched and self.backpackColorValueMatched and inputManager:isPressed('start') then
    return VarTutFriendScene()
  end
  
  return self

end

function VarTutBackpackScene:drawTopScreen()

  love.graphics.setColor(0.25, 0.25, 0.67, 0.8)
  love.graphics.draw(self.topBG, 0, 0)
  love.graphics.draw(self.whiteCircle, 160, 140, 0, self.circleScaleX, self.circleScaleY)
  love.graphics.draw(self.backpackImage, 160, 130, 0, self.backpackScaleX, self.backpackScaleY)
  fontManager:setFont('36px')
  love.graphics.print('Choose the correct one!', 0, 20)
  fontManager:setFont('18px_italic')
  love.graphics.print('Now can you remember all of the "things" \nfor your friends Backpack?', 55, 80)

end

function VarTutBackpackScene:drawBottomScreen()

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
    if self.numApplesSelected or self.backpackColorSelected then
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
    if self.numApplesMatched or self.backpackColorMatched then
      fontManager:setFont('18px_italic')
      if self.numApplesMatched and self.backpackColorMatched then 
        love.graphics.print('Congrats you matched both values! \nPress start to continue', 0, 200)
      elseif self.numApplesMatched then
        love.graphics.print('You matched numApples correctly!', 0, 215)
      elseif self.backpackColorMatched then 
        love.graphics.print('You matched backpackColor correctly!', 0, 215)
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

    love.graphics.rectangle('fill', 20, 50, 135,  40)
    love.graphics.print('NAMES', 35, 53)
    love.graphics.rectangle('line', 20, 90, 135, 40)
    love.graphics.rectangle('line', 20, 130, 135, 40)

    for i,v in ipairs(self.correctVariables) do
      if i == 1 then
        love.graphics.print(v, 25, 93)
      end
      if i == 2  then
        love.graphics.print(v,  25, 133)
      end
    end

    if self.applesValueSelected or self.backpackColorValueSelected then
      for i,v in ipairs(self.correctValues) do
        if self.selectedBot == 1 then
          love.graphics.draw(self.arrow, 155, 93, 0, -0.75, 0.75) 
        elseif self.selectedBot == 2 then
          love.graphics.draw(self.arrow, 155, 127, 0, -0.75, 0.75)
        end
      end
    end

    -- If they've chosen a correct answer, print the one they got correct
    -- If both are correct, tell them they got them both correct
    if self.applesValueMatched or self.backpackColorValueMatched then
      fontManager:setFont('18px_italic')
      if self.applesValueMatched and self.backpackColorValueMatched then 
        love.graphics.print('Congrats you matched both Variables!\nPress Start', 0, 195)
      elseif self.applesValueMatched then
        love.graphics.print('You matched the apples correctly!', 0, 215)
      elseif self.backpackColorValueMatched then 
        love.graphics.print('You matched the backpack color correctly!', 0, 215)
      end
      
    end
    
  end

end
