SnakeScene = Scene:extend()

function SnakeScene:new(isTraining, originalRef)
  self.isTraining = isTraining
  self.originalRef = originalRef
  self.helpPressed = false
  self.backPressed = false
  
  self.commandUI = CommandUI(isTraining)
  self.commandUI:addAvailableCommand(SnakeLoop)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(SnakeMoveUp)
  self.commandUI:addAvailableCommand(SnakeMoveDown)
  self.commandUI:addAvailableCommand(SnakeMoveLeft)
  self.commandUI:addAvailableCommand(SnakeMoveRight)

  self.commandUI.commandManager:setTimePerLine(0.05)
  self.commandUI:setOnRun(
    function() 
      -- Reset game values if game is not running and not in summary stage
      if not self.running and not self.summary then
        self.running = true
        self:reset()
        -- start the user's code after resetting values
        self.commandUI.commandManager:start()
      end
    end
  )
  if isTraining == true then
    self.commandUI:setOnBack(function() self.backPressed = true self.originalRef:reset() self.originalRef.running = false end)
  else
    self.commandUI:setOnHelp(function() self.helpPressed = true end)
  end
  
  if isTraining == true then
    self.commandUI.commandManager:addCommand(SnakeLoop({times='8'}))
    self.commandUI.commandManager:addCommand(SnakeMoveDown())
    self.commandUI.commandManager:addCommand(End())
    self.commandUI.commandManager:addCommand(SnakeLoop({times='8'}))
    self.commandUI.commandManager:addCommand(SnakeMoveRight())
    self.commandUI.commandManager:addCommand(SnakeMoveUp())
    self.commandUI.commandManager:addCommand(End())
    self.commandUI.commandManager:addCommand(SnakeLoop({times='7'}))
    self.commandUI.commandManager:addCommand(SnakeMoveRight())
    self.commandUI.commandManager:addCommand(End())
    self.commandUI.commandManager:addCommand(SnakeLoop({times='20'}))
    self.commandUI.commandManager:addCommand(SnakeMoveDown())
    self.commandUI.commandManager:addCommand(End())
  end
  
  self.appleImg = love.graphics.newImage('Assets/Images/Objects/apple.png')
  self.appleScale = 0.1
  
  -- Grid information
  self.gridStartX = 0
  self.gridStartY = 0
  self.gridSquareSize = 20
  self.gridR = 12
  self.gridC = 20
  self.startR = 3
  self.startC = 3
  self.grid = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  }
  -- Apple collected info
  self.appleCollected = {}
  for r = 1, self.gridR, 1 do
    self.appleCollected[r] = {}
    for c = 1, self.gridC, 1 do
      self.appleCollected[r][c] = false
    end
  end
  
  -- Moved info
  self.beenTo = {}
  for r = 1, self.gridR, 1 do
    self.beenTo[r] = {}
    for c = 1, self.gridC, 1 do
      self.beenTo[r][c] = false
    end
  end
  
  -- Timer information
  self.timeToMove = 10
  self.timeLeft = self.timeToMove
  
  -- Sandbox
  sandbox = {
    gridR = self.gridR,
    gridC = self.gridC,
    snakeR = self.startR,
    snakeC = self.startC,
    grid = self.grid,
  }
  
  self.intro = true
  if isTraining then self.intro = false end
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the final minigame of this game. In this game, your goal is to help the little blue snake extend to reach all of the apples.")
  self.textBoxes:addText("You can use the move commands to move the circle 1 space up, down, left, or right. The circle cannot move through walls.")
  self.textBoxes:addText("So if the the snake is told to move left when up against a wall on the left, it will not move.")
  self.textBoxes:addText("The move commands only move the circle 1 space, but loop commands can be used to repeat them.")
  self.textBoxes:addText("The amount of times to loop can be selected from 1 to 20.")
  self.textBoxes:addText("If the snake moves into the same space as an apple, it will collect it. You want to collect all of the apples.")
  self.textBoxes:addText("If the snake does not reach all of the apples within "..tostring(self.timeToMove).." seconds, the game will not be cleared. Good luck!")

  -- If summary is true, user is in the stage after all the apples fall that tells them whether they passed or failed
  self.summary = false
  self.summaryWin = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Congratulations! You have collected all of the apples. You have clearned the final minigame.")
  
  self.gameFailTextBoxes = TextBoxList()
  self.gameFailTextBoxes:addText("It looks like not all of the apples were collected. Try again!")

  local lock = saveManager:getValue('lock') or 0
  if lock < 12 then lock = 12 end
  saveManager:setValue('lock', lock)
end

