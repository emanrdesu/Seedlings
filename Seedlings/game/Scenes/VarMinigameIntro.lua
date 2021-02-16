VarMinigameIntro = Scene:extend()

function VarMinigameIntro:new()
    blueShirtImage = love.graphics.newImage('Assets/Images/blue_shirt.png')
    blankShirtImage = love.graphics.newImage('Assets/Images/blank_shirt.png')
    greenShirtImage = love.graphics.newImage('Assets/Images/green_shirt.png')
    redShirtImage = love.graphics.newImage('Assets/Images/red_shirt.png')
    --yellowShirtImage = love.graphics.newImage('Assets/Images/yellow_shirt.png')
    zeroImage = love.graphics.newImage('Assets/Images/shirtlogo_zero.png')
    oneImage = love.graphics.newImage('Assets/Images/shirtlogo_one.png')
    twoImage = love.graphics.newImage('Assets/Images/shirtlogo_two.png')
    threeImage = love.graphics.newImage('Assets/Images/shirtlogo_three.png')
    fourImage = love.graphics.newImage('Assets/Images/shirtlogo_four.png')
    fiveImage = love.graphics.newImage('Assets/Images/shirtlogo_five.png')
    sixImage = love.graphics.newImage('Assets/Images/shirtlogo_six.png')
    sevenImage = love.graphics.newImage('Assets/Images/shirtlogo_seven.png')
    eightImage = love.graphics.newImage('Assets/Images/shirtlogo_eight.png')
    nineImage = love.graphics.newImage('Assets/Images/shirtlogo_nine.png')

    self.shirtScaleX = 1.3
    self.shirtScaleY = 1.3
    self.numberScaleX = 1
    self.numberScaleY = 1

    -- Random Pattern selection, choosing between 2 different patterns at the  moment
    randomSelector = love.math.random(1, 2)
    
    -- Generate random shirts
    self.shirt1 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())
    self.shirt2 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())
    self.shirt3 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())
    self.shirt4 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())
    self.shirt5 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())
    self.shirt6 = Shirt(generateRandomShirtColor(), generateRandomShirtNumber())

    -- Populate shirt  table w/ randomly generated shirts
    self.shirtTable = {self.shirt1, self.shirt2, self.shirt3, self.shirt4, self.shirt5, self.shirt6}

    -- Depending on what random pattern is chosen, choose a different desiredSequence
    self.desiredSequence = {}
    self.desiredNumbers = {}
    
    if randomSelector ==  1 then
        self.desiredSequence[1] = 'green'
        self.desiredSequence[2] = 'red'
        self.desiredSequence[3] = 'blue'
        self.desiredSequence[4] = 'green'
        self.desiredSequence[5] = 'red'
        self.desiredSequence[6] = 'blue'
    elseif randomSelector == 2 then
        self.desiredSequence[1] = 'blue'
        self.desiredSequence[2] = 'red'
        self.desiredSequence[3] = 'blue'
        self.desiredSequence[4] = 'red'
        self.desiredSequence[5] = 'blue'
        self.desiredSequence[6] = 'red'
    end
    
    self.desiredNumbers[1] = 1
    self.desiredNumbers[2] = 1
    self.desiredNumbers[3] = 1
    self.desiredNumbers[4] = 1
    self.desiredNumbers[5] = 1
    self.desiredNumbers[6] = 1
    

    -- Options for selecting  variables and colors
    self.variablesOptions = {'shirtColor', 'shirtNumber'}
    self.colorOptions = {'red',  'green', 'blue', 'blank'}
    self.numberOptions = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    
    -- Populate the user's default sequence w/ the randomly generated shirts
    self.userSequence = {}
    for i = 1, #self.shirtTable do
        self.userSequence[i] = self.shirtTable[i].shirtColor
    end
    
    -- Populate shirt numbers as well
    self.userNumbers = {}
    for i = 1, #self.userNumbers do
      self.userNumbers[i] = self.shirtTable[i].shirtNumber
    end
    
    -- Selectors for UI
    self.selectedTop = 1
    self.selectedBotLeft = 1
    self.selectedBotRight = 1
    
    -- Selector flags for choosing variables and values
    self.selectingShirt = true
    self.selectingVariable = false
    self.selectingValues = false
    self.selectingNumbers = false

    -- Indicator to see if we've matched the desired sequence
    self.sequencesMatching = false
end

