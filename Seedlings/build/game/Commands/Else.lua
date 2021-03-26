Else = Command:extend()
Else.COMMAND_NAME = 'Else'

function Else:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function Else:toUserString()
  local s = 'else'
  return s
end

-- Translate to valid lua code
function Else:toLuaStringList()  
  local list = ArrayList()
  list:add(' else ')
  return list
end

-- Param list as shown above
function Else:getParamList()
  return self.paramList
end

function Else:increaseIndent() return true end
function Else:decreaseIndent() return true end
