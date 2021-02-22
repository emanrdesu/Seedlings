VarMinigameBackpack =  Scene:extend()

function VarMinigameBackpack:new()
    blueBackpackImage = love.graphics.newImage('Assets/Images/backpackBlue.png')
    blackBackpackImage = love.graphics.newImage('Assets/Images/backpackBlack.png')
    greenBackpackImage = love.graphics.newImage('Assets/Images/backpackGreen.png')
    redBackpackImage = love.graphics.newImage('Assets/Images/backpackScaled.png')
    yellowBackpackImage = love.graphics.newImage('Assets/Images/backpackYellow.png')

    self.backpackScaleX = 0.5
    self.backpackScaleY = 0.5

    -- Random Pattern selection, choosing between 2 different patterns at the  moment
    randomSelector = love.math.random(1, 2)
    
    -- Generate random shirts
    self.backpack1 = Backpack(generateRandomColor(), generateRandomNumber())
    self.backpack2 = Backpack(generateRandomColor(), generateRandomNumber())
    self.backpack3 = Backpack(generateRandomColor(), generateRandomNumber())
    self.backpack4 = Backpack(generateRandomColor(), generateRandomNumber())
    self.backpack5 = Backpack(generateRandomColor(), generateRandomNumber())
    self.backpack6 = Backpack(generateRandomColor(), generateRandomNumber())

    -- Populate backpack table w/ randomly generated shirts
    self.backpackTable = {self.backpack1, self.backpack2, self.backpack3, self.backpack4, self.backpack5, self.backpack6}

    -- Depending on what random pattern is chosen, choose a different desiredSequence
    desiredSequence = {}
    
    if randomSelector ==  1 then
        desiredSequence[1] = 'yellow'
        desiredSequence[2] = 'green'
        desiredSequence[3] = 'black'
        desiredSequence[4] = 'yellow'
        desiredSequence[5] = 'green'
        desiredSequence[6] = 'black'
    elseif randomSelector == 2 then
        desiredSequence[1] = 'blue'
        desiredSequence[2] = 'yellow'
        desiredSequence[3] = 'blue'
        desiredSequence[4] = 'yellow'
        desiredSequence[5] = 'blue'
        desiredSequence[6] = 'yellow'
    end

    -- Options for selecting  variables and colors
    self.variablesOptions = {'backpackColor', 'numApples'}
    self.colorOptions = {'red',  'green', 'blue', 'yellow', 'black'}
    
    -- Populate the user's default sequence w/ the randomly generated shirts
    self.userSequence = {}
    for i = 1, #self.backpackTable do
        self.userSequence[i] = self.backpackTable[i].backpackColor
    end

    -- Selectors for UI
    self.selectedTop = 1
    self.selectedBotLeft = 1
    self.selectedBotRight = 1
    
    -- Selector flags for choosing variables and values
    self.selectingBackpack = true
    self.selectingVariable = false
    self.selectingValues = false

    -- Indicator to see if we've matched the desired sequence
    self.sequencesMatching = false
end

function VarMinigameBackpack:update()

    if inputManager:isPressed('dpright') then
        if self.selectedTop < #self.backpackTable then self.selectedTop = self.selectedTop + 1 end
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
        elseif self.selectingBackpack and self.selectingVariable and self.selectedBotLeft == 1 then
            self.selectingValues = true
        elseif  self.selectingBackpack then
            self.selectingVariable = true
        end
    end

    if inputManager:isPressed('b') then
        if self.selectingBackpack and self.selectingVariable then
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

function VarMinigameBackpack:drawTopScreen()
   
    -- Printing  desired sequence 
    for i = 1, #desiredSequence do
        local backpackColor =  desiredSequence[i]
        fontManager:setFont('18px_bold')
        love.graphics.print('DESIRED SEQUENCE', 105, 25)

        if backpackColor == 'red' then
            love.graphics.draw(redBackpackImage, 50 * i, 50, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'blue' then
            love.graphics.draw(blueBackpackImage, 50 * i, 50, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'green' then
            love.graphics.draw(greenBackpackImage, 50 * i, 50, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'black' then
            love.graphics.draw(blackBackpackImage, 50 * i, 50, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'yellow' then
            love.graphics.draw(yellowBackpackImage, 50 * i, 50, 0, self.backpackScaleX, self.backpackScaleY)
        end 

    end
    -- Printing "closet" shirts
    for i = 1, #self.userSequence do 
        local backpackColor = self.userSequence[i]
        love.graphics.print('CLOSET SEQUENCE', 100, 140)

        if backpackColor == 'red' then
            love.graphics.draw(redBackpackImage, 50 * i, 150, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'blue' then
            love.graphics.draw(blueBackpackImage, 50 * i, 150, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'green' then
            love.graphics.draw(greenBackpackImage, 50 * i, 150, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'black' then
            love.graphics.draw(blackBackpackImage, 50 * i, 150, 0, self.backpackScaleX, self.backpackScaleY)
        elseif backpackColor == 'yellow' then
            love.graphics.draw(yellowBackpackImage, 50 * i, 150, 0, self.backpackScaleX, self.backpackScaleY)
        end 

        if i == self.selectedTop then
            love.graphics.print('*', 50 * i, 190)
        end
    end

end

function VarMinigameBackpack:drawBottomScreen()
    
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
        love.graphics.print('Congrats, you matched the backpack pattern!', 10, 200)
    end

end

function generateRandomColor()
    colors = {'red', 'blue', 'green', 'yellow', 'black'}
    randomIndex = love.math.random(1, #colors)
    return colors[randomIndex]
end

function generateRandomNumber()
    randomMin = 1
    randomMax = 10
    return love.math.random(randomMin, randomMax)
end