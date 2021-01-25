SaveManager = Object:extend()

function SaveManager:new()
  self.data = {}
end

function SaveManager:getValue(value)
  return self.data[value]
end

function SaveManager:setValue(name, value)
  self.data[name] = value
end

function SaveManager:clearData()
  self.data = {}
  self:saveData()
end

function SaveManager:saveData()
  local text = "$"
  for key, value in pairs(self.data) do
    text = text..key..'$'..value..'$'
  end
  print("Saving: ["..text.."]")
  local success, message = love.filesystem.write('seedlings_savedata.txt', text)
end

function SaveManager:loadData()
  local contents, size = love.filesystem.read('seedlings_savedata.txt')
  if contents == nil then 
    return 
  end
  local name = nil
  local value = nil
  for i = 1, contents:len(), 1 do
    local char = contents:sub(i,i)
    if(char == '$') then
      if name == nil then
        -- Start building variable name
        name = ""
      elseif value == nil then
        -- Start building value
        value = ""
      else
        -- Finished building, set the value
        print("Loaded "..value.." into variable "..name)
        self.data[name] = tonumber(value)
      end
    else
      -- Append char to current word we're building
      if value == nil then
        name = name..char
      else
        value = value..char
      end
    end
  end
end