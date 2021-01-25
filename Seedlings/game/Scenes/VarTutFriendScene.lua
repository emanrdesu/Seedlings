VarTutFriendScene = Scene:extend()

function VarTutFriendScene:new()

    self.topBG = love.graphics.newImage('Assets/Images/woodbackground.png')
    self.bottomBG = love.graphics.newImage('Assets/Images/botbkg1.png')
    self.friendImage = love.graphics.newImage('Assets/Images/boyblue.png')
    self.whiteCircle = love.graphics.newImage('Assets/Images/whiteCircle.png')
    self.arrow = love.graphics.newImage('Assets/Images/blueArrow.png')

    self.friendScaleX = 0.4
    self.friendScaleY = 0.4
    self.circleScaleX = 0.5
    self.circleScaleY = 0.5

    -- Get the backpack object generated in last scene
    self.friendObject = TestScene4.friendObject

    -- Table that holds the correct values of the backpack
    self.correctValues = {}
    self.correctValues[1] = friendObject.friendName
    self.correctValues[2] = friendObject.friendHasHat

    -- Table that holds the correct variable names of the backpack
    self.correctVariables = {}
    self.correctVariables[1] = 'friendName'
    self.correctVariables[2] = 'friendHasHat'

    -- Table to hold user's answer for matching the value to the corresponding variable
    self.userValues = {}
    self.userValues['friendName'] = nil
    self.userValues['friendHasHat'] = nil

    -- Table to hold user's answer for matching variable name to corresponding value
    self.userVariables = {}
    self.userVariables[friendObject.friendName] = nil
    self.userVariables[friendObject.friendHasHat] = nil
    --

    self.selected = 1
    self.selectedBot = 1

    self.selectingValues = true
    self.selectingVariables = false

    self.nameSelected = false
    self.hasHatSelected = false

    self.nameMatched = false
    self.hasHatMatched = false

    self.nameValueSelected = false
    self.hatValueSelected = false

    self.nameValueMatched = false
    self.hatValueMatched = false

end

function VarTutFriendScene:update()

    
    -- Using dpad to select both which variable and value to choose from
  if inputManager:isPressed('dpdown') then 
    if self.nameSelected or self.hasHatSelected or self.nameValueSelected or self.hatValueSelected then
      if self.selectedBot < #self.correctValues then self.selectedBot =  self.selectedBot + 1 end
    else
      if self.selected < #self.correctVariables then self.selected = self.selected + 1 end
    end
  end 
  
  if inputManager:isPressed('dpup') then
    if self.nameSelected or self.hasHatSelected or self.nameValueSelected or self.hatValueSelected then
      if self.selectedBot > 1 then self.selectedBot = self.selectedBot - 1 end
    else
      if self.selected > 1 then self.selected = self.selected - 1 end
    end
  end
  
  if inputManager:isPressed('a') then
    
    if self.nameSelected then
      self.userValues['friendName'] = self.correctValues[self.selectedBot]
      self.nameSelected = false
    
    elseif self.hasHatSelected then
      self.userValues['friendHasHat'] = self.correctValues[self.selectedBot]
      self.hasHatSelected = false

    elseif self.nameValueSelected then
      self.userVariables[friendObject.friendName] = self.correctVariables[self.selectedBot]
      self.nameValueSelected = false
    
    elseif self.hatValueSelected then
      self.userVariables[friendObject.friendHasHat] = self.correctVariables[self.selectedBot]
      self.hatValueSelected = false
    
    elseif self.selected == 1 then
      if self.selectingValues then
        self.nameSelected = true
      elseif self.selectingVariables then
        self.nameValueSelected = true
      end

    elseif self.selected == 2 then
      if self.selectingValues then
        self.hasHatSelected = true
      elseif self.selectingVariables then
        self.hatValueSelected = true 
      end
    end
    
  end
  
  if inputManager:isPressed('b') then
    
    if self.selected == 1 then
      if self.selectingValues then
        self.nameSelected = false
      elseif self.selectingVariables then
        self.nameValueSelected = false
      end
    end
    
    if self.selected == 2 then
      if self.selectingValues then
        self.hasHatSelected = false
      elseif self.selectingVariables then
        self.hatValueSelected = false
      end
    end
    
  end
  
  if self.userValues['friendName'] == self.correctValues[1] then
    self.nameMatched = true
  end
  
  if self.userValues['friendHasHat'] == self.correctValues[2] then
    self.hasHatMatched = true
  end

  if self.userVariables[friendObject.friendName] == self.correctVariables[1] then
    self.nameValueMatched = true
  end

  if self.userVariables[friendObject.friendHasHat] == self.correctVariables[2] then
    self.hatValueMatched = true
  end
  
  if self.nameMatched and self.hasHatMatched and inputManager:isPressed('start') then
    self.selectingValues = false
    self.selectingVariables = true
  end 
  
  return self

