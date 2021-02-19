Template = Command:extend()
Template.COMMAND_NAME = 'Name that user seems'

function Template:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    position = args.position or '0'
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
  self.paramList:add({userString = 'myPosition', codeString = 'position'})
end

-- What the user sees in the command list
function Template:toUserString()
  local s = "Move to "..tostring(self.params['position'])
  return s
end

-- Translate to valid lua code
function SetValTo2:toLuaStringList()  
  local list = ArrayList()
  list:add('curPosition = '..tostring(self.params.position).."; ")
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SetValTo2:getParamList()
  return paramList
end