FillBowlScene = Object:extend()

function FillBowlScene:new()
  -- Command manager stuff
  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(BowlIf)
  self.commandUI:addAvailableCommand(End)
  self.commandUI:addAvailableCommand(FillBowl)
  self.commandUI:setOnRun(
    function() 
      -- Reset game values if game is not running
      if not self.running then
        self.running = true  
        self:resetValues()
      end
    end
  )
  self.commandUI.commandManager:setTimePerLine(0.001)
  
  
  -- Scene constant variables
  self.bowlBottomWidth = 50
  self.bowlTopWidth = 70
  self.bowlHeight = 40
  self.totalBowls = 6
  self.bowlList = {'full', 'empty', 'empty', 'full', 'full', 'empty'}
    
  self.finalBowlX = (Constants.TOP_SCREEN_WIDTH / 2)
  self.finalBowlY = 200
  self.startBowlX = -100
  self.startBowlY = self.finalBowlY
  
  self.bowlDx = 250
  
  -- Scene changing variables
  self.running = false
  self.currentBowlIndex = 0
  self.currentBowlPercent = 0
  self.status = '-' -- filledFull, notFillEmpty, completed
  self.ranForBowl = false
  
  self.bowlX = -100
  self.bowlY = self.startBowlY
  
  -- Sandbox values
  sandbox = {
    bowlStatus = 'empty',
    fillingBowl = false,
  }
  
  
  -- Textboxes down here
  self.intro = true
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
  
end

function FillBowlScene:update()
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
      if finished then return MainMenuScene() end
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
  
    if self.bowlX < self.finalBowlX then
      self.bowlX = self.bowlX + dt * self.bowlDx
      if self.bowlX > self.finalBowlX then self.bowlX = self.finalBowlX end
    else
      
    end
  
  end
  
  if inputManager:isPressed('b') then return MainMenuScene() end
  
  return self
end

function FillBowlScene:drawTopScreen()
  self:drawBowl(self.bowlX, self.bowlY, self.currentBowlPercent)
  if self.intro then self.textBoxes:drawTopScreen() end
end

function FillBowlScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  if self.intro then self.textBoxes:drawBottomScreen() end
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

function FillBowlScene:flatten(a,b,c,d)
  return {a[1], a[2], b[1], b[2], c[1], c[2], d[1], d[2]}
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
  
  sandbox = {
    bowlStatus = 'empty',
    fillingBowl = false,
  }
end