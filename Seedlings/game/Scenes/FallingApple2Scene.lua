FallingApple2Scene = Scene:extend()

function FallingApple2Scene:new()
  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(AppleMoveLeft2)
  self.commandUI:addAvailableCommand(AppleMoveRight2)
  self.commandUI:addAvailableCommand(AppleCondition2)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(Else)
  self.commandUI.commandManager:setTimePerLine(0.15)
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
  
  -- Column info & apple img
  self.columnWidth = 60
  self.distFromSide = 30
  self.distBetweenColumns = 80
  
  self.leftX = math.floor(self.distFromSide + (self.columnWidth / 2))
  self.centerX = self.leftX + self.distBetweenColumns
  self.rightX = self.centerX + self.distBetweenColumns
  self.appleImg = love.graphics.newImage('Assets/Images/Objects/apple.png')
  
  -- Apple info
  self.appleY = 0
  self.appleVel = 200
  self.appleR = 0
  self.appleDTheta = 9  
  self.appleScale = 0.26
  self.appleW, self.appleH = self.appleImg:getDimensions()
  self.appleRadius = (self.appleW * self.appleScale) / 2
  
  -- Game info
  self.running = false
  self.timesFallen = 0
  self.totalApples = 10
  self.applesCaught = 0
  
  self.basketY = 200
  
  -- Info for when to run users code
  self.hasRun = false
  self.yToRunAt = 40
  
  -- Get the apple position (make it random)
  love.math.setRandomSeed(love.timer.getTime())
  self.startPosition = self:randomApplePosition()
  
  -- Create sandbox environment
  -- Stores the position of the person and apple
  sandbox = {
    basket = 'left',
    apple = self.startPosition,
    left = 'left',
    center = 'center',
    right = 'right',
  }
  
  self.intro = true
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("This falling apple game is similar to the previous one. However in this game, there are 3 columns instead of of 2. The 3 columns are 'left', 'right', and 'center'.")
  self.textBoxes:addText("The move left command will move the basket one column to the left, or not move it if the basket is already in the left column.")
  self.textBoxes:addText("The move right command does the same thing in the opposite direction.")
  self.textBoxes:addText("Keep in mind that you may move the basket multiple times in your code.")
  self.textBoxes:addText("For example, moving the basket left twice will have the basket end up in the left column regardless of where it started.")
  self.textBoxes:addText("Try to catch all of the apples again!")

  -- If summary is true, user is in the stage after all the apples fall that tells them whether they passed or failed
  self.summary = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Congratulations! You caught all of the apples. You are ready to move onto the next minigame now.")
  
  self.gameFailTextBoxes = TextBoxList()
end

function FallingApple2Scene:update()
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  elseif self.summary == true then
    if self.applesCaught == self.totalApples then
      -- Show the winning thing
      -- If finished with the game clear, go to main menu
      if self.gameClearTextBoxes:update() then
        return MainMenuScene()
      end
    else
      -- Show the losing thing
      if self.gameFailTextBoxes:update() then
        -- Exit the summary
        self.summary = false
      end
    end
  else
    if inputManager:isPressed('b') then return MainMenuScene() end
    
    -- Update UI
    self.commandUI:update()
    
    -- If running, process the stuff
    local dt = love.timer.getDelta()
    if self.running then
      -- Update command manager
      self.commandUI.commandManager:update()
      
      -- Have the apple fall
      self.appleY = self.appleY + self.appleVel * dt
      self.appleR = self.appleR + self.appleDTheta * dt
    
      -- If past the threshhold, run user code
      if self.hasRun == false and self.appleY >= self.yToRunAt then
        self.commandUI.commandManager:start()
        self.hasRun = true
      end
      
      -- Function to reset apple
      function resetApple()
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
      
      -- If the apple hits the user, add to the count of apples caught & create a new apple
      if self.appleY + self.appleRadius >= self.basketY + 35 and sandbox.apple == sandbox.basket then
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

function FallingApple2Scene:drawTopScreen()
  -- Draw the three columns
  function drawColumn(columnX, columnWidth)
    draw:rectangle({
      x = columnX - (columnWidth / 2),
      y = 0,
      width = columnWidth,
      height = Constants.TOP_SCREEN_HEIGHT,
      color = Color.YELLOW:withAlpha(0.3),
    })
  end
  drawColumn(self.leftX, self.columnWidth)
  drawColumn(self.rightX, self.columnWidth)
  drawColumn(self.centerX, self.columnWidth)
  
  -- Draw the basket
  local x = 0
  if sandbox.basket == 'left' then
    x = self.leftX
  elseif sandbox.basket == 'center' then
    x = self.centerX
  else
    x = self.rightX
  end
  draw:arc({
    mode = 'line',
    arctype = 'open',
    x = x,
    y = self.basketY,
    fromAngle = math.pi/2 + -1.5,
    toAngle = math.pi/2 + 1.5,
    color = Color.BLACK,
    segments = 10,
    lineWidth = 5,
    radius = 25,
  })

  -- Draw the apple
  local appleX = 0
  if sandbox.apple == 'left' then
    appleX = self.leftX
  elseif sandbox.apple == 'center' then
    appleX = self.centerX
  else
    appleX = self.rightX
  end
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
  
  -- Draw the information of number of apples caught
  draw:print({
    x = 270,
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

function FallingApple2Scene:drawBottomScreen()
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

function FallingApple2Scene:randomApplePosition()
  local v = love.math.random()
  if v <= 0.333333 then return 'left' end
  if v <= 0.666666 then return 'center' end
  return 'right'
end