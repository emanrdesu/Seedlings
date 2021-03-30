AppleCustomMoveRight = Command:extend()
AppleCustomMoveRight.COMMAND_NAME = 'Custom Move Right'

function AppleCustomMoveRight:new()
  -- Params is the set of things that the user can modify for this command
  self.params = {
      value = '1'
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
end

-- What the user sees in the command list
function AppleCustomMoveRight:toUserString()
  local s = "move right "..tostring(self.params.value)
  return s
end

-- Translate to valid lua code
function AppleCustomMoveRight:toLuaStringList()  
  local list = ArrayList()
  list:add('basket = basket + '..tostring(self.params.value)..'; ')
  list:add('if basket < 1 then basket = 1 end ')
  list:add('if basket > 100 then basket = 100 end')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function AppleCustomMoveRight:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.value, codeString = 'value'})
  return self.paramList
end