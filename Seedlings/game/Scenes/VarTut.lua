VarTut = Scene:extend()

function VarTut:new()
   self.text = {
      [1] = "Welcome to Variables!\n\nWe want to introduce you to our buddy,\nLuke, and the interesting world he lives in.\n\nHere, normal things like shirts and apples\ncan remember stuff about themselves, and\n change if you tell them to!",

      [2] = "Here, take a look at what some things in\nthis world can remember about\nthemselves...",

      [3] = "The stuff that something\nremembers about itself are\ncalled variables.\n\nIf you ask something about its\nvariables, it will tell you what it is!\nThis is called the value.",
      [4] = "This shirt doesn't have any color or a\nnumber, all its values are missing!\n\nHelp out by filling in all the missing values\nthat the variables are equal to.",

      [5] = "In order to win:\nPick the color Blue for ShirtColor\nPick the number 6 for ShirtNumber",

      [6] = "Great job!\nNow that you know how to help something with its values, lets see what Luke needs to do today!",

      [7] = "Oh no!\n Those aren't the right values for those\nvariables. Press A to try again!"
   }

   self.top = {
      [1] = Image{'Assets/Images/Panels/variable_panels/Tutorial/var_tutor_1.png'},
      [2] = Image{'Assets/Images/Panels/variable_panels/Tutorial/var_tutor_2.png'},
      [3] = Image{'Assets/Images/Panels/top/woodbackground.png'}
   }

   self.bot = {
      [1] = Image{'Assets/Images/Panels/bottom/BotBG_peach_apples_gradient.png', x = 1},
      [2] = Image{'Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png', x = 1},
      [3] = Image{'Assets/Images/Panels/bottom/BotBG_layout_LHeavy_green.png', x = 1}
   }

   return self
end

function VarTut:update()
   return VarTutIntro()
end

--- VAR TUTORIAL INTRO

VarTutIntro = VarTut:extend()

function VarTutIntro:new()
   VarTutIntro.super.new(self)
   self.a = 1
   return self
end

function VarTutIntro:drawTopScreen()
   self.top[1]:draw()
   TBox {
      x = 46, y = 40,
      color = Color.EIGENGRAU,
      align = 'center',
      width = 307,
      text = self.text[self.a]
   }:draw()
   
   TBox {
      x = 134, y = 210,
      align = 'center',
      width = 140,
      text = "Press A to continue"
   }:draw()

   if self.a == 2 then
      Image{
         path = 'Assets/Images/Objects/boy2.png',
         scale = {x = 0.5, y = 0.5},
         x = 69, y = 69 -- :^)
      }:draw()

      Image{
         path = 'Assets/Images/Objects/appleGreenScaled.png',
         x = 290, y = 120
      }:draw()
   end
end

function VarTutIntro:drawBottomScreen()
   self.bot[1]:draw()
end

function VarTutIntro:update()
   if inputManager:isPressed('a') then
      self.a = self.a + 1
   end

   if inputManager:isPressed('b') then
      self.a = math.max(self.a - 1, 1)
   end

   return self.a > 2 and VarTutMiddle() or self
end


-- VAR TUTORIAL MIDDLE

VarTutMiddle = VarTut:extend()

function VarTutMiddle:new()
   VarTutMiddle.super.new(self)

   self.text.object = {
      [1] = "The shirt remembers its color and\nnumber! Its blue and number 6.",
      [2] = "The backpack remembers its color\nand pockets! Its red with 2 pockets.",
      [3] = "The apple remembers its color and\nleaves! Its green with 1 leaf."
   }

   self.text.variable = {
      [1] = {'ShirtColor', 'ShirtNumber'},
      [2] = {'PackColor', 'PackNumber'},
      [3] = {'AppleColor', 'LeafNumber'}
   }

   self.text.value = {
      [1] = {'Blue', '6'},
      [2] = {'Red', '2'},
      [3] = {'Green', '1'}
   }

   self.color = {
      [1] = {
         inner = Color:byte(247, 244, 238),
         border = Color:byte(255, 184, 77) -- (153, 0, 0)
      },

      [2] = {
         inner = Color:byte(255, 217, 179), -- good
         border = Color:byte(204, 122, 0) -- (0.77, 0.38, 0.06)

      },

      [3] = {
         inner = Color.WHITE,
         border = Color.GRAY,
      }
   }

   self.parg = function(n)
      local foo = self.interact and self.choose == n
      return {
         width = 101, height = 93,
         color = self.color[foo and 2 or self.chosen[n] and 3 or 1].inner,
         marked = foo,
         borderWidth = 4,
         borderColor = self.color[foo and 2 or self.chosen[n] and 3 or 1].border,
         range = 1, rate = 0.3,
         axis = 'g'
      }
   end

   self.interact = false
   self.choose = 1
   self.a = 0
   self.aa = 0
   self.box = true
   self.chosen = {}
   
   self.f = function (n)
      local map = {
         [1] = 'shirt',
         [2] = 'backpack',
         [3] = 'apple'
      }

      return map[n] .. '?'
   end

   return self