function SnakeScene:update()
  if self.helpPressed then
    self.helpPressed = false
    return SnakeScene(true, self)
  end
  if self.backPressed then
    return self.originalRef
  end
  
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  elseif self.summary == true then
    -- If in the summary
    -- Make sure to call RESET once summary is over

    if self.summaryWin then
      if self.gameClearTextBoxes:update() then
        if self.isTraining then 
          self.originalRef:reset() 
          self.originalRef.running = false 
          return self.originalRef 
        end
        return MainMenuScene()
      end
    else
      if self.gameFailTextBoxes:update() then
        self:reset()
      end
    end
    

  else
    if inputManager:isPressed('b') then return MainMenuScene() end
    
    -- Update UI
    self.commandUI:update()
    
    -- If running, process the stuff
    local dt = love.timer.getDelta()
    if self.running then
      
      self.beenTo[sandbox.snakeR][sandbox.snakeC] = true
      self.timeLeft = self.timeLeft - dt;
      
      local preCheck = true
      for r = 1, self.gridR, 1 do
        for c = 1, self.gridC, 1 do
          if self.grid[r][c] == 3 and self.appleCollected[r][c] == false then preCheck = false end
        end
      end
      
      if self.timeLeft <= 0 or preCheck then 
        self.timeLeft = 0
        self.running = false
        -- Game is over. Setup the summary
        self.summary = true
        local collectedAll = true
        for r = 1, self.gridR, 1 do
          for c = 1, self.gridC, 1 do
            if self.grid[r][c] == 3 and self.appleCollected[r][c] == false then collectedAll = false end
          end
        end
        self.summaryWin = collectedAll
      else
        -- Update and continue
        
        self.commandUI.commandManager:update()
        if self.grid[sandbox.snakeR][sandbox.snakeC] == 3 then
          self.appleCollected[sandbox.snakeR][sandbox.snakeC] = true
        end
      end
      
    end
  
  end
    
  return self
end

function SnakeScene:drawTopScreen()
  -- Draw the grid
  for r = 1, self.gridR, 1 do
    for c = 1, self.gridC, 1 do
      local color = Color.SAND
      if self.grid[r][c] == 1 then color = Color.BLACK end
      
      local toAddR = 1
      local toAddC = 1
      if r == self.gridR then toAddR = 0 end
      if c == self.gridC then toAddC = 0 end
      
      draw:brectangle({
        x = self.gridStartX + self.gridSquareSize * (c-1),
        y = self.gridStartY + self.gridSquareSize * (r-1),
        width = self.gridSquareSize + toAddC,
        height = self.gridSquareSize + toAddR,
        color = color,
        borderWidth = 1,
        borderColor = Color.GRAY,
      })
    
      -- Draw apple if needed
      if self.grid[r][c] == 3 and self.appleCollected[r][c] == false then
          draw:img({
            img = self.appleImg,
            x = self.gridStartX + self.gridSquareSize * (c-1) + (self.gridSquareSize/2),
            y = self.gridStartY + self.gridSquareSize * (r-1) + (self.gridSquareSize/2),
            sx = self.appleScale,
            sy = self.appleScale,
            center = true,
          })
      end
    end
  end
  
  
  -- Draw where the snake has been
  for r = 1, self.gridR, 1 do
    for c = 1, self.gridC, 1 do
      if self.beenTo[r][c] == true then
        local cx = self.gridStartX + self.gridSquareSize * (c - 1) + (self.gridSquareSize / 2)
        local cy = self.gridStartY + self.gridSquareSize * (r - 1) + (self.gridSquareSize / 2)
        
        draw:circle({
          x = cx,
          y = cy,
          radius = 5,
          color = Color.BLUE,
        })
      end
    end
  end
  
  -- Draw where the person is
  local centerX = self.gridStartX + self.gridSquareSize * (sandbox.snakeC - 1) + (self.gridSquareSize / 2)
  local centerY = self.gridStartY + self.gridSquareSize * (sandbox.snakeR - 1) + (self.gridSquareSize / 2)
  draw:circle({
    x = centerX,
    y = centerY,
    radius = 8,
    color = Color.BLUE,
  })
  draw:rectangle({
    x = centerX - 4,
    y = centerY - 5,
    width = 2,
    height = 6,
    color = Color.WHITE,
  })
  draw:rectangle({
    x = centerX + 4 - 2,
    y = centerY - 5,
    width = 2,
    height = 6,
    color = Color.WHITE,
  })

  -- Draw timer
  draw:print({
      x = 150, 
      y = 0, 
      text = 'Time left: '..tostring(math.ceil(self.timeLeft)),
      color = Color.WHITE,
      font = 'default',
  })

  if self.intro == true then self.textBoxes:drawTopScreen() end
  if self.summary == true then
    if self.summaryWin then
      self.gameClearTextBoxes:drawTopScreen()
    else
      self.gameFailTextBoxes:drawTopScreen()
    end
  end
end

function SnakeScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  if self.intro == true then self.textBoxes:drawBottomScreen() end
  if self.summary == true then
    if self.summaryWin then
      self.gameClearTextBoxes:drawBottomScreen()
    else
      self.gameFailTextBoxes:drawBottomScreen()
    end
  end
end

function SnakeScene:reset()
  -- Reset summary vals
  self.summary = false
  self.summaryWin = false
  
  -- Reset sandbox values
  sandbox.snakeR = self.startR
  sandbox.snakeC = self.startC
  
  -- Reset timer
  self.timeLeft = self.timeToMove
  
  -- Reset apple positions
  for r = 1, self.gridR, 1 do
    for c = 1, self.gridC, 1 do
      self.appleCollected[r][c] = false
      self.beenTo[r][c] = false
    end
  end
  
  self.gameFailTextBoxes:reset()
  
end