function VarMinigameIntro:update()

    if inputManager:isPressed('dpright') then
        if self.selectedTop < #self.shirtTable then self.selectedTop = self.selectedTop + 1 end
    end

    if inputManager:isPressed('dpleft') then
        if self.selectedTop >  1  then self.selectedTop = self.selectedTop - 1 end
    end

    if inputManager:isPressed('dpup') then
        
        if self.selectingNumbers then
          if self.selectedBotRight > 1 then self.selectedBotRight = self.selectedBotRight - 1 end
        elseif self.selectingValues then
            if self.selectedBotRight > 1 then self.selectedBotRight = self.selectedBotRight - 1 end
        elseif self.selectingVariable then
            if self.selectedBotLeft > 1 then self.selectedBotLeft = self.selectedBotLeft - 1 end
        end
    end

    if inputManager:isPressed('dpdown') then
        if self.selectingNumbers then
          if self.selectedBotRight < #self.numberOptions then self.selectedBotRight = self.selectedBotRight + 1 end
        elseif self.selectingValues then
            if self.selectedBotRight < #self.colorOptions then self.selectedBotRight = self.selectedBotRight + 1 end
        elseif self.selectingVariable then
            if self.selectedBotLeft < #self.variablesOptions then self.selectedBotLeft = self.selectedBotLeft +  1 end
        end
    end

    if inputManager:isPressed('a') then

        if self.selectingNumbers then
          self.userNumbers[self.selectedTop] = self.numberOptions[self.selectedBotRight]
          self.selectingNumbers = false
          self.selectingVariable = false
          self.selectedBotRight = 1
        elseif self.selectingValues then
            self.userSequence[self.selectedTop] = self.colorOptions[self.selectedBotRight]
            self.selectingValues = false
            self.selectingVariable  = false
        elseif self.selectingShirt and self.selectingVariable and self.selectedBotLeft == 1 then
            self.selectingValues = true
        elseif self.selectingShirt and self.selectingVariable and self.selectedBotLeft ==  2 then
            self.selectingNumbers = true
        elseif self.selectingShirt then
            self.selectingVariable = true
        end
    end

    if inputManager:isPressed('b') then
        if self.selectingShirt and self.selectingVariable then
            self.selectingValues = false
            self.selectingNumbers = false
        end
        if self.selectingVariable then
            self.selectingVariable = false
        end
    end
    
    -- Loop w/ counter to check every update if the desired sequence matches the user's  input
    local counter = 0
    for i = 1, #self.desiredSequence  do
        if self.desiredSequence[i] == self.userSequence[i] then
            counter = counter + 1
        end
    end
    if counter == #self.desiredSequence then
        self.sequencesMatching = true
    end

    if self.sequencesMatching and inputManager:isPressed('start') then
        return VarMinigameBackpack()
    end

    return self
end

