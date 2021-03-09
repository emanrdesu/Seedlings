AppleMoveRight2 = Command:extend()
AppleMoveRight2.COMMAND_NAME = 'Move Right'

function AppleMoveRight2:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function AppleMoveRight2:toUserString()
  local s = "move right"
  return s
end

-- Translate to valid lua code
function AppleMoveRight2:toLuaStringList()  
  local list = ArrayList()
  list:add('if basket == "left" then basket = "center" else basket = "right" end; ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function AppleMoveRight2:getParamList()
  return self.paramList
end