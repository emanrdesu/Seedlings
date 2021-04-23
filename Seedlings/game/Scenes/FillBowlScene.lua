FillBowlScene = Object:extend()

function FillBowlScene:new(isTraining, originalRef)
  self.isTraining = isTraining
  self.originalRef = originalRef
  self.helpPressed = false
  self.backPressed = false
  
  -- Command manager stuff
  self.commandUI = CommandUI(isTraining)
  self.commandUI:addAvailableCommand(BowlIf)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(FillBowl)
  self.commandUI:setOnRun(
    function() 
      -- Reset game values if game is not running
      if not self.running then
        self:resetValues()
        self.running = true  
      end
    end
  )
  self.commandUI.commandManager:setTimePerLine(0.0001)
  if isTraining == true then
    self.commandUI:setOnBack(function() self.backPressed = true end)
  else
    self.commandUI:setOnHelp(function() self.helpPressed = true end)
  end
  
  if isTraining == true then
    self.commandUI.commandManager:addCommand(
      BowlIf({bowl = 'empty'})
    )
    self.commandUI.commandManager:addCommand(
      FillBowl()
    )
    self.commandUI.commandManager:addCommand(
      End()
    )
  end
  
  -- Scene constant variables
  self.bowlBottomWidth = 50
  self.bowlTopWidth = 70
  self.bowlHeight = 40
  self.totalBowls = 6
  self.bowlList = {'empty', 'full', 'empty', 'full', 'full', 'empty'}
    
  self.finalBowlX = (Constants.TOP_SCREEN_WIDTH / 2)
  self.finalBowlY = 200
  self.startBowlX = -100
  self.startBowlY = self.finalBowlY
  
  self.timePerBowl = 3.2
  
  self.bowlDx = 250
  self.bowlDp = 0.75
  self.bowlDy = 200
  
  self.pourDp = 0.9
  self.pourWidth = 20
  self.pourHeight = 100
  self.pourBowlCutoff = 0.6
  
  -- Scene changing variables
  self.running = false
  self.currentBowlIndex = 0
  self.currentBowlPercent = 0
  self.status = '-' -- filledFull, notFillEmpty, completed
  self.ranForBowl = false
  self.bowlTimeLeft = self.timePerBowl
  self.bowlGoingDown = false
  
  self.pourPercent = 0
  self.pourDone = false
  
  self.bowlX = self.startBowlX
  self.bowlY = self.startBowlY
  
  -- Sandbox values
  sandbox = {
    bowlStatus = 'empty',
    fillingBowl = false,
  }
  
  
  -- Textboxes down here
  self.intro = true
  if isTraining then self.intro = false end
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Now time to try and create a machine like mentioned in the previous introduction.")
  self.textBoxes:addText("Your goal is to create code that will fill a water bowl if the bowl is empty, and do nothing otherwise.")
  self.textBoxes:addText("You can use the 'If' command in your code to check for whether the bowl is empty or not.")
  self.textBoxes:addText("You also have the 'end' command to control what is inside the if statement. Be careful, the code will not work if an if statement doesn't have an end.")
  self.textBoxes:addText("The fill bowl command will fill the bowl with water. If you try to fill a non-empty bowl, it will overflow.")
  self.textBoxes:addText("After you finish making the code, hit run to watch the machine go to work. Good luck!")
  
  self.summary = false
  self.notFillEmpty = TextBoxList()
  self.notFillEmpty:addText("Oops! It looks like you didn't fill an empty bowl.") 
  
  self.filledFull = TextBoxList()
  self.filledFull:addText("Oops! It looks like you spilt water by filling an already full bowl.")
  
  self.completed = TextBoxList()
  self.completed:addText("Congratulations! Your machine worked on all of the bowls. You can now continue onto the next section.")
  
  if isTraining then 
    self.completed = TextBoxList()
    self.completed:addText("Game Complete!\nClear the game while not in help mode to move to the next section")
  end
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 6 then lock = 6 end
  saveManager:setValue('lock', lock)
end

