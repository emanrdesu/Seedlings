CommandLister = Object:extend()

function CommandLister:new(uiRef)
  self.uiRef = uiRef
  
  self.startX = 10
  self.startY = 0
  self.width = 230
  self.height = 240
  
end

function CommandLister:update()
  
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
  
  
end