end

function VarTutFriendScene:drawTopScreen()

  love.graphics.setColor(0.25, 0.25, 0.67, 0.8)
  love.graphics.draw(self.topBG, 0, 0)
  love.graphics.draw(self.whiteCircle, 160, 140, 0, self.circleScaleX, self.circleScaleY)
  love.graphics.draw(self.friendImage, 170, 130, 0, self.friendScaleX, self.friendScaleY)
  fontManager:setFont('36px')
  love.graphics.print('Choose the correct one!', 0, 20)
  fontManager:setFont('18px_italic')
  love.graphics.print('Now can you remember all of the "things" \nfor your friends Backpack?', 55, 80)

end

function VarTutFriendScene:drawBottomScreen()

    
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
        love.graphics.print(tostring(v),  210, 133)
      end
    end
    
    -- Draw arrows for when they're selecting values
    if self.nameSelected or self.hasHatSelected then
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
    if self.nameMatched or self.hasHatMatched then
      fontManager:setFont('18px_italic')
      if self.nameMatched and self.hasHatMatched then 
        love.graphics.print('Congrats you matched both values! \nPress start to continue', 0, 200)
      elseif self.nameMatched then
        love.graphics.print('You matched friendName correctly!', 0, 215)
      elseif self.hasHatMatched then 
        love.graphics.print('You matched friendHasHat correctly!', 0, 215)
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
        love.graphics.print('is ' ..  tostring(v), 210, 180)
      end
      
      if self.selected == 1 then
        love.graphics.print('*', 200, 70)
      elseif self.selected == 2 then
        love.graphics.print('*', 200, 180)
      end
    end

    love.graphics.rectangle('fill', 20, 50, 125,  40)
    love.graphics.print('NAMES', 35, 53)
    love.graphics.rectangle('line', 20, 90, 125, 40)
    love.graphics.rectangle('line', 20, 130, 125, 40)

    for i,v in ipairs(self.correctVariables) do
      if i == 1 then
        love.graphics.print(v, 25, 93)
      end
      if i == 2  then
        love.graphics.print(v,  25, 133)
      end
    end

    if self.nameValueSelected or self.hatValueSelected then
      for i,v in ipairs(self.correctValues) do
        if self.selectedBot == 1 then
          love.graphics.draw(self.arrow, 145, 93, 0, -0.75, 0.75) 
        elseif self.selectedBot == 2 then
          love.graphics.draw(self.arrow, 145, 127, 0, -0.75, 0.75)
        end
      end
    end

    -- If they've chosen a correct answer, print the one they got correct
    -- If both are correct, tell them they got them both correct
    if self.nameValueMatched or self.hatValueMatched then
      fontManager:setFont('18px_italic')
      if self.nameValueMatched and self.hatValueMatched then 
        love.graphics.print('Congrats you matched both Variables!\nPress Start', 0, 195)
      elseif self.nameValueMatched then
        love.graphics.print('You matched the apples correctly!', 0, 215)
      elseif self.hatValueMatched then 
        love.graphics.print('You matched the backpack color correctly!', 0, 215)
      end
      
    end
    
  end

end

