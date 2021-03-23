TutorialScene = Scene:extend()

function TutorialScene:new()

  self.shapes = ArrayList()
  self.shapes:add({shape = 'square', color = Color.WHITE, wanted_color = Color.RED})
  self.shapes:add({shape = 'triangle', color = Color.WHITE, wanted_color = Color.GREEN})
  self.shapes:add({shape = 'circle', color = Color.WHITE, wanted_color = Color.BLUE})

  self.commandUI = CommandUI()
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

  sandbox = {
    square = self.shapes:get(0),
    triangle = self.shapes:get(1),
    circle = self.shapes:get(2),
    Color = Color,
  }

  self.running = false
  self.initiate = false

  self.intro = true
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the Tutorial Game.\nYour goal is to assign the shapes their appropriate colors.")
  self.textBoxes:addText(
    "These are the final colors:\n"..
    "\t - "..sandbox.square.shape.." = "..Color:tostring(sandbox.square.wanted_color).."\n"..
    "\t - "..sandbox.circle.shape.." = "..Color:tostring(sandbox.circle.wanted_color).."\n"..
    "\t - "..sandbox.triangle.shape.." = "..Color:tostring(sandbox.triangle.wanted_color)
  )

  self.waitTimeForSummary = 0
  self.waitForSummary = false
  self.summary = false
  self.gameClearTextBoxes = TextBoxList()
  self.gameClearTextBoxes:addText("Congratulations!\n".."You passed this level!")

end

function TutorialScene:update()
  if self.intro == true then
    local finished = self.textBoxes:update()
    if finished == true then self.intro = false end
  elseif self.summary == true then
    if self.waitForSummary == true and love.timer.getTime() > self.waitTimeForSummary then
      self.waitForSummary = false
    end
    if not self.waitForSummary and self.gameClearTextBoxes:update() then
      return FallingAppleScene()
    end
  else
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
    elseif shape.shape == 'circle' then
      draw:circle({
        mode = 'fill', 
        x = RIGHT_X + math.floor(SIDE / 2.0),
        y = math.floor(SCREEN_HEIGHT / 2.0),
        radius = math.floor(SIDE / 2.0),
        color = shape.color
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