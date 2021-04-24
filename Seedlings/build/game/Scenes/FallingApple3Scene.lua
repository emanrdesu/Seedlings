FallingApple3Scene = Scene:extend()

function FallingApple3Scene:new(isTraining, originalRef)
  self.isTraining = isTraining
  self.originalRef = originalRef
  self.helpPressed = false
  self.backPressed = false
  
  self.commandUI = CommandUI(isTraining)
  self.commandUI:addAvailableCommand(AppleMoveLeft3)
  self.commandUI:addAvailableCommand(AppleMoveRight3)
  self.commandUI:addAvailableCommand(AppleCondition3)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(Else)
  self.commandUI:addAvailableCommand(AppleCustomCondition)
  self.commandUI:addAvailableCommand(AppleCustomMoveLeft)
  self.commandUI:addAvailableCommand(AppleCustomMoveRight)

  self.commandUI.commandManager:setTimePerLine(0.05)
  self.commandUI:setOnRun(
    function() 
      -- Reset game values if game is not running and not in summary stage
      if not self.running and not self.summary then
        self.running = true  
        self.timesFallen = 0 
        self.applesCaught = 0
      end
    end
  )
  if isTraining == true then
    self.commandUI:setOnBack(function() self.backPressed = true end)
  else
    self.commandUI:setOnHelp(function() self.helpPressed = true end)
  end
  
  if isTraining == true then
    self.commandUI.commandManager:addCommand(AppleCondition3({left='apple',mathOp='+',value='0',compOp='<=',right='basket'}))
    self.commandUI.commandManager:addCommand(AppleMoveLeft3({value='10'}))
    self.commandUI.commandManager:addCommand(Else())
    self.commandUI.commandManager:addCommand(AppleMoveRight3({value='10'}))
    self.commandUI.commandManager:addCommand(End())
  end
  
  -- Column info & apple img
  self.columnWidth = Constants.TOP_SCREEN_WIDTH
  self.columnStart = 0
  self.padding = 25
  self.catchTolerance = 20

  self.appleImg = love.graphics.newImage('Assets/Images/Objects/apple.png')
  self.basketImg = love.graphics.newImage('Assets/Images/Objects/basket.png')
  
  -- Apple info
  self.appleY = 0
  self.appleVel = 200
  self.appleR = 0
  self.appleDTheta = 9  
  self.appleScale = 0.18
  self.appleW, self.appleH = self.appleImg:getDimensions()
  self.appleRadius = (self.appleW * self.appleScale) / 2
  
  -- Game info
  self.running = false
  self.timesFallen = 0
  self.totalApples = 10
  self.applesCaught = 0
  
  self.basketY = 200
  
  -- Get the apple position (make it random)
  love.math.setRandomSeed(love.timer.getTime())
  self.startPosition = self:randomApplePosition()
  self.basketStartPosition = 50
  
  -- Create sandbox environment
  -- Stores the position of the person and apple
  sandbox = {
    basket = self.basketStartPosition,
    apple = self.startPosition,
  }
  
  self.intro = true
  if isTraining then self.intro = false end
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("This final falling apple game is very different from the last two. This time there are no columns. The apple will instead have a number value between 1 and 100")
  self.textBoxes:addText("The smaller values like 1 are on the left side of the screen. The larger values like 100 are on the right side of the screen.")
  self.textBoxes:addText("The move commands are also different. The basket, like an apple, has a value between 1 and 100 that starts at 50. Each move command has a number.")
  self.textBoxes:addText("The move left command makes the basket's value smaller by the number it has. The move right command makes the basket's value larger.")
  self.textBoxes:addText("You can modify this value for the move commands. The basket value will always remain between 1 and 100, even if you try to move it left when it has a value of 1.")
  self.textBoxes:addText("The if statement allows adding or subtracting a number when comparing the apple and basket. If you want more customization, use the custom commands.")
  self.textBoxes:addText("The custom move commands allow you to enter in your own number for moving the basket.")
  self.textBoxes:addText("The custom if statement allows you to write whatever you want for the conditions. Be careful!")
  self.textBoxes:addText("Try to catch all of the apples one last time!")
  self.textBoxes:addText("An apple will be caught by a basket if their values are closer than "..tostring(self.catchTolerance).." apart.")

  -- If summary is true, user is in the stage after all the apples fall that tells them whether they passed or failed
  self.summary = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Congratulations! You caught all of the apples. You are ready to move onto the next minigame now.")
  
  if isTraining then 
    self.gameClearTextBoxes = TextBoxList()
    self.gameClearTextBoxes:addText("Game Complete!\nClear the game while not in help mode to move to the next section")
  end
  
  self.gameFailTextBoxes = TextBoxList()

  local lock = saveManager:getValue('lock') or 0
  if lock < 10 then lock = 10 end
  saveManager:setValue('lock', lock)
end

