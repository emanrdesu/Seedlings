FallingAppleScene = Scene:extend()

function FallingAppleScene:new()
  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(AppleMoveLeft)
  self.commandUI:addAvailableCommand(AppleMoveRight)
  self.commandUI:addAvailableCommand(Condition2)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(Else)
  self.commandUI.commandManager:setTimePerLine(0.2)
  self.commandUI:setOnRun(
    function() self.running = true  self.timesFallen = 0 end
  )
  
  -- Apple and timer info
  self.leftX = 100
  self.rightX = 250
  self.appleY = 0
  self.appleVel = 150
  self.timer = 10
  self.running = false
  self.appleRadius = 25
  self.timesFallen = 0
  
  self.boxWidth = 50
  self.boxY = Constants.TOP_SCREEN_HEIGHT - self.boxWidth
  
  -- Info for when to run users code
  self.hasRun = false
  self.yToRunAt = 70
  
  -- Get the apple position (make it random)
  love.math.setRandomSeed(love.timer.getTime())
  self.startPosition = 'left'
  if love.math.random() >= 0.5 then self.startPosition = 'right' end
  
  -- Create sandbox environment
  -- Stores the position of the person and apple
  sandbox = {
    position = 'left',
    apple = self.startPosition,
  }
  
  self.intro = true
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the falling apple game.\nIn this game your goal is to catch apples as they fall with a basket.")
  self.textBoxes:addText("There are two different columns that the apple can fall in. A 'left' column and a 'right' column.")
  self.textBoxes:addText("The 'basket' variable contains the position that the basket currently is in. It will be either 'left' or 'right'.")
  self.textBoxes:addText("The 'apple' variable contains the position of the currently falling apple. It will also be 'left' or 'right'.")
  self.textBoxes:addText("The code you create will be run once each time an apple is falling. You can use the move commands to change the position of the basket.")
  self.textBoxes:addText("The move left command moves the basket into the left column (if the basket is in the left column already, it will not move).")
  self.textBoxes:addText("The move right command will move the basket into the right column similar to the move left command.")
  self.textBoxes:addText("Use the if statements to check the position of the falling apple and try to move the basket to catch it.")
end

function FallingAppleScene:update()
  if self.intro == true then
    -- If reading the text, only update that
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
  else
    -- Update UI
    self.commandUI:update()
    
    -- If running, process the stuff
    local dt = love.timer.getDelta()
    if self.running then
      -- Update command manager
      self.commandUI.commandManager:update()
      
      -- Have the apple fall
      self.appleY = self.appleY + self.appleVel * dt
    
      -- If past the threshhold, run user code
      if self.hasRun == false and self.appleY >= self.yToRunAt then
        self.commandUI.commandManager:start()
        self.hasRun = true
      end
      
      -- If the apple hits the user, just return a new scene
      if self.appleY + self.appleRadius >= self.boxY + 10 and sandbox.apple == sandbox.position then
        return FallingAppleScene()
      end
      
      -- If the apple is done falling, put it back on top and reset the hasRun val
      if self.appleY > Constants.TOP_SCREEN_HEIGHT + self.appleRadius then
        self.appleY = - self.appleRadius
        if love.math.random() < 0.5 then sandbox.apple = 'left' else sandbox.apple = 'right' end
        self.hasRun = false
        self.timesFallen = self.timesFallen + 1
        if self.timesFallen > 5 then self.running = false end
      end
      
    end
  end
    
  return self
end

function FallingAppleScene:drawTopScreen()
  -- Draw the boy/whatever is dodging the apple
  local x = 0
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
  })

  -- Draw the apple
  x = 0
  if sandbox.apple == 'left' then
    x = self.leftX
  else
    x = self.rightX
  end
  draw:circle({
    mode = 'fill',
    x = x,
    y = self.appleY,
    radius = self.appleRadius,
    color = Color.RED,
  })
  
  if self.intro == true then self.textBoxes:drawTopScreen() end
end

function FallingAppleScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  if self.intro == true then self.textBoxes:drawBottomScreen() end
end