function FillBowlScene:update()
  if self.helpPressed then
    self.helpPressed = false
    return FillBowlScene(true, self)
  end
  if self.backPressed then
    self.originalRef:resetValues()
    return self.originalRef
  end
  
  -- If in the intro
  if self.intro then
    local finished = self.textBoxes:update()
    if finished then self.intro = false end
    return self
  end
  
  -- If in the summary
  if self.summary then
    -- Go to main menu if completed, reset values if failed
    if self.status == 'completed' then
      local finished = self.completed:update()
      if finished and self.isTraining then self.originalRef:resetValues() return self.originalRef end
      if finished then return ElseIntroductionScene() end
    elseif self.status == 'filledFull' then
      local finished = self.filledFull:update()
      if finished then self:resetValues() end
    elseif self.status == 'notFillEmpty' then
      local finished = self.notFillEmpty:update()
      if finished then self:resetValues() end
    end
    return self
  end
  
  -- If not in intro or summary
  self.commandUI:update()
  local dt = love.timer.getDelta()
  
  -- If running the code
  if self.running then
    -- Update the command manager
    self.commandUI.commandManager:update()
    
    if self.bowlGoingDown then
      self.bowlY = self.bowlY + dt * self.bowlDy
      if self.bowlY - self.bowlHeight > Constants.BOTTOM_SCREEN_HEIGHT + 10 then self:nextBowl() end
    elseif self.bowlX < self.finalBowlX then
        -- If bowl is moving, move it
      self.bowlX = self.bowlX + dt * self.bowlDx
      if self.bowlX > self.finalBowlX then self.bowlX = self.finalBowlX end
    else
      -- If bowl is at the center
      
      -- If we haven't ran the user code yet, do it
      if not self.ranForBowl then
        self.commandUI.commandManager:start()
        self.ranForBowl = true
        self.bowlTimeLeft = self.timePerBowl
      else
        -- If we've started running the user's code
        self.bowlTimeLeft = self.bowlTimeLeft - dt -- Decrease time left
        
        if sandbox.fillingBowl then
          if self.pourDone then
            if sandbox.bowlStatus == 'full' then
              -- Failed
              self.summary = true
              self.status = 'filledFull'
            end
            
            -- Update filling bowl
            self.currentBowlPercent = self.currentBowlPercent + dt * self.bowlDp
            if self.currentBowlPercent > 1 then self.currentBowlPercent = 1 end
            
            if self.currentBowlPercent >= self.pourBowlCutoff then
              self.pourPercent = self.pourPercent - dt * self.pourDp
              if self.pourPercent < 0 then self.pourPercent = 0 end
            end
            
          else
            self.pourPercent = self.pourPercent + dt * self.pourDp
            if self.pourPercent > 1 then
              self.pourPercent = 1
              self.pourDone = true
            end
          end
        end
        
        -- If time is over
        if self.bowlTimeLeft < 0 or (self.bowlTimeLeft < 2 and sandbox.fillingBowl == false) then
          if self.currentBowlPercent < 1 then
            -- Failed
            self.summary = true
            self.status = 'notFillEmpty'
          elseif self.currentBowlIndex == self.totalBowls - 1 then
            -- Completed the game
            self.summary = true
            self.status = 'completed'
          else
            -- Completed the current bowl
            self.bowlGoingDown = true
          end
        end
        
      end
    end
  
  end
  
  if inputManager:isPressed('b') then return Trans(MainMenuScene) end
  
  return self
end

function FillBowlScene:drawTopScreen()
  self:drawPour()
  
  -- Draw the machine
  local mw = 120
  -- bottom rectangle
  draw:rectangle({
    x = self.finalBowlX - (mw / 2),
    y = self.finalBowlY + 1,
    width = mw,
    height = 20,
    color = Color.BLACK,
  })
  -- Side rectangle
  draw:rectangle({
    x = self.finalBowlX + mw / 2,
    y = self.finalBowlY - 100,
    width = 40,
    height = 100 + 20 + 1,
    color = Color.BLACK,  
  })

  -- faucet thingy
  local fw = 30
  draw:rectangle({
    x = self.finalBowlX - fw/2,
    y = self.finalBowlY - 100 - 15,
    width = fw,
    height = 25,
    color = Color.GRAY,
  })

  -- Top rectangle
  draw:rectangle({
    x = self.finalBowlX - (mw / 2),
    y = self.finalBowlY - 100 - 30,
    width = mw + 40,
    height = 30,
    color = Color.BLACK
  })
  
  self:drawBowl(self.bowlX, self.bowlY, self.currentBowlPercent)
  if self.intro then self.textBoxes:drawTopScreen() end
  if self.summary then
    -- Go to main menu if completed, reset values if failed
    if self.status == 'completed' then
      self.completed:drawTopScreen()
    elseif self.status == 'filledFull' then
      self.filledFull:drawTopScreen()
    elseif self.status == 'notFillEmpty' then
      self.notFillEmpty:drawTopScreen()
    end
  end