end

function VarTutMiddle:drawTopScreen()
   if self.box then
      self.top[2]:draw()

      TBox {
         x = 120, y = 189, width = 160,
         color = Color.EIGENGRAU,
         align = 'center',
         text = 'Check out ' .. (self.interact and self.f(self.choose) or "each one!")
      }:draw()
   else
      self.top[3]:draw()

      PulseImage {
         path = 'Assets/Images/Objects/a_button.png',
         x = 365, y = 205,
      }:draw()
   end

   HStack {
      x = 16, y = 30,
      width = 368, height = 123,

      Hover {
         PulseRectangle(self.parg(1)),

         Image{
            path = 'Assets/Images/Objects/shirts/shirt_blue.png',
            scale = {x = 0.9, y = 0.9}
         },

         Image{
            path = 'Assets/Images/Objects/shirts/six.png',
            scale = {x = 0.9, y = 0.9}
         }
      };

      Hover {
         PulseRectangle(self.parg(2)),

         Image{
            path = 'Assets/Images/Objects/backpackScaled.png',
            scale = {x = 0.5, y = 0.5}
         }
      };

      Hover {
         PulseRectangle(self.parg(3)),
         Image{'Assets/Images/Objects/appleGreenScaled.png'}
      }
   }:draw()
end

function VarTutMiddle:drawBottomScreen()
   if self.a == 0 then
      self.bot[2]:draw()

      TBox {
         x = 39, y = 39, width = 240,
         align = 'center',
         color = Color.EIGENGRAU,
         text = self.text[3] .. '\n\nPress A to continue.'
      }:draw()
   elseif self.a == 1 then
      self.bot[1]:draw()

      TBox {
         x = 59, y = 80, width = 200,
         color = Color.EIGENGRAU,
         align = 'center',
         text = 'Use D-pad and press A to select an object.'
      }:draw()

      if self.chosen[1] and self.chosen[2] and self.chosen[3] then
         TBox {
            x = 59, y = 114, width = 200,
            color = Color:byte(0, 153, 51),
            align = 'center',
            text = 'Press Start to Continue!'
         }:draw()
      end
      
   elseif self.a == 2 then
      self.bot[3]:draw()

      TBox {
         x = 30, y = 14, width = 260,
         align = 'center',
         color = Color.EIGENGRAU,
         text = self.text.object[self.choose]
      }:draw()
      
      if self.aa == 1 then
         Lista {
            x = 41, y = 92,
            title = "Variable",
            self.text.variable[self.choose][1],
            self.text.variable[self.choose][2]
         }:draw()

         PulseImage {
            path = 'Assets/Images/Objects/blueArrow.png',
            x = 169, y = 130,
            scale = {x = 0.65, y = 0.65}
         }:draw()

         PulseImage {
            path = 'Assets/Images/Objects/blueArrow.png',
            x = 169, y = 164,
            scale = {x = 0.65, y = 0.65}
         }:draw()

         Lista {
            x = 219, y = 92, -- x = 150
            title = "Value",
            self.text.value[self.choose][1],
            self.text.value[self.choose][2]
         }:draw()
      end
   end
end

function VarTutMiddle:update()
   if self.a == 0 then
      self.interact = false
      self:g()
   elseif self.a == 1 then
      self.interact = true

      if inputManager:isPressed('dpleft') then
         self.choose = math.max(self.choose - 1, 1)
      end

      if inputManager:isPressed('dpright') then
         self.choose = math.min(self.choose + 1, 3)
      end

      if self.chosen[1] and self.chosen[2] and self.chosen[3] then
         if inputManager:isPressed('start') then
            return VarTutEnd()
         end
      end

      self:g(function () self.chosen[self.choose] = true end)
   elseif self.a == 2 then
      self.box = false

      if inputManager:isPressed('a') then
         self.aa = self.aa + 1
      end

      if self.aa == 2 then
         self.box = true
         self.a = 1
         self.aa = 0
      end
   end

   return self
end

function VarTutMiddle:g(f)
   if inputManager:isPressed('a') then
      self.a = self.a + 1
      if f then f() end
   end

   if inputManager:isPressed('b') then
      self.a = math.max(self.a - 1, 0)
   end
end

-- VAR TUTORIAL END

VarTutEnd = VarTut:extend()

