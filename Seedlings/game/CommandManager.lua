CommandManager = Object:extend()

function CommandManager:new()
  self.commandList = ArrayList()
  self.timePerLine = 0.5
  self.isRunning = false
  self.timeSinceLastCommand = 0
  self.codeCoroutine = nil
end

function CommandManager:update()
  -- If not running the code, exit the update function
  if not self.isRunning then return end
  
  -- Add dt to time since last command
  local dt = love.timer.getDelta()
  self.timeSinceLastCommand = self.timeSinceLastCommand + dt

  -- Resume the coroutine if delta time exceeds time per line
  if self.timeSinceLastCommand > self.timePerLine then
    coroutine.resume(self.codeCoroutine)
    self.timeSinceLastCommand = 0
  end
  
  if coroutine.status(self.codeCoroutine) == "dead" then
    self.isRunning = false
  end
  
end

function CommandManager:addCommand(command)
  self.commandList:add(command)
end

function CommandManager:insertCommand(idx, command)
  self.commandList:insert(idx, command)
end

function CommandManager:removeCommand(idx)
  self.commandList:remove(idx)
end

function CommandManager:start()
  self.isRunning = true
  self.timeSinceLastCommand = 0
  
  -- Create the coroutine from the user's code
  
  
  local codeString = ""
  for i = 0, self.commandList:getSize() - 1, 1 do
    local list = self.commandList:get(i):toLuaStringList()
    for j = 0, list:getSize() - 1, 1 do
      if list:get(j) == Command.YIELD then
        codeString = codeString.." __coroutine.yield(); "
      else
        codeString = codeString..list:get(j).." "
      end
    end
  end
  
  sandbox.__coroutine = coroutine
  local codeFunction = loadstring(codeString)
  setfenv(codeFunction, sandbox)
  self.codeCoroutine = coroutine.create(function()
      codeFunction()
    end)
  
  --[[
  local functions = ArrayList()
  for i = 0, self.commandList:getSize() - 1, 1 do
    local list = self.commandList:get(i):toLuaStringList()
    for j = 0, list:getSize() - 1, 1 do
      if list:get(j) == Command.YIELD then 
        functions:add(loadstring("coroutine.yield(); "))
      else
        local func = loadstring(list:get(j))
        setfenv(func, sandbox)
        functions:add(func)
      end
    end
  end
  
  self.codeCoroutine = coroutine.create(function()
      for i = 0, functions:getSize() - 1, 1 do
        functions:get(i)()
      end
    end)
  ]]--
  
end

function CommandManager:quit()
  self.isRunning = false
end

function CommandManager:getSize()
  return self.commandList:getSize()
end

