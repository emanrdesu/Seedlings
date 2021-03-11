TutorialScene = Scene:extend()

function TutorialScene:new()

  self.shapes = ArrayList()
  self.shapes:add({shape = 'square', color = Color.WHITE})
  self.shapes:add({shape = 'triangle', color = Color.WHITE})
  self.shapes:add({shape = 'circle', color = Color.WHITE})

  self.commandUI = CommandUI()
  self.commandUI:addAvailableCommand(SetShapeColor)

  self.commandUI.commandManager:setTimePerLine(0.0)
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

end

function TutorialScene:update()
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
end

function TutorialScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
end