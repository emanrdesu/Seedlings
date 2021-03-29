VarMini = Scene:extend()

function VarMini:new()

   self.text = {
      [1] = "Luke is getting ready for school. Let's help him make decisions about some variables this morning!",

      [2] = "First, he needs to do some chores and fix some variables that have wrong values.\n\nHe remembers his mom asked him to organize his closet!",

      [3] = "Luke remembers that his mom wants his shirts to look like this:",
      [4] = "\n\nTake a look at the pattern that his mother wants for his shirts!",
      [5] = "Time to organize: change the values of the variables of each shirt to match the pattern at the top!\n\nWhen finished, press 'Start'! Press 'A' to begin.",

      [6] = "Use the D-pad to give the shirt the appropriate values to its variables.",
      [7] = function (n)
         return string.format("Whoops, that's not right,\nyou got %d shirt%s wrong.\n\n\nPress 'A' to go back\nand try again.", n, n == 1 and '' or 's')
      end,

      [8] = "Wow! Great job!\n\nThis chore is all done, and Luke's mom is sure to be thrilled with how everything looks. Thank you so much for your help!",

      [9] = "Use the D-pad and press 'A' to select a shirt.\nPress 'Start' when you think the closet is how mom wants it."
   }
   
   self.top = {
      bubble = {
         [1] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_3_1_bubble.png'},
         [2] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_3_2_bubble.png'},
         [3] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_3_3_bubble.png'},
         [4] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_4_thinking.png'},
         [5] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_5_mom.png'},
      },

      star = {
         [1] = Image{'Assets/Images/Objects/success_stars_topFitted_1.png'},
         [2] = Image{'Assets/Images/Objects/success_stars_topFitted_2.png'}
      },

      [1] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_2_boymove.png'},
      [2] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_1_textbox.png'},
      [3] = Image{'Assets/Images/Panels/variable_panels/Closet/closet_6_closet.png'}
   }

   self.bot = {
      [1] = Image{'Assets/Images/Panels/bottom/BotBG_peach_apples_gradient.png', x = 1},
      [2] = Image{'Assets/Images/Panels/bottom/BotBG_peach_apples_tutorialBox.png', x = 1},
      [3] = Image{'Assets/Images/Panels/bottom/BotBG_layout_LHeavy_green.png', x = 1}
   }

   self.a = 0
   return self
end

function VarMini:update()
   return VarMiniIntro()
end

VarMiniIntro = VarMini:extend()

function VarMiniIntro:new()
   VarMiniIntro.super.new(self)

   self.shirt = {}
   for i = 1, 3 do
      self.shirt[i] = randomShirt {
         scale = { x = 0.9, y = 0.9 },
         angled = true
      }
   end

   self.pa = PulseImage {
      path = 'Assets/Images/Objects/a_button.png',
      x = 365, y = 205,
   }

   return self
end

function VarMiniIntro:drawTopScreen()
   if self.a == 0 then
      self.top[2]:draw()
      TBox {
         x = 169, y = 65,
         color = Color.EIGENGRAU,
         align = 'center',
         width = 148,
         text = self.text[1]
      }:draw()

      self.pa:draw()
   elseif self.a == 1 then
      self.top[1]:draw()
      TBox {
         x = 170, y = 40,
         color = Color.EIGENGRAU,
         align = 'center',
         width = 146,
         text = self.text[2]
      }:draw()

      self.pa:draw()
   elseif self.a == 3 then
      self.top.bubble[5]:draw()
      TBox {
         x = 224, y = 40, width = 113,
         color = Color.EIGENGRAU, align = 'center',
         text = self.text[3],
      }:draw()

      self.pa:draw()
   elseif self.a == 4 then
      self.top.bubble[5]:draw()

      HStack {
         x = 120, y = 32,
         width = 242,
         height = 50,
         children = self.shirt
      }:draw()
      
      self.pa:draw()
   end
end

