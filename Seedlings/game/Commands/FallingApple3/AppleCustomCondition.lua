AppleCustomCondition = Command:extend()
AppleCustomCondition.COMMAND_NAME = 'Custom If'

function AppleCustomCondition:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    left = 'apple',
    op = '==',
    right = 'basket',
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.optionList = ArrayList()
  self.optionList:add({userString = '==', codeString = '=='})
  self.optionList:add({userString = '<', codeString = '<'})
  self.optionList:add({userString = '>', codeString = '>'})
  self.optionList:add({userString = '<=', codeString = '<='})
  self.optionList:add({userString = '>=', codeString = '>='})
  self.optionList:add({userString = '!=', codeString = '~='})

  self.paramList = ArrayList()
end

-- What the user sees in the command list
function AppleCustomCondition:toUserString()
  local op = tostring(self.params.op)
  if op == '~=' then op = '!=' end
  local s = "if  "..tostring(self.params.left)..' '..tostring(self.params.op)..' '..tostring(self.params.right)
  return s
end

-- Translate to valid lua code
function AppleCustomCondition:toLuaStringList()  
  local list = ArrayList()
  list:add('if '..tostring(self.params.left)..' '..tostring(self.params.op)..' '..tostring(self.params.right).." then ")
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function AppleCustomCondition:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.left, codeString = 'left'})
  local us = self.params.op
  if self.params.op == '~=' then us = '!=' end
  self.paramList:add({userString = us, codeString = 'op', optionList = self.optionList})
  self.paramList:add({userString = self.params.right, codeString = 'right'})
  return self.paramList
end

function AppleCustomCondition:increaseIndent() return true end