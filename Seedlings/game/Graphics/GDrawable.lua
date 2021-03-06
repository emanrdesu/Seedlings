
GDrawable = Object:extend()

function GDrawable:new(args)
   self.x = args and args.x or 0 
   self.y = args and args.y or 0
   self.width = args and args.width or 0 -- use getWidth() instead
   self.height = args and args.height or 0 -- use getHeight() instead
   self.scale = args and args.scale or {x = 1, y = 1}
   self.margin = args and args.margin or {x = 0, y = 0}
   self.radians = args and args.radians or 0
   self.color = args and args.color or Color(1,1,1)
   self.marked = args and args.marked or false
   self.opacity = args and args.opacity or 1 -- the alpha value in rgba
end

function GDrawable:draw()
   -- to be implemented by GDrawable children
   -- required
end

function GDrawable:onButton()
   -- to be implemented by GDrawable children
end

function GDrawable:getWidth()
   return math.floor(self.width * self.scale.x + self.margin.x * 2)
end

function GDrawable:getHeight()
   return math.floor((self.height * self.scale.y) + self.margin.y * 2)
end

function GDrawable:getDimensions()
   return self:getWidth(), self:getHeight()
end

-- Image
imageCache = {}
Image = GDrawable:extend()

function Image:new(args)
   Image.super.new(self, args)
   self.image = imageCache[args.path or args[1]]
   self.image = self.image or love.graphics.newImage(args.path or args[1])
   imageCache[args.path or args[1]] = self.image
   self.width, self.height = self.image:getDimensions()
end

function Image:draw()
   love.graphics.draw(self.image,
		      self.x, self.y,
                      self.radians,
		      self.scale.x, self.scale.y,
                      self.margin.x, self.margin.y)
end

-- PulseImage

PulseImage = Image:extend()

function PulseImage:new(args)
   PulseImage.super.new(self, args)
   self.base = args.base or 0.2
   self.range = args.range or 0.5
   self.rate = args.rate or 0.4
end

function PulseImage:draw()
   local r,g,b,a = love.graphics.getColor()
   local t = self.range * math.abs(math.sin(getTime() / self.rate)) + self.base
   love.graphics.setColor(r,g,b,t)
   PulseImage.super.draw(self)
   love.graphics.setColor(r,g,b,a)
end

-- Rectangle and PulseRectangle
Rectangle = GDrawable:extend()

function Rectangle:new(args)
   Rectangle.super.new(self, args)
   self.rx = args.rx or 0
   self.ry = args.ry or 0
   self.segments = args.segments or 0
   self.borderColor = args.borderColor or Color(1,1,1)
   self.borderWidth = args.borderWidth or 0
end

function Rectangle:draw()
   draw:brectangle(self)
end

PulseRectangle = Rectangle:extend()

function PulseRectangle:new(args)
   PulseRectangle.super.new(self, args)
   self.range = args.range or 0.4
   self.rate = args.rate or 0.5 -- closer to 0 the faster
   self.axis = args.axis or 'r' -- 'r' | 'g' | 'b'
end

function PulseRectangle:draw()
   local t, d = math.abs(math.sin(getTime() / self.rate))

   if not self.marked then
      PulseRectangle.super.draw(self)
      return
   end

   if self.axis == 'r' then
      d = math.min(self.range, 1 - self.color.r) * t
      self.color.r = self.color.r + d
      PulseRectangle.super.draw(self)
      self.color.r = self.color.r - d
   end

   if self.axis == 'g' then
      d = math.min(self.range, 1 - self.color.g) * t
      self.color.g = self.color.g + d
      PulseRectangle.super.draw(self)
      self.color.g = self.color.g - d
   end

   if self.axis == 'b' then
      d = math.min(self.range, 1 - self.color.b) * t
      self.color.b = self.color.b + d
      PulseRectangle.super.draw(self)
      self.color.b = self.color.b - d
   end
end

-- Ellipse and PulseEllipse (todo if needed)

Ellipse = GDrawable:extend()

function Ellipse:new(args)
   Ellipse.super.new(self, args)
   self.mode = args.mode or 'fill'
   self.radiusX = args.radiusX or 1
   self.radiusY = args.radiusY or 1
   self.segments = args.segments or 30
   self.lineWidth = args.lineWidth or 1
   self.borderColor = args.borderColor or Color(1,1,1)
   self.borderWidth = args.borderWidth or 0

   self.width = self.radiusX * 2
   self.height = self.radiusY * 2
