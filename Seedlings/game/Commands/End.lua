End = Command:extend()
End.COMMAND_NAME = 'End'

function End:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = { }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function End:toUserString()
  local s = "end"
  return s
end

-- Translate to valid lua code
function End:toLuaStringList()  
  local list = ArrayList()
  list:add(' end ')
  return list
end

-- Param list as shown above
function End:getParamList()
  return self.paramList
end

function End:decreaseIndent() return true end