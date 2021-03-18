TextBox = Object:extend()

--[[function TextBox:new(xx, yy, ww, font, align, spacing, text, color) 
  self.x = xx
  self.y = yy
  self.width = ww
  self.spacing = spacing or 0
  self.font = font or 'default'
  self.text = text or ''
  self.align = align or 'left'
  self.lineList = nil
  self.color = color or Color(1,1,1)
end--]]

function TextBox:new(args)
  self.x = args.x or 0
  self.y = args.y or 0
  self.width = args.width or 0
  self.spacing = args.spacing or 0
  self.font = args.font or 'default'
  self.text = args.text or ''
  self.align = args.align or 'left'
  self.lineList = nil
  self.color = args.color or Color(1,1,1)
end

function TextBox:setText(text)
  self.text = text
end

function TextBox:setSpacing(spacing)
  self.spacing = spacing
end

function TextBox:setFont(font)
  self.font = font
end

function TextBox:setAlign(align)
  self.align = align
end

function TextBox:initialize()
  -- Set the font
  fontManager:setFont(self.font)
  
  -- List of all the words (includes '\n')
  local wordList = ArrayList()
  -- Current word
  local curWord = ""
  -- Loop through the characters
  local prevChar = ''
  for i = 1, self.text:len(), 1 do
    -- Get the current character
    local curChar = self.text:sub(i,i)
    if curChar == '\n' then
      -- Add cur word and \n to the list
      wordList:add(curWord)
      wordList:add(curChar)
      curWord = ""
    elseif curChar == ' ' and prevChar ~= ' ' then
      wordList:add(curWord)
      curWord = ""
    else
      curWord = curWord..curChar
    end
    prevChar = curChar
  end
  if curWord:len() > 0 then
    wordList:add(curWord)
    curWord = ""
  end
  
  -- Get the strings for each line
  self.lineList = ArrayList()
  local curLine = ""
  for i = 0, wordList:getSize() - 1, 1 do
    local curWord = wordList:get(i)
    if curWord == '\n' then
      -- Create new line
      self.lineList:add(curLine)
      curLine = ""
    else
      local wordAdded = curLine..' '..curWord
      if curLine:len() == 0 then
        -- Just add the word even if it overflows if it's a single word
        curLine = curWord -- set to cur word so we don't have the space
      else
        -- Check if adding the word extends past the width given
        if fontManager:getWidth(wordAdded) > self.width then
          -- Start new line
          self.lineList:add(curLine)
          curLine = curWord
        else
          -- Add the word
          curLine = wordAdded
        end
      end
    end
  end
  if curLine:len() > 0 then
    self.lineList:add(curLine)
    curLine = ""
  end
end

function TextBox:draw()
  if self.lineList == nil then
    self:initialize()
  end
  
  fontManager:setFont(self.font)
  local fontHeight = fontManager:getHeight()
  
  for i = 0, self.lineList:getSize() - 1, 1 do
    fontManager:setFont(self.font)
    local xx = 0
    local yy = self.y + (fontHeight + self.spacing) * i
    if self.align == 'left' then 
      xx = self.x
      yy = self.y + (fontHeight + self.spacing) * i
    elseif self.align == 'right' then
      local textLength = fontManager:getWidth(self.lineList:get(i))
      local start = self.x + self.width - textLength
      xx = start
      yy = self.y + (fontHeight + self.spacing) * i
    elseif self.align == 'center' then
      local textLength = fontManager:getWidth(self.lineList:get(i))
      local start = math.floor(0.5 + self.x + (self.width - textLength) / 2.0)
      xx = start
    end
    --love.graphics.print(self.lineList:get(i), xx, yy)
    draw:print({
      text = self.lineList:get(i),
      x = xx,
      y = yy,
      font = self.font,
      color = self.color
    })
  end
end