function VarMiniIntro:drawBottomScreen()
   if self.a < 3 then
      self.bot[1]:draw()
   elseif self.a < 5 then
      self.bot[2]:draw()
      TBox {
         x = 39, y = 39, width = 240,
         align = 'center',
         color = Color.EIGENGRAU,
         text = self.text[4] .. '\n\n\nPress A to continue.'
      }:draw()
   end
end

function VarMiniIntro:update()
   if self.a < 2 then
      if inputManager:isPressed('a') then
         self.a = self.a + 1
      end

      if self.a == 1 then
         if inputManager:isPressed('b') then
            self.a = self.a - 1
         end
      end
   elseif self.a == 2 then
      self.a = 3
      return TSlide {
         time = 0.7,
         parent = self,
         top = self.top.bubble,
         bot = replicate(#self.top.bubble, self.bot[1])
      }
   elseif self.a == 3 then
      if inputManager:isPressed('a') then
         self.a = self.a + 1
      end
   elseif self.a == 4 then
      if inputManager:isPressed('a') then
         return VarMiniGame(self.shirt)
      end
   end

   return self
end



VarMiniGame = VarMini:extend()

function VarMiniGame:new(shirts)
   VarMiniGame.super.new(self)
   self.shirts = {}
   self.userShirts = {}

   self.variable = {}
   self.value = {}

   self.shirtIndex = 1
   self.pickingShirt = false
   self.checkWin = false
   self.userLost = false

   self.shirtCheck = function (win, check)
      local function sameShirt(a, b)
         return a.color == b.color and a.number == b.number
      end

      local mismatch = 0
      for i = 1, #win do
         if not sameShirt(win[i], check[i]) then
            mismatch = mismatch + 1
         end
      end

      return mismatch ~= 0 and mismatch
   end

   for _,s in ipairs(shirts) do
      s.angled = false
      s.scale = { x = 0.55, y = 0.55 }
   end

   for i = 1, 3 do
      for j = 1, 3 do
         table.insert(self.shirts, shirts[j])
      end
   end

   local colorIndex = { red = 1, green = 2, blue = 3 }
   
   for i = 1, 9 do
      self.userShirts[i] = randomShirt{ angled = true }

      self.variable[i] = Lista {
         x = 41, y = 92,
         title = "Variable",
         "ShirtColor", "ShirtNumber"
      }

      self.value[i] = {
         Lista {
            index = colorIndex[self.userShirts[i].color],
            interact = true, cycle = true,
            x = 222, y = 97,
            "Red", "Green", "Blue"
         },

         Lista {
            index = self.userShirts[i].number,
            interact = true, cycle = true,
            x = 232, y = 97,
            "  1  ", "  2  ", "  3  "
         }
      }
   end

   return self
end

function VarMiniGame:drawTopScreen()
   self.top[3]:draw()

   HStack {
      x = -17,
      y = -17,
      width = 382,
      height = 55,
      children = self.shirts
   }:draw()

   HStack {
      x = 0,
      y = 46,
      width = 342,
      height = 60,
      reverse = true,
      children = self.userShirts
   }:draw()

   if self.checkWin and not self.userLost then
      self.top.star[1]:draw()
   end

   if self.a > 0 then
      (self.pickingShirt and PulseImage or Image) {
         path = 'Assets/Images/Objects/blueArrowUp.png',
         x = self.shirtIndex == 1 and 45 or 82 + 34 * (self.shirtIndex - 2), y = 140,
         scale = { x = 0.65, y = 0.65 }
      }:draw()
   end
end

function VarMiniGame:drawBottomScreen()
   if self.a == 0 then
      self.bot[2]:draw()

      TBox {
         x = 39, y = 52, width = 240,
         align = 'center',
         color = Color.EIGENGRAU,
         text = self.checkWin and (self.userLost and self.text[7](self.userLost) or self.text[8]) or self.text[5]
      }:draw()
   else 
      self.bot[self.pickingShirt and 1 or 3]:draw()

      if self.pickingShirt then
         TBox {
            x = 56, y = 80, width = 207,
            align = 'center',
            color = Color:byte(0, 153, 51),
            text = self.text[9]
         }:draw()
      else
         TBox {
            x = 30, y = 14, width = 260,
            align = 'center',
            color = Color.EIGENGRAU,
            text = self.text[6]
         }:draw()

         TBox {
            x = 0, y = 215, width = 320,
            align = 'center',
            color = Color.EIGENGRAU,
            text = "Press 'B' to go back."
         }:draw()
         
         self.variable[self.shirtIndex]:draw()

         if self.aa == 1 then
            self.value[self.shirtIndex][self.variable[self.shirtIndex].index]:draw()
         end
      end
   end
end

function VarMiniGame:update()
   if self.a == 0 then
      if inputManager:isPressed('a') then

         if self.checkWin and not self.userLost then
            return MelodyMakerIntro()
         end

         self.pickingShirt = true
         self.checkWin = false
         self.a = 1
      end
   elseif self.a == 1 then

      if inputManager:isPressed('dpleft') or inputManager:isPressed('leftshoulder') then
         self.shirtIndex = math.max(1, self.shirtIndex - 1)
      end

      if inputManager:isPressed('dpright') or inputManager:isPressed('rightshoulder') then
         self.shirtIndex = math.min(9, self.shirtIndex + 1)
      end

      if inputManager:isPressed('a') then
         self.pickingShirt = false
         self.a = 2
         self.aa = 0
         self.variable[self.shirtIndex].interact = true
      end

      if inputManager:isPressed('start') then
         self.checkWin = true
         self.userLost = self.shirtCheck(self.shirts, self.userShirts)
         self.a = 0
      end
   elseif self.a == 2 then
      if self.aa == 0 then
         if inputManager:isPressed('b') then
            self.pickingShirt = true
            self.a = 1
         end

         if inputManager:isPressed('dpleft') or inputManager:isPressed('leftshoulder') then
            self.variable[self.shirtIndex].interact = false
            self.shirtIndex = math.max(1, self.shirtIndex - 1)
            self.variable[self.shirtIndex].interact = true
         end

         if inputManager:isPressed('dpright') or inputManager:isPressed('rightshoulder') then
            self.variable[self.shirtIndex].interact = false
            self.shirtIndex = math.min(9, self.shirtIndex + 1)
            self.variable[self.shirtIndex].interact = true
         end
         
         self.variable[self.shirtIndex]:onButton()

         if inputManager:isPressed('a') then
            self.aa = 1
            self.variable[self.shirtIndex].interact = false
            self.variable[self.shirtIndex]:markIndex()
         end
      elseif self.aa == 1 then
         self.value[self.shirtIndex][self.variable[self.shirtIndex].index]:onButton()

         if inputManager:isPressed('dpleft') or inputManager:isPressed('leftshoulder') then
            self.variable[self.shirtIndex]:unmarkIndex()
            self.shirtIndex = math.max(1, self.shirtIndex - 1) --
            self.variable[self.shirtIndex]:markIndex()
         end

         if inputManager:isPressed('dpright') or inputManager:isPressed('rightshoulder') then
            self.variable[self.shirtIndex]:unmarkIndex()
            self.shirtIndex = math.min(9, self.shirtIndex + 1) --
            self.variable[self.shirtIndex]:markIndex()
         end

         if inputManager:isPressed('b') then
            self.aa = 0
            self.variable[self.shirtIndex].interact = true
            self.variable[self.shirtIndex]:unmarkIndex()
         end

         if inputManager:isPressed('a') then
            if self.variable[self.shirtIndex].index == 1 then -- if color is selected
               local cc = string.lower(self.value[self.shirtIndex][1]:current())
               self.userShirts[self.shirtIndex].color = cc
            else -- if number was selected
               local cn = string.gsub(self.value[self.shirtIndex][2]:current(), ' ', '')
               self.userShirts[self.shirtIndex].number = tonumber(cn)
            end
         end
      end
   end

   return self
end