function FallingApple3Scene:update()
   if self.helpPressed then
    self.helpPressed = false
    return FallingApple3Scene(true, self)
  end
  if self.backPressed then
    self.originalRef.running = false
    self.originalRef.timesFallen = 0 
    self.originalRef.applesCaught = 0
    self.originalRef:resetApple()
    sandbox.basket = self.basketStartPosition
    return self.originalRef
  end
  
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  elseif self.summary == true then
    if self.applesCaught == self.totalApples then
      -- Show the winning thing
      -- If finished with the game clear, go to Snake game
      if self.gameClearTextBoxes:update() then
        if self.isTraining then 
          self.originalRef.running = false
          self.originalRef.timesFallen = 0 
          self.originalRef.applesCaught = 0
          self.originalRef:resetApple()
          sandbox.basket = self.basketStartPosition
          return self.originalRef 
        end
        return Trans(SnakeScene)
      end
    else
      -- Show the losing thing
      if self.gameFailTextBoxes:update() then
        -- Exit the summary
        self.summary = false
      end
    end
  else
     if inputManager:isPressed('b') then return Trans(MainMenuScene) end
    
    -- Update UI
    self.commandUI:update()
    
    -- If running, process the stuff
    local dt = love.timer.getDelta()
    if self.running then
      
      -- In this game, always run the user's code
      if not self.commandUI.commandManager:codeIsRunning() then
        self.commandUI.commandManager:start()
      end
      
      -- Update command manager
      self.commandUI.commandManager:update()
      
      -- Have the apple fall
      self.appleY = self.appleY + self.appleVel * dt
      self.appleR = self.appleR + self.appleDTheta * dt
      
      -- Function to reset apple
      function resetApple()
        self:resetApple()
      end
      
      -- If the apple hits the user, add to the count of apples caught & create a new apple
      if self.appleY + self.appleRadius >= self.basketY + 25 
        and self.appleY + self.appleRadius <= self.basketY + 65
        and self:isCaught(sandbox.apple, sandbox.basket) then
        self.applesCaught = self.applesCaught + 1
        resetApple()
      end
      
      -- If the apple is done falling, put it back on top
      if self.appleY > Constants.TOP_SCREEN_HEIGHT + self.appleRadius then
        resetApple()
      end

    end
  end
    
  return self
end

function FallingApple3Scene:drawTopScreen()
  -- Draw the three columns
  function drawColumn(columnStart, columnWidth)
    draw:rectangle({
      x = columnStart,
      y = 0,
      width = columnWidth,
      height = Constants.TOP_SCREEN_HEIGHT,
      color = Color.YELLOW:withAlpha(0.3),
    })
  end
  drawColumn(self.columnStart, self.columnWidth)

  -- Draw the apple
  local appleX = math.floor(self.columnStart + self.padding + (self.columnWidth - 2 * self.padding) * (sandbox.apple / 100))
  draw:img({
    img = self.appleImg,
    x = appleX,
    y = self.appleY,
    r = self.appleR,
    sx = self.appleScale,
    sy = self.appleScale,
    center = true,
    rotateCenter = true,
  })
  
  -- Draw the basket
  local x = math.floor(self.columnStart + self.padding + (self.columnWidth - 2 * self.padding) * (sandbox.basket / 100))
  --[[draw:arc({
    mode = 'line',
    arctype = 'open',
    x = x,
    y = self.basketY,
    fromAngle = math.pi/2 + -1.5,
    toAngle = math.pi/2 + 1.5,
    color = Color.BLACK,
    segments = 10,
    lineWidth = 4,
    radius = 15,
  })--]]
  draw:img({
    x = x,
    y = self.basketY,
    sx = 1.2,
    sy = 1.2,
    center = true,
    img = self.basketImg,
  })
  
  -- Draw the information of number of apples caught
  draw:print({
    x = 145,
    y = 80,
    text = "Apples Caught:\n         "..tostring(self.applesCaught).." / "..tostring(self.totalApples),
    color = Color.BLACK,
    font = 'default',
  })
  
  if self.intro == true then self.textBoxes:drawTopScreen() end
  if self.summary == true then
    if self.applesCaught == self.totalApples then
      -- Show the winning thing
      self.gameClearTextBoxes:drawTopScreen()
    else
      -- Show the losing thing
      self.gameFailTextBoxes:drawTopScreen()
    end
  end
end

function FallingApple3Scene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  if self.intro == true then self.textBoxes:drawBottomScreen() end
  if self.summary == true then
    if self.applesCaught == self.totalApples then
      -- Show the winning thing
      self.gameClearTextBoxes:drawBottomScreen()
    else
      -- Show the losing thing
      self.gameFailTextBoxes:drawBottomScreen()
    end
  end
end

-- Random number between 1 and 100
function FallingApple3Scene:randomApplePosition()
  return math.ceil(100 * love.math.random())
end

function FallingApple3Scene:resetApple()
  self.appleY = - self.appleRadius
  self.appleR = 0
  sandbox.apple = self:randomApplePosition()
  self.hasRun = false
  self.timesFallen = self.timesFallen + 1
  if self.timesFallen >= self.totalApples then 
    self.running = false
    -- enter the summary stage of the game
    self.summary = true
    self.gameClearTextBoxes:reset()
    -- Update the fail list with how many apples were properly caught
    self.gameFailTextBoxes = TextBoxList()
    local appleText = "apples"
    if self.applesCaught == 1 then appleText = "apple" end
    self.gameFailTextBoxes:addText("Congratulations! You caught "..tostring(self.applesCaught).." "..appleText..". Try to catch all of the apples to clear the game")
  end
end

function FallingApple3Scene:isCaught(basket, apple)
  return math.abs(basket - apple) <= self.catchTolerance
end