end

function FillBowlScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  if self.intro then self.textBoxes:drawBottomScreen() end
    if self.summary then
    -- Go to main menu if completed, reset values if failed
    if self.status == 'completed' then
      self.completed:drawBottomScreen()
    elseif self.status == 'filledFull' then
      self.filledFull:drawBottomScreen()
    elseif self.status == 'notFillEmpty' then
      self.notFillEmpty:drawBottomScreen()
    end
  end
end

-- (x,y) is the bottom center coordinate
function FillBowlScene:drawBowl(x, y, fillPercent)
  local widthBottom = self.bowlBottomWidth
  local widthTop = self.bowlTopWidth
  local height = self.bowlHeight
  
  local botLeft = {x - widthBottom / 2, y}
  local botRight = {x + widthBottom / 2, y}
  local topLeft = {x - widthTop / 2, y - height}
  local topRight = {x + widthTop / 2, y - height}
  
  -- Fill the water
  if fillPercent > 0 then
    local dw = 0.5 * (widthTop - widthBottom) * fillPercent
    local dh = fillPercent * height
    
    local wLeft = {x - widthBottom/2 - dw, y - dh}
    local wRight = {x + widthBottom/2 + dw, y - dh}
    
    draw:polygon({
      color = Color.LIGHT_BLUE,
      points = self:flatten(wLeft, botLeft, botRight, wRight),
      lineWidth = 1,
    })
  end
  
  -- Draw the bowl
  draw:line({
    color = Color.BLACK,
    lineWidth = 3,
    points = self:flatten(topLeft, botLeft, botRight, topRight),
  })
end

function FillBowlScene:drawPour()
  if self.pourPercent == 0 then return end
  
  local bottom = self.finalBowlY
  local top = bottom - self.pourHeight
  if self.pourDone then
    -- Going upwards
    local a = {self.finalBowlX, bottom}
    local b = {self.finalBowlX, bottom - self.pourPercent * (bottom - top)}
    draw:line({
      points = self:flatten2(a,b),
      color = Color.LIGHT_BLUE,
      lineWidth = self.pourWidth,
    })
  else
    -- Going downwards
    local a = {self.finalBowlX, top}
    local b = {self.finalBowlX, (top + self.pourPercent * (bottom - top))}
    draw:line({
      points = self:flatten2(a,b),
      color = Color.LIGHT_BLUE,
      lineWidth = self.pourWidth,
    })
  end
  
  
end

function FillBowlScene:flatten(a,b,c,d)
  return {a[1], a[2], b[1], b[2], c[1], c[2], d[1], d[2]}
end
function FillBowlScene:flatten2(a,b)
  return {a[1], a[2], b[1], b[2]}
end

function FillBowlScene:resetValues()
  self.currentBowlIndex = 0
  self.currentBowlPercent = 0
  if self.bowlList[1+self.currentBowlIndex] == 'full' then self.currentBowlPercent = 1 end
  self.status = '-'
  
  self.notFillEmpty:reset()
  self.filledFull:reset()
  self.completed:reset()
  self.summary = false
  self.running = false
  self.ranForBowl = false
  
  self.bowlX = self.startBowlX
  self.bowlY = self.startBowlY
  
  sandbox.bowlStatus = self.bowlList[1+self.currentBowlIndex]
  sandbox.fillingBowl = false
  
  self.ranForBowl = false
  self.pourPercent = 0
  self.pourDone = false
  self.bowlGoingDown = false
end

function FillBowlScene:nextBowl()
  self.currentBowlIndex = self.currentBowlIndex + 1
  self.currentBowlPercent = 0
  if self.bowlList[1+self.currentBowlIndex] == 'full' then self.currentBowlPercent = 1 end
  
  self.bowlX = self.startBowlX
  self.bowlY = self.startBowlY
  sandbox.bowlStatus = self.bowlList[1+self.currentBowlIndex]
  sandbox.fillingBowl = false
  self.ranForBowl = false
  self.pourPercent = 0
  self.pourDone = false
  self.bowlGoingDown = false
end