end

function Ellipse:draw()
   self.x = self.x + self.radiusX
   self.y = self.y + self.radiusY
   draw:bellipse(self)
   self.x = self.x - self.radiusX
   self.y = self.y - self.radiusY
end

-- Circle and PulseCircle (todo if needed)
Circle = GDrawable:extend()

function Circle:new(args)
   Circle.super.new(self, args)
   self.mode = args.mode or 'fill'
   self.radius = args.radius or 1
   self.segments = args.segments
   self.lineWidth = args.lineWidth or 0
   self.borderColor = args.borderColor or Color(1,1,1)
   self.borderWidth = args.borderWidth or 0

   self.width = self.radius * 2
   self.height = self.radius * 2
end

function Circle:draw()
   self.x = self.x + self.radius
   self.y = self.y + self.radius
   draw:bcircle(self)
   self.x = self.x - self.radius
   self.y = self.y - self.radius
end

-- Toggle

Toggle = GDrawable:extend()

function Toggle:new(x)
   Toggle.super.new(self)
   self.show = false
   self.child = x
   self.width = x:getWidth()
   self.height = x:getHeight()
end

function Toggle:draw()
   if self.show then
      self.child:draw()
   end
end

-- TBox (wrapper for TextBox)

TBox = GDrawable:extend()

function TBox:new(args)
   TBox.super.new(self, args)
   self.box = TextBox(args)
   self.width = self.box.width
   self.height = self.box.lineList:getSize() * fontManager:getHeight(self.box.lineList[1], self.box.font)
end

function TBox:draw()
   self.box.x = self.x
   self.box.y = self.y
   self.box:draw()
end

-- EBox (enhanced TextBox)
-- allows for background

EBox = GDrawable:extend()

-- Lista

Lista = GDrawable:extend()

-- e.g. Lista{title = "Foobar", font = '36px', "Item1", "Item2", ..., "ItemN" }
function Lista:new(args)
   Lista.super.new(self, args)

   self.font = args.font or 'default'
   self.color = args.color or { bg = Color.BLACK, fg = Color.WHITE, border = Color.WHITE }
   self.selectedColor = args.selectedColor or { bg = Color.BLACK, fg = Color.WHITE, border = Color.RED }
   self.title = args.title
   self.titleColor = args.titleColor or self.color
   self.titleFont = args.titleFont or '18px_bold'
   self.borderWidth = args.borderWidth or 3

   self.strings = args.items or args
   self.colors = {}
   setmetatable(self.colors, { __index = function() return self.color end })

   self.index = 1
   self.interact = args.interact or false
   self.margin = args.margin or { x = 6, y = 6 }
   self.maxHeight = 0

   for _,v in ipairs(self.strings) do
      self.height = self.height + fontManager:getHeight(v, self.font)
      self.height = self.height + (2 * self.margin.y) + self.borderWidth

      self.maxHeight = math.max(fontManager:getHeight(v, self.font), self.maxHeight)
      self.width = math.max(fontManager:getWidth(v, self.font), self.width)
   end

   if self.title then
      self.height = self.height + fontManager:getHeight(self.title, self.titleFont)
      self.height = self.height + (2 * self.margin.y) + self.borderWidth
      self.width = math.max(self.width, fontManager:getWidth(self.title, self.titleFont))
   end

   self.height = self.height + self.borderWidth
   self.maxHeight = self.maxHeight + 2 * (self.margin.y + self.borderWidth)
   self.width = self.width + 2 * (self.margin.x + self.borderWidth)
end

