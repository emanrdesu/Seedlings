FallingAppleScene = Scene:extend()

function FallingAppleScene:new(isTraining, originalRef)
  self.isTraining = isTraining
  self.originalRef = originalRef
  self.helpPressed = false
  self.backPressed = false
  
  self.commandUI = CommandUI(isTraining)
  self.commandUI:addAvailableCommand(AppleMoveLeft)
  self.commandUI:addAvailableCommand(AppleMoveRight)
  self.commandUI:addAvailableCommand(AppleCondition)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(Else)
  self.commandUI.commandManager:setTimePerLine(0.2)
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
    self.commandUI.commandManager:addCommand(
      AppleCondition({left = 'apple', op = '==', right = 'left'})
    )
    self.commandUI.commandManager:addCommand(
      AppleMoveLeft()
    )
    self.commandUI.commandManager:addCommand(
      Else()
    )
    self.commandUI.commandManager:addCommand(
      AppleMoveRight()
    )
    self.commandUI.commandManager:addCommand(
      End()
    )
  end
  
  -- Column info & apple img
  self.columnWidth = 60
  self.distFromSide = 75
  
  self.leftX = math.floor(self.distFromSide + (self.columnWidth / 2))
  self.rightX = math.floor(Constants.TOP_SCREEN_WIDTH - self.distFromSide - (self.columnWidth / 2))
  self.appleImg = love.graphics.newImage('Assets/Images/Objects/apple.png')
  self.basketImg = love.graphics.newImage('Assets/Images/Objects/basket.png')
  
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
  self.totalApples = 8
  self.applesCaught = 0
  
  self.basketY = 200
  
  -- Info for when to run users code
  self.hasRun = false
  self.yToRunAt = 40
  
  -- Get the apple position (make it random)
  love.math.setRandomSeed(love.timer.getTime())
  self.startPosition = 'left'
  if love.math.random() >= 0.5 then self.startPosition = 'right' end
  
  -- Create sandbox environment
  -- Stores the position of the person and apple
  sandbox = {
    basket = 'left',
    apple = self.startPosition,
    left = 'left',
    right = 'right',
  }
  
  self.intro = true
  if isTraining then self.intro = false end
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the falling apple game.\nIn this game your goal is to catch apples as they fall with a basket.")
  self.textBoxes:addText("There are two different columns that the apple can fall in. A 'left' column and a 'right' column.")
  self.textBoxes:addText("The 'basket' variable contains the position that the basket currently is in. It will be either 'left' or 'right'.")
  self.textBoxes:addText("The 'apple' variable contains the position of the currently falling apple. It will also be 'left' or 'right'.")
  self.textBoxes:addText("The code you create will be run once each time an apple is falling. You can use the move commands to change the position of the basket.")
  self.textBoxes:addText("The move left command moves the basket into the left column (if the basket is in the left column already, it will not move).")
  self.textBoxes:addText("The move right command will move the basket into the right column similar to the move left command.")
  self.textBoxes:addText("Use the if statements to check the position of the falling apple and try to move the basket to catch it.")
  self.textBoxes:addText("Try to catch all "..tostring(self.totalApples).." apples!")
  
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
  if lock < 8 then lock = 8 end
  saveManager:setValue('lock', lock)
end

function FallingAppleScene:update()
  if self.helpPressed then
    self.helpPressed = false
    return FallingAppleScene(true, self)
  end
  if self.backPressed then
    self.originalRef.running = false  
    self.originalRef.timesFallen = 0 
    self.originalRef.applesCaught = 0
    self.originalRef:resetApple()
    sandbox.basket = 'left'
    return self.originalRef
  end
  
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  elseif self.summary == true then
    if self.applesCaught == self.totalApples then
      -- Show the winning thing
      -- If finished with the game clear, go to main menu
      if self.gameClearTextBoxes:update() then
        if self.isTraining then 
          self.originalRef.running = false  
          self.originalRef.timesFallen = 0 
          self.originalRef.applesCaught = 0
          self.originalRef:resetApple()
          sandbox.basket = 'left'
          return self.originalRef 
        end
        return Trans(FallingApple2Scene)
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
        self:resetApple()
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

function FallingAppleScene:drawTopScreen()
  -- Draw the two columns
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

    
  --[[local x = 0
  local wid = self.boxWidth
  if sandbox.position == 'left' then
    x = self.leftX - (wid / 2)
  else
    x = self.rightX - (wid / 2)
  end
  
  draw:rectangle({
    x = x,
    y = self.boxY,
    width = wid,
    height = wid,
    color = Color.BLUE,
  })-]]

  -- Draw the apple
  local appleX = 0
  if sandbox.apple == 'left' then
    appleX = self.leftX
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


  -- Draw the basket
  local x = 0
  if sandbox.basket == 'left' then
    x = self.leftX
  else
    x = self.rightX
  end
  --[[draw:arc({
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
  })--]]
  draw:img({
    x = x,
    y = self.basketY,
    sx = 1.1,
    sy = 1.1,
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

function FallingAppleScene:drawBottomScreen()
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

function FallingAppleScene:resetApple()
  self.appleY = - self.appleRadius
  self.appleR = 0
  if love.math.random() < 0.5 then sandbox.apple = 'left' else sandbox.apple = 'right' end
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

