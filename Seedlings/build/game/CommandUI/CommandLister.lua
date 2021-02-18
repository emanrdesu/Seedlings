CommandLister = Object:extend()

function CommandLister:new(uiRef)
  self.uiRef = uiRef
  
  self.startX = 10
  self.startY = 0
  self.width = 230
  self.height = 240
  
  self.offsetY = 0
  
  self.buttonHitbox = Button({
    hitbox = {shape = 'rectangle', x = self.startX, y = self.startY, width = self.width, height = self.height}
  })
  
end

function CommandLister:update()
  self.buttonHitbox:update()
  if self.buttonHitbox.is_hovered then
    local lt = inputManager:getLastTouch()
    if lt ~= nil and lt.eventType == Touch.MOVE then
      self.offsetY = self.offsetY + lt.dy
    end
  end
end

function CommandLister:drawBottomScreen()
  -- Draw border
  draw:rectangle({
    mode = 'fill',
    x = self.startX,
    y = self.startY,
    width = self.width,
    height = self.height,
    color = Color.LIGHT_GRAY
  })
  
  -- Draw commands
  draw:rectangle({
    mode = 'fill',
    x = self.startX,
    y = self.offsetY,
    width = 10,
    height = 10,
    color = Color.RED
  })
  
  
end