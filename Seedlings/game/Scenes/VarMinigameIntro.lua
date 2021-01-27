VarMinigameIntro = Scene:extend()

function VarMinigameIntro:new()
    blueShirtImage = love.graphics.newImage('Assets/Images/BlueShirt6_Transparent.png')
    blackShirtImage = love.graphics.newImage('Assets/Images/BlackShirt-removebg-preview.png')
    greenShirtImage = love.graphics.newImage('Assets/Images/GreenShirt-removebg-preview.png')
    redShirtImage = love.graphics.newImage('Assets/Images/RedShirt-removebg-preview.png')
    yellowShirtImage = love.graphics.newImage('Assets/Images/YellowShirt-removebg-preview.png')

    self.shirtScaleX = 0.9
    self.shirtScaleY = 0.9

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
    desiredSequence = {}
    
    if randomSelector ==  1 then
        desiredSequence[1] = 'green'
        desiredSequence[2] = 'red'
        desiredSequence[3] = 'blue'
        desiredSequence[4] = 'green'
        desiredSequence[5] = 'red'
        desiredSequence[6] = 'blue'
    elseif randomSelector == 2 then
        desiredSequence[1] = 'blue'
        desiredSequence[2] = 'red'
        desiredSequence[3] = 'blue'
        desiredSequence[4] = 'red'
        desiredSequence[5] = 'blue'
        desiredSequence[6] = 'red'
    end

    -- Options for selecting  variables and colors
    self.variablesOptions = {'shirtColor', 'shirtNumber'}
    self.colorOptions = {'red',  'green', 'blue', 'yellow'}
    
    -- Populate the user's default sequence w/ the randomly generated shirts
    self.userSequence = {}
    for i = 1, #self.shirtTable do
        self.userSequence[i] = self.shirtTable[i].shirtColor
    end

    -- Selectors for UI
    self.selectedTop = 1
    self.selectedBotLeft = 1
    self.selectedBotRight = 1
    
    -- Selector flags for choosing variables and values
    self.selectingShirt = true
    self.selectingVariable = false
    self.selectingValues = false

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
        
        if self.selectingValues then
            if self.selectedBotRight > 1 then self.selectedBotRight = self.selectedBotRight - 1 end
        elseif self.selectingVariable then
            if self.selectedBotLeft > 1 then self.selectedBotLeft = self.selectedBotLeft - 1 end
        end
    end

    if inputManager:isPressed('dpdown') then
        
        if self.selectingValues then
            if self.selectedBotRight < #self.colorOptions then self.selectedBotRight = self.selectedBotRight + 1 end
        elseif self.selectingVariable then
            if self.selectedBotLeft < #self.variablesOptions then self.selectedBotLeft = self.selectedBotLeft +  1 end
        end
    end

    if inputManager:isPressed('a') then

        if self.selectingValues  then
            self.userSequence[self.selectedTop] = self.colorOptions[self.selectedBotRight]
            self.selectingValues = false
            self.selectingVariable  = false
        elseif self.selectingShirt and self.selectingVariable and self.selectedBotLeft == 1 then
            self.selectingValues = true
        elseif  self.selectingShirt then
            self.selectingVariable = true
        end
    end

    if inputManager:isPressed('b') then
        if self.selectingShirt and self.selectingVariable then
            self.selectingValues = false
        end
        if self.selectingVariable then
            self.selectingVariable = false
        end
    end
    
    -- Loop w/ counter to check every update if the desired sequence matches the user's  input
    local counter = 0
    for i = 1, #desiredSequence  do
        if desiredSequence[i] == self.userSequence[i] then
            counter = counter + 1
        end
    end
    if counter == #desiredSequence then
        self.sequencesMatching = true
    end

    return self
end

function VarMinigameIntro:drawTopScreen()
   
    -- Printing  desired sequence 
    for i = 1, #desiredSequence do
        local shirtColor =  desiredSequence[i]
        fontManager:setFont('18px_bold')
        love.graphics.print('DESIRED SEQUENCE', 105, 25)

        if shirtColor == 'red' then
            love.graphics.draw(redShirtImage, 50 * i, 50, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blue' then
            love.graphics.draw(blueShirtImage, 50 * i, 50, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'green' then
            love.graphics.draw(greenShirtImage, 50 * i, 50, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'black' then
            love.graphics.draw(blackShirtImage, 50 * i, 50, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'yellow' then
            love.graphics.draw(yellowShirtImage, 50 * i, 50, 0, self.shirtScaleX, self.shirtScaleY)
        end 

    end
    -- Printing "closet" shirts
    for i =  1, #self.userSequence do 
        local shirtColor = self.userSequence[i]
        love.graphics.print('CLOSET SEQUENCE', 100, 140)

        if shirtColor == 'red' then
            love.graphics.draw(redShirtImage, 50 * i, 160, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blue' then
            love.graphics.draw(blueShirtImage, 50 * i, 160, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'green' then
            love.graphics.draw(greenShirtImage, 50 * i, 160, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'black' then
            love.graphics.draw(blackShirtImage, 50 * i, 160, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'yellow' then
            love.graphics.draw(yellowShirtImage, 50 * i, 160, 0, self.shirtScaleX, self.shirtScaleY)
        end

        if i == self.selectedTop then
            love.graphics.print('*', 50 * i, 190)
        end
    end

    --[[
    for i,v in ipairs(self.userSequence) do
        love.graphics.print(v, 30  * i, 150)
    end
    ]]--

end

function VarMinigameIntro:drawBottomScreen()
    
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
    colors = {'red', 'blue', 'green', 'yellow', 'black'}
    randomIndex = love.math.random(1, #colors)
    return colors[randomIndex]
end

function generateRandomShirtNumber()
    randomMin = 1
    randomMax = 10
    return love.math.random(randomMin, randomMax)
end