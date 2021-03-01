VarTut = Scene:extend()

function VarTut:new()
   self.text = {
      [1] = "Welcome to Variables!\n\nWe want to introduce you to our buddy,\nLuke, and the interesting world he lives in.\n\nHere, normal things like shirts and apples\ncan remember stuff about themselves, and\ change if you tell them to!",
      [2] = "Here, take a look at what some things in\nthis world can remember about\nthemselves..."
   }

   self.top = {
      [1] = Image{'Assets/Images/Panels/variable_panels/Tutorial/var_tutor_1.png'},
   }

   self.bot = {
      [1] = Image{'Assets/Images/Panels/bottom/BotBG_peach_apples_gradient.png'}
   }

   return self
end

function VarTut:update()
   return VarTutIntro()
end

VarTutIntro = VarTut:extend()

function VarTutIntro:new()
   VarTutIntro.super.new(self)
   self.a = 1

   self.x = 52
   self.x1 = 69
   self.x2 = 290

   self.y = 40
   self.y1 = 69
   self.y2 = 120

   self.curr = 1
   self.width = 307
   return self
end

function VarTutIntro:drawTopScreen()
   self.top[1]:draw()
   TBox {
      x = self.x,
      y = self.y,
      color = Color.EIGENGRAU,
      align = 'center',
      width = self.width,
      text = self.text[self.a]
   }:draw()
   
   if self.a == 2 then
      Image{
         path = 'Assets/Images/Objects/boy2.png',
         scale = {x = 0.45, y = 0.45},
         x = self.x1, y = self.y1
      }:draw()

      Image{
         path = 'Assets/Images/Objects/appleGreenScaled.png',
         x = self.x2, y = self.y2
      }:draw()
   end
end

function VarTutIntro:drawBottomScreen()
   self.bot[1]:draw()
   TBox {
      x = 100, y = 100, width = 100,
      text = tostring(self.x1) .. ' ' .. tostring(self.y1) .. '\n' .. tostring(self.x2) .. ' ' .. tostring(self.y2)
   }:draw()
end

function VarTutIntro:update()
   if inputManager:isPressed('a') then
      self.curr = 1
   end

   if inputManager:isPressed('b') then
      self.curr = 2
   end

   if inputManager:isPressed('dpleft') then
      if self.curr == 1 then
         self.x1 = self.x1 - 1
      else
         self.x2 = self.x2 - 1
      end
   end

   if inputManager:isPressed('dpright') then
      if self.curr == 1 then
         self.x1 = self.x1 + 1
      else
         self.x2 = self.x2 + 1
      end
   end

   if inputManager:isPressed('dpup') then
      if self.curr == 1 then
         self.y1 = self.y1 - 1
      else
         self.y2 = self.y2 - 1
      end
   end

   if inputManager:isPressed('dpdown') then
      if self.curr == 1 then
         self.y1 = self.y1 + 1
      else
         self.y2 = self.y2 + 1
      end
   end

   if inputManager:isPressed('y') then
      self.a = math.max(self.a - 1, 1)
   end

   if inputManager:isPressed('x') then
      self.a = math.min(self.a + 1, 2)
   end

   --return self.a > 2 and VarTutMiddle() or self
   return self
end