function VarTutEnd:new()
   VarTutEnd.super.new(self)
   self.a = 0
   self.aa = 0

   self.variables = Lista {
      x = 41, y = 92,
      title = "Variable",
      "ShirtColor", "ShirtNumber"
   }

   self.values = {
      [1] = Lista {
         x = 222, y = 97, -- x = 150
         "Red", "Blue", "Green"
      },

      [2] = Lista {
         x = 232, y = 97, -- x = 150
         "  4  ", "  3  ", "  6  "
      }
   }

   self.scolor = {
      bg = Color.WHITE,
      fg = Color.BLACK,
      border = Color.WHITE
   }

   return self
end

function VarTutEnd:drawTopScreen()
   if self.a <= 1 then
      self.top[1]:draw()

      TBox {
         x = 46, y = 40, width = 307,
         align = 'center',
         color = Color.EIGENGRAU,
         text = self.text[self.a == 0 and 4 or 5]
      }:draw()
      
      if self.var1 and self.var2 then
         TBox {
            x = 46, y = 90, width = 307,
            align = 'center',
            color = Color:byte(0, 153, 51),
            text = 'Press Start to transform the shirt.'
         }:draw()
      end

      Image {
         path = 'Assets/Images/Objects/shirts/shirt_blank.png',
         x = 153, y = 135
      }:draw()
   end
end

function VarTutEnd:drawBottomScreen()
   if self.a == 0 then
      self.bot[1]:draw()
   end

   if self.a == 1 then
      self.bot[3]:draw()

      TBox {
         x = 30, y = 14, width = 260,
         color = Color.EIGENGRAU,
         align = 'center',
         text = "Use D-Pad and press A to select which variable to change"
      }:draw()

      self.variables:draw()

      if self.aa == 0 then
         Lista {
            x = 219, y = 92, -- x = 150
            title = "Value",
            self.var1 and self.values[1].strings[self.values[1].index] or '         ',
            self.var2 and self.values[2].strings[self.values[2].index] or '         '
         }:draw()
      end

      if self.aa == 1 then
         self.values[self.variables.index]:draw()
      end
   end
end

function VarTutEnd:update()

   if self.a == 0 then
      if inputManager:isPressed('a') then
         self.a = self.a + 1
      end

   elseif self.a == 1 then
      if self.aa == 0 then
         self.variables.interact = true
         self.variables:onButton()

         if inputManager:isPressed('a') then
            self.aa = self.aa + 1
         end

         if self.var1 and self.var2 and inputManager:isPressed('start') then
            local a1 = self.values[1].strings[self.values[1].index]
            local a2 = self.values[2].strings[self.values[2].index]
            return VarTutEndH(a1, a2)
         end
      elseif self.aa == 1 then
         self.variables.interact = false
         self.variables.colors[self.variables.index] = self.scolor
         self.values[self.variables.index].interact = true
         self.values[self.variables.index]:onButton()

         if inputManager:isPressed('b') then
            self.variables.colors[self.variables.index] = nil
            self.values[self.variables.index].interact = false
            self.aa = 0
         end

         if inputManager:isPressed('a') then
            self.variables.colors[self.variables.index] = nil
            self[self.variables.index == 1 and 'var1' or 'var2'] = true
            self.aa = 0
         end
      end
   end

   return self
end

VarTutEndH = VarTut:extend()

function VarTutEndH:new(shirtColor, shirtNumber)
   VarTutEndH.super.new(self)
   self.shirtColor = shirtColor
   self.shirtNumber = shirtNumber

   self.shirtImage = {
      Red = 'Assets/Images/Objects/shirts/shirt_red.png',
      Blue = 'Assets/Images/Objects/shirts/shirt_blue.png',
      Green = 'Assets/Images/Objects/shirts/shirt_green.png'
   }

   self.numberImage = {
      ['  3  '] = 'Assets/Images/Objects/shirts/three.png',
      ['  4  '] = 'Assets/Images/Objects/shirts/four.png',
      ['  6  '] = 'Assets/Images/Objects/shirts/six.png'
   }

   self.ti = (shirtColor == 'Blue' and shirtNumber == '  6  ') and 6 or 7
   self.vte = VarTutEnd()
   self.vte.a = 1
   return self
end

function VarTutEndH:drawTopScreen()
   self.top[1]:draw()
   
   TBox {
      x = 46, y = 40, width = 307,
      align = 'center',
      color = Color.EIGENGRAU,
      text = self.text[self.ti]
   }:draw()

   Hover {
      x = 153, y = 135,
      Image{self.shirtImage[self.shirtColor]},
      Image{self.numberImage[self.shirtNumber]}
   }:draw()
end

function VarTutEndH:drawBottomScreen()
   self.bot[1]:draw()
end

function VarTutEndH:update()
   
   if inputManager:isPressed('a') then
      return self.ti == 6 and VarTut() or self.vte
   end

   return self
end
