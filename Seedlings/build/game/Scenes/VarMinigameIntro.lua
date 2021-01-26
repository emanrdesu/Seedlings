VarMinigameIntro = Scene:extend()

function VarMinigameIntro:new()
    blueShirtImage = love.graphics.newImage('Assets/Images/BlueShirt6_Transparent.png')
    blackShirtImage = love.graphics.newImage('Assets/Images/BlackShirt-removebg-preview.png')
    greenShirtImage = love.graphics.newImage('Assets/Images/GreenShirt-removebg-preview.png')
    redShirtImage = love.graphics.newImage('Assets/Images/RedShirt-removebg-preview.png')
    yellowShirtImage = love.graphics.newImage('Assets/Images/YellowShirt-removebg-preview.png')

    self.shirtScaleX = 1.15
    self.shirtScaleY = 1.15
    
    self.shirt1 = Shirt('blue', generateRandomShirtNumber())
    self.shirt2 = Shirt('red', generateRandomShirtNumber())
    self.shirt3 = Shirt('black', generateRandomShirtNumber())
    self.shirt4 = Shirt('green', generateRandomShirtNumber())
    self.shirt5 = Shirt('blue', generateRandomShirtNumber())
    self.shirt6 = Shirt('yellow', generateRandomShirtNumber())

    self.shirtTable = {self.shirt1, self.shirt2, self.shirt3, self.shirt4, self.shirt5, self.shirt6}

    self.desiredSequence = {'green', 'blue', 'red', 'green', 'blue', 'red'}
    self.variablesOptions = {'shirtColor', 'shirtNumber'}
    self.colorOptions = {'red',  'green', 'blue', 'yellow'}
    self.userSequence = {}

    self.selectedTop = 1
    self.selectedBotLeft = 1
    self.selectedBotRight = 1
    
    self.selectingShirt = true
    self.selectingVariable = false
    self.selectingValues = false

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
        elseif self.selectingShirt and self.selectingVariable and self.selectedBotLeft == 1 then
            self.selectingValues = true
        elseif  self.selectingShirt then
            self.selectingVariable = true
        end
    end

    if inputManager:isPressed('b') then
        if self.selectingShirt and self.selectingVariable then
            self.selectingValues = false
        elseif self.selectingVariable then
            self.selectingVariable = false
        end
    end
    
    return self
end

function VarMinigameIntro:drawTopScreen()
   
    for i =  1, #self.shirtTable do 
        object = self.shirtTable[i]
        local shirtColor = object.shirtColor

        if shirtColor == 'red' then
            love.graphics.draw(redShirtImage, 50 * i, 20, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'blue' then
            love.graphics.draw(blueShirtImage, 50 * i, 20, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'green' then
            love.graphics.draw(greenShirtImage, 50 * i, 20, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'black' then
            love.graphics.draw(blackShirtImage, 50 * i, 20, 0, self.shirtScaleX, self.shirtScaleY)
        elseif shirtColor == 'yellow' then
            love.graphics.draw(yellowShirtImage, 50 * i, 20, 0, self.shirtScaleX, self.shirtScaleY)
        end

        if i == self.selectedTop then
            love.graphics.print('*', 50 * i, 40)
        end
    end

    for i,v in ipairs(self.userSequence) do
        love.graphics.print(v, 30  * i, 100)
    end
    

end

function VarMinigameIntro:drawBottomScreen()
    
    if self.selectingVariable and self.selectingValues then  
        for i,v in ipairs(self.variablesOptions) do
            love.graphics.print(v, 20, 30 * i)

            if i == self.selectedBotLeft then
                love.graphics.print('*', 10, 30 * i)
            end
        end
        
        for i,v in ipairs(self.colorOptions) do 
            love.graphics.print(v, 150, 30 * i)

            if i == self.selectedBotRight then
                love.graphics.print('*', 140, 30 * i)
            end
        end   
    
    elseif self.selectingVariable then
        for i,v in ipairs(self.variablesOptions) do
            love.graphics.print(v, 20, 30 * i)

            if i == self.selectedBotLeft then
                love.graphics.print('*', 10, 30 * i)
            end
        end
    end

end

function generateRandomShirtColor()
    colors = {'red', 'blue', 'green', 'yellow', 'orange', 'white', 'black', 'magenta'}
    randomIndex = love.math.random(1, #colors)
    return colors[randomIndex]
end

function generateRandomShirtNumber()
    randomMin = 1
    randomMax = 10
    return love.math.random(randomMin, randomMax)
end