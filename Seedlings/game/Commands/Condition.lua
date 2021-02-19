Condition = Command:extend()
Condition.COMMAND_NAME = 'If'

function Condition:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    conditional = 'true'
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
  self.paramList:add({userString = 'condition', codeString = 'conditional'})
end

-- What the user sees in the command list
function Condition:toUserString()
  local s = "if  "..self.params.conditional
  return s
end

-- Translate to valid lua code
function Condition:toLuaStringList()  
  local list = ArrayList()
  list:add('if '..tostring(self.params.conditional).." then ")
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function Condition:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.conditional, codeString = 'conditional'})
  return self.paramList
end