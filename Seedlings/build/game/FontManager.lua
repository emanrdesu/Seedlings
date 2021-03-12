FontManager = Object:extend()

function FontManager:new()
  self.fonts = {}
  self.fonts['default'] = love.graphics.newFont('Assets/Fonts/OpenSans-Regular.ttf', 16)
  self.fonts['18px'] = love.graphics.newFont('Assets/Fonts/OpenSans-Regular.ttf', 18)
  self.fonts['36px'] = love.graphics.newFont('Assets/Fonts/OpenSans-Regular.ttf', 36)
  self.fonts['18px_bold'] = love.graphics.newFont('Assets/Fonts/OpenSans-Bold.ttf', 18)
  self.fonts['18px_italic'] = love.graphics.newFont('Assets/Fonts/OpenSans-Italic.ttf', 18)
  self.fonts['consolas_12'] = love.graphics.newFont('Assets/Fonts/Consolas.ttf', 12)
  
  self.fontList = ArrayList()
  self.fontList:add('default')
  self.fontList:add('18px')
  self.fontList:add('36px')
  self.fontList:add('18px_bold')
  self.fontList:add('18px_italic')
  self.fontList:add('consolas_12')
  
  love.graphics.setFont(self.fonts['default'])
  
  self.fixIndex = 0
  self.DF = 0.0001
  self.ttf = self.DF
  
end

function FontManager:setFont(ft)
  love.graphics.setFont(self.fonts[ft])
end

function FontManager:getWidth(text)
  return love.graphics.getFont():getWidth(text)
end

function FontManager:getHeight()
  return love.graphics.getFont():getHeight()
end

function FontManager:update()
  local dt = love.timer.getDelta()
  self.ttf = self.ttf - dt
  
  if self.ttf < 0 then
    self.ttf = self.DF
    self.fixIndex = self.fixIndex + 1
    if self.fixIndex >= self.fontList:getSize() then
      self.fixIndex = 0
    end
  end
  
end

function FontManager:fix()
  love.graphics.setFont(self.fonts[self.fontList:get(self.fixIndex)])
end