function VarMinigameIntro:drawTopScreen()
   
    -- Printing  desired sequence 
    for i = 1, #self.desiredSequence do
        local shirtColor =  self.desiredSequence[i]
        local shirtNumber = self.desiredNumbers[i]
        
        fontManager:setFont('18px_bold')
        love.graphics.print('DESIRED SEQUENCE', 105, 25)
        
        if shirtColor == 'red' then
            love.graphics.draw(redShirtImage, 40 * i, 40, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blue' then
            love.graphics.draw(blueShirtImage, 40 * i, 40, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'green' then
            love.graphics.draw(greenShirtImage, 40 * i, 40, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blank' then
            love.graphics.draw(blankShirtImage, 40 * i, 40, 0, self.shirtScaleX, self.shirtScaleY)
        end 
        
        if shirtNumber == 0 then
          love.graphics.draw(zeroImage, 45 * i, 50)
        elseif shirtNumber == 1 then
          love.graphics.draw(oneImage, 45 * i, 50)
        elseif shirtNumber == 2 then
          love.graphics.draw(twoImage, 45 * i, 50)
        elseif shirtNumber == 3 then
          love.graphics.draw(threeImage, 45 * i, 50)
        elseif shirtNumber == 4 then
          love.graphics.draw(fourImage, 45 * i, 50)
        elseif shirtNumber == 5 then
          love.graphics.draw(fiveImage, 45 * i, 50)
        elseif shirtNumber == 6 then
          love.graphics.draw(sixImage, 45 * i, 50)
        elseif shirtNumber == 7 then
          love.graphics.draw(sevenImage, 45 * i, 50)
        elseif shirtNumber == 8 then
          love.graphics.draw(eightImage, 45 * i, 50)
        elseif shirtNumber == 9 then
          love.graphics.draw(nineImage, 45 * i, 50)
        end

    end
    -- Printing "closet" shirts
    for i =  1, #self.userSequence do 
        local shirtColor = self.userSequence[i]
        local shirtNumber = self.userNumbers[i]
        
        love.graphics.print('CLOSET SEQUENCE', 100, 140)

        if shirtColor == 'red' then
            love.graphics.draw(redShirtImage, 40 * i, 150, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blue' then
            love.graphics.draw(blueShirtImage, 40 * i, 150, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'green' then
            love.graphics.draw(greenShirtImage, 40 * i, 150, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blank' then
            love.graphics.draw(blankShirtImage, 40 * i, 150, 0, self.shirtScaleX, self.shirtScaleY)
        end
        
        if shirtNumber == 0 then
          love.graphics.draw(zeroImage, 45 * i, 160)
        elseif shirtNumber == 1 then
          love.graphics.draw(oneImage, 45 * i, 160)
        elseif shirtNumber == 2 then
          love.graphics.draw(twoImage, 45 * i, 160)
        elseif shirtNumber == 3 then
          love.graphics.draw(threeImage, 45 * i, 160)
        elseif shirtNumber == 4 then
          love.graphics.draw(fourImage, 45 * i, 160)
        elseif shirtNumber == 5 then
          love.graphics.draw(fiveImage, 45 * i, 160)
        elseif shirtNumber == 6 then
          love.graphics.draw(sixImage, 45 * i, 160)
        elseif shirtNumber == 7 then
          love.graphics.draw(sevenImage, 45 * i, 160)
        elseif shirtNumber == 8 then
          love.graphics.draw(eightImage, 45 * i, 160)
        elseif shirtNumber == 9 then
          love.graphics.draw(nineImage, 45 * i, 160)
        end
        
        if i == self.selectedTop and i == 1 then
            love.graphics.print('*', 120, 200)
        elseif i == self.selectedTop and i == 2 then
            love.graphics.print('*', 160, 200)
        elseif i == self.selectedTop and i == 3 then
            love.graphics.print('*', 200, 200)
        elseif i == self.selectedTop and i == 4 then
            love.graphics.print('*', 240, 200)
        elseif i == self.selectedTop and i == 5 then
            love.graphics.print('*', 280, 200)
        elseif i == self.selectedTop and i == 6 then
            love.graphics.print('*', 320, 200)
        end
    end

    --[[
    for i,v in ipairs(self.userSequence) do
        love.graphics.print(v, 30  * i, 150)
    end
    ]]--

end

function VarMinigameIntro:drawBottomScreen()
    
    if self.selectingVariable and self.selectingNumbers then
        for i,v in ipairs(self.numberOptions) do
          love.graphics.print(v, 150, 20 * i)
          
          if i ==  self.selectedBotRight then
            love.graphics.print('*', 140, 20 * i)
          end
        end
    end
    
    if self.selectingVariable and self.selectingValues then  
        --[[
        for i,v in ipairs(self.variablesOptions) do
            love.graphics.print(v, 20, 30 * i)

            if i == self.selectedBotLeft then
                love.graphics.print('*', 10, 30 * i)
            end
        end
        ]]--
        for i,v in ipairs(self.colorOptions) do 
            love.graphics.print(v, 150, 30 * i)

            if i == self.selectedBotRight then
                love.graphics.print('*', 140, 30 * i)
            end
        end   
    
    end
    
    if self.selectingVariable then
        for i,v in ipairs(self.variablesOptions) do
            love.graphics.print(v, 20, 30 * i)

            if i == self.selectedBotLeft then
                love.graphics.print('*', 10, 30 * i)
            end
        end
    end

    if self.sequencesMatching then
        fontManager:setFont('18px_italic')
        love.graphics.print('Congrats, you matched the shirt pattern!', 10, 200)
    end

end

function generateRandomShirtColor()
    colors = {'red', 'blue', 'green', 'blank'}
    randomIndex = love.math.random(1, #colors)
    return colors[randomIndex]
end

function generateRandomShirtNumber()
    randomMin = 0
    randomMax = 9
    return love.math.random(randomMin, randomMax)
end