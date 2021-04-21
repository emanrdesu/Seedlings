TutorialScene = Scene:extend()

function TutorialScene:new(isTraining, originalRef)
  self.isTraining = isTraining
  self.originalRef = originalRef
  self.helpPressed = false
  self.backPressed = false
  
  self.shapes = ArrayList()
  self.shapes:add({shape = 'square', color = Color.WHITE, wanted_color = Color.RED})
  self.shapes:add({shape = 'triangle', color = Color.WHITE, wanted_color = Color.GREEN})
  self.shapes:add({shape = 'circle', color = Color.WHITE, wanted_color = Color.BLUE})

  self.commandUI = CommandUI(isTraining)
  self.commandUI:addAvailableCommand(SetShapeColor)

  self.WAIT_TIME = 0.4

  self.commandUI.commandManager:setTimePerLine(self.WAIT_TIME)
  self.commandUI:setOnRun(
    function() 
      if not self.running then
        self.running = true
        self.initiate = true
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
      SetShapeColor({shape = 'square.color', color = 'red'})
    )
    self.commandUI.commandManager:addCommand(
      SetShapeColor({shape = 'circle.color', color = 'blue'})
    )
    self.commandUI.commandManager:addCommand(
      SetShapeColor({shape = 'triangle.color', color = 'green'})
    )
  end

  sandbox = {
    square = self.shapes:get(0),
    triangle = self.shapes:get(1),
    circle = self.shapes:get(2),
    Color = Color,
  }

  self.running = false
  self.initiate = false

  self.intro = true
  if isTraining then self.intro = false end
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the first code tutorial game.\nYour goal is to assign the shapes their appropriate colors.")
  self.textBoxes:addText("You are able to add a 'Set Color' command to the program. This command can be used to change the color of the shapes.")
  self.textBoxes:addText("Once you add the command, tap the command text on the bottom screen then click 'EDIT' in order to modify it.")
  self.textBoxes:addText("When changing the command, the first value determines which shape you are changing the color of.")
  self.textBoxes:addText("The last value determines which color the shape will be set to.")
  self.textBoxes:addText("Your goal is to make the shapes the following colors:\n"..
    "   - "..sandbox.square.shape.." = "..Color:tostring(sandbox.square.wanted_color).."\n"..
    "   - "..sandbox.circle.shape.." = "..Color:tostring(sandbox.circle.wanted_color).."\n"..
    "   - "..sandbox.triangle.shape.." = "..Color:tostring(sandbox.triangle.wanted_color)
    )
  self.textBoxes:addText("The dots under the shape tell you the desired color for that shape. Good luck!")

  self.waitTimeForSummary = 0
  self.waitForSummary = false
  self.summary = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Congratulations!\n".."You passed this level! Now time to move on to more complex games.")

  local lock = saveManager:getValue('lock') or 0
  if lock < 4 then lock = 4 end
  saveManager:setValue('lock', lock)

end

function TutorialScene:update()
  if self.helpPressed then
    self.helpPressed = false
    return TutorialScene(true, self)
  end
  if self.backPressed then
    return self.originalRef
  end
  
  if self.intro == true then
    local finished = self.textBoxes:update()
    if finished == true then self.intro = false end
  elseif self.summary == true then
    if self.waitForSummary == true and love.timer.getTime() > self.waitTimeForSummary then
      self.waitForSummary = false
    end
    if not self.waitForSummary and self.gameClearTextBoxes:update() then
      if self.isTraining then return self.originalRef end
      return IfIntroductionScene()
    end
  else
    if inputManager:isPressed('b') then return MainMenuScene() end
    self.commandUI:update()
    
    if self.initiate then
      self.commandUI.commandManager:start()
      self.initiate = false
    end
    
    if self.running then
      if not self.commandUI.commandManager.isRunning then
        self.running = false
      else
        self.commandUI.commandManager:update()
      end
    end

    local valid = true
    for i = 0, self.shapes:getSize() - 1, 1 do
      local shape = self.shapes:get(i)
      if shape.color ~= shape.wanted_color then
        valid = false
      end
    end
    valid = valid and not self.commandUI.commandManager.isRunning

    if valid then
      self.summary = true
      self.waitForSummary = true
      self.waitTimeForSummary = love.timer.getTime() + self.WAIT_TIME
    end
  end

  return self
end

function TutorialScene:drawTopScreen()
  local SCREEN_WIDTH = Constants.TOP_SCREEN_WIDTH
  local SCREEN_HEIGHT = Constants.TOP_SCREEN_HEIGHT
  local PADDING = 20
  local SIDE = math.min(math.floor((SCREEN_WIDTH - 4 * PADDING) / 3.0), SCREEN_HEIGHT)
  local LEFT_X = PADDING
  local MIDDLE_X = LEFT_X + SIDE + PADDING
  local RIGHT_X = MIDDLE_X + SIDE + PADDING
  local TOP_Y = math.floor((SCREEN_HEIGHT - SIDE) / 2.0)
  local BOTTOM_Y = math.floor((SCREEN_HEIGHT + SIDE) / 2.0)
  local DOT_RAD = 10
  
  for i = 0, self.shapes:getSize() - 1, 1 do
    local shape = self.shapes:get(i)
    if shape.shape == 'square' then
      draw:rectangle({
        x = LEFT_X,
        y = math.floor((SCREEN_HEIGHT - SIDE) / 2.0),
        width = SIDE,
        height = SIDE,
        color = shape.color,
      })
      draw:circle({
        x = LEFT_X + SIDE/2,
        y = math.floor((SCREEN_HEIGHT - SIDE) / 2.0) + SIDE + DOT_RAD + 20,
        radius = DOT_RAD,
        color = shape.wanted_color,
      })
    elseif shape.shape == 'triangle' then
      draw:polygon({
        points = {
          MIDDLE_X, BOTTOM_Y,
          MIDDLE_X + SIDE, BOTTOM_Y,
          math.floor((MIDDLE_X + MIDDLE_X + SIDE) / 2.0), TOP_Y
        },
        color = shape.color,
        mode = 'fill',
        lineWidth = 6,
      })
      draw:circle({
        x = MIDDLE_X + SIDE/2,
        y = math.floor((SCREEN_HEIGHT - SIDE) / 2.0) + SIDE + DOT_RAD + 20,
        radius = DOT_RAD,
        color = shape.wanted_color,
      })
    elseif shape.shape == 'circle' then
      draw:circle({
        mode = 'fill', 
        x = RIGHT_X + math.floor(SIDE / 2.0),
        y = math.floor(SCREEN_HEIGHT / 2.0),
        radius = math.floor(SIDE / 2.0),
        color = shape.color
      })
      draw:circle({
        x = RIGHT_X + SIDE/2,
        y = math.floor((SCREEN_HEIGHT - SIDE) / 2.0) + SIDE + DOT_RAD + 20,
        radius = DOT_RAD,
        color = shape.wanted_color,
      })
    else
      error("UNKOWN SHAPE!! "..shape.shape)
    end
  end

  if self.intro then self.textBoxes:drawTopScreen() end
  if self.summary and not self.waitForSummary then self.gameClearTextBoxes:drawTopScreen() end

end

function TutorialScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()

  if self.intro then self.textBoxes:drawBottomScreen() end
  if self.summary and not self.waitForSummary then self.gameClearTextBoxes:drawBottomScreen() end
end