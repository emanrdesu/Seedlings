SnakeScene = Scene:extend()

function SnakeScene:new()
  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(SnakeLoop)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(SnakeMoveUp)
  self.commandUI:addAvailableCommand(SnakeMoveDown)
  self.commandUI:addAvailableCommand(SnakeMoveLeft)
  self.commandUI:addAvailableCommand(SnakeMoveRight)

  self.commandUI.commandManager:setTimePerLine(0.03)
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
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Snake game intro")

  -- If summary is true, user is in the stage after all the apples fall that tells them whether they passed or failed
  self.summary = false
  self.summaryWin = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Game Success")
  
  self.gameFailTextBoxes = TextBoxList()
  self.gameFailTextBoxes:addText("Game Failed")

  local lock = saveManager:getValue('lock') or 0
  if lock < 11 then lock = 11 end
  saveManager:setValue('lock', lock)
end

function SnakeScene:update()
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  elseif self.summary == true then
    -- If in the summary
    -- Make sure to call RESET once summary is over

    if self.summaryWin then
      if self.gameClearTextBoxes:update() then
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
      
      self.timeLeft = self.timeLeft - dt;
      
      if self.timeLeft <= 0 then 
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
  
  -- Draw where the person is
  draw:circle({
    x = self.gridStartX + self.gridSquareSize * (sandbox.snakeC - 1) + (self.gridSquareSize / 2), 
    y = self.gridStartY + self.gridSquareSize * (sandbox.snakeR - 1) + (self.gridSquareSize / 2),
    radius = 8,
    color = Color.BLUE,
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
    end
  end
  
  self.gameFailTextBoxes:reset()
  
end