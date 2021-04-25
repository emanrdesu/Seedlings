
-- Timed Picture Scene
TPic = Scene:extend()

--[[ Example use in another scene
return TPic {
   time = 5, -- in seconds (required)
   next = self, -- recommended otherwise, will be in Tpic scene forever

   -- will be draw in top screen
   top = { Image{?}, ... }

   -- will be drawn in bottom screen
   bot = { Image{?}, ... }
}
--]]

function TPic:new(args)
   self.time = args.time or 3 -- arbitrary
   self.next = args.next
   self.top = args.top or {}
   self.bot = args.bot or {}

   self.startTime = love.timer.getTime()

   return self
end

function TPic:update()
   if (love.timer.getTime() - self.startTime) > self.time then
      return self.next or TPic(self)
   end

   return self
end

function TPic:drawTopScreen()
   for _,image in ipairs(self.top) do
      image:draw()
   end
end

function TPic:drawBottomScreen()
   TBox {
      width = 50, x = 40, y = 20,
      text = tostring(love.timer.getTime() - self.startTime)
   }:draw()

   for _,image in ipairs(self.bot) do
      image:draw()
   end
end

-- TSlide - Timed Slide (composite of TPic's)

function replicate(n, x)
   local ret = {}
   for i = 1, n do
      table.insert(ret, x)
   end

   return ret
end

function TSlide(args)
   local time = args.time or 3
   local parent = args.parent
   local top = args.top or {}
   local bot = args.bot or {}

   local mbt = math.max(#top, #bot)

   local tpic = TPic {
      time = time * mbt,
      next = parent,
      top = { top[#top] },
      bot = { bot[#bot] }
   }

   for i = mbt - 1, 1, -1 do
      tpic = TPic {
         time = time * i,
         next = tpic,
         top = { top[i] },
         bot = { bot[i] }
      }
   end

   return tpic
end


function Trans(scene)
  return scene()
  --[[
   local lpic = {
      'Assets/Images/Panels/top/grassB1L1.png',
      'Assets/Images/Panels/top/grassB1L2.png',
      'Assets/Images/Panels/top/grassB1L3.png',
      'Assets/Images/Panels/top/grassB1L4.png'
   }

   local function foo(n)
      return n < 5 or math.random(100) > (n * 5)
   end

   local qux, i = {}, 0

   while foo(i) do
      table.insert(qux, Image{lpic[i % 4 + 1]})
      i = i + 1
   end

   for i = 1, 0 + math.random(2) do
      qux[#qux + 1] = qux[#qux]
   end

   return TSlide {
      parent = scene(),
      time = 0.2,
      top = qux,
      bot = replicate(#qux, Image{'Assets/Images/Panels/bottom/grassB2.png'})
   }
   --]]
end