function Lista:draw()

   local y = self.y

   if(self.title) then
      draw:brectangle {
         x = self.x, y = y,
         width = self.width,
         height = fontManager:getHeight(self.title, self.titleFont) + 2 * (self.margin.y + self.borderWidth) + 6,
         color = self.titleColor.bg,
         borderColor = self.titleColor.border,
         borderWidth = self.borderWidth
      }

      draw:print {
         text = self.title,
         x = self.x + math.floor((self.width - fontManager:getWidth(self.title, self.titleFont)) / 2),
         y = y + self.margin.y + self.borderWidth,
         color = self.titleColor.fg,
         font = self.titleFont
      }
      
      y = y + fontManager:getHeight(self.title, self.titleFont)
      y = y + (2 * self.margin.y) + self.borderWidth + 6
   end

   local yi
   
   for i = 1, #self.strings do

      if self.index == i then yi = y end

      draw:brectangle {
         x = self.x, y = y,
         width = self.width,
         height = self.maxHeight,
         borderColor = self.colors[i].border,
         borderWidth = self.borderWidth,
         color = self.colors[i].bg
      }
      
      draw:print {
         text = self.strings[i],
         x = self.x + math.floor((self.width - fontManager:getWidth(self.strings[i], self.font)) / 2),
         y = y + math.floor((self.maxHeight - fontManager:getHeight(self.strings[i], self.font)) / 2) - self.borderWidth,
         color = self.colors[i].fg,
         font = self.font
      }

      y = y + self.maxHeight - self.borderWidth
   end

   if self.interact and yi then
      draw:brectangle {
         x = self.x, y = yi,
         width = self.width,
         height = self.maxHeight,
         borderColor = self.selectedColor.border,
         borderWidth = self.borderWidth,
         color = self.selectedColor.bg
      }
      
      draw:print {
         text = self.strings[self.index],
         x = self.x + math.floor((self.width - fontManager:getWidth(self.strings[self.index], self.font)) / 2),
         y = yi + math.floor((self.maxHeight - fontManager:getHeight(self.strings[self.index], self.font)) / 2) - self.borderWidth,
         color = self.selectedColor.fg,
         font = self.font
      }
   end
end

function Lista:onButton()
   if inputManager:isPressed('dpup') then
      self.index = math.max(self.index - 1, 1)
   end
   
   if inputManager:isPressed('dpdown') then
      self.index = math.min(self.index + 1, #self.strings)
   end
end

-- Hover
Hover = GDrawable:extend()

-- e.g. Hover{d1, d2, ..., dn}
-- where dk is some GDrawable object
function Hover:new(args)
   Hover.super.new(self, args)
   self.drawables = args
   self.width = args[1] and args[1]:getWidth() or self.width
   self.height = args[1] and args[1]:getHeight() or self.height
end

-- Rightmost will hover above previous
function Hover:draw()
   local cx = self.x + math.floor(self:getWidth() / 2)
   local cy = self.y + math.floor(self:getHeight() / 2)

   for _,g in ipairs(self.drawables) do
      g.x = cx - math.floor(g:getWidth() / 2)
      g.y = cy - math.floor(g:getHeight() / 2)
      g:draw()
   end
end

-- Stack
-- stack UI elements horizontally or vertically, evenly spaced according to width and height
Stack = GDrawable:extend()

-- e.g. Stack{ width = ..., height = ..., orientation = ..., d1, d2, ..., dn}
-- where d_i is some GDrawable object
-- width and height are required
function Stack:new(args)
   Stack.super.new(self, args)
   self.orientation = args.orientation
   self.children = args

--   for _,g in ipairs(args) do 
--      table.insert(self.children, g)
--   end
end

function Stack:draw()
   local orie = self.orientation
   local childrenSpace = 0
   for _,g in ipairs(self.children) do
      local cs = orie == 'vertical' and g:getHeight() or g:getWidth()
      childrenSpace = childrenSpace + cs
   end

   local space = (orie == 'vertical' and self:getHeight() or self:getWidth()) - childrenSpace
   local spacer = space / (#self.children + 1)

   local z = orie == 'vertical' and self.y or self.x
   for _,g in ipairs(self.children) do
      z = z + spacer

      if orie == 'vertical' then
         g.y = z
         g.x = math.floor((self:getWidth() - g:getWidth()) / 2)
         g.x = self.x + (g.x < 0 and math.floor(self:getWidth() / 2) or g.x)
         z = z + g:getHeight()
      else
         g.x = z
         g.y = math.floor((self:getHeight() - g:getHeight()) / 2)
         g.y = self.y + (g.y < 0 and math.floor(self:getHeight() / 2) or g.y)
         z = z + g:getWidth()
      end

      g:draw()
   end
end

VStack = Stack:extend()

function VStack:new(args)
   VStack.super.new(self, args)
   self.orientation = 'vertical'
end

HStack = Stack:extend()

function HStack:new(args)
   HStack.super.new(self, args)
   self.orientation = 'horizontal'
end
