AppleCondition = Command:extend()
AppleCondition.COMMAND_NAME = 'If'

function AppleCondition:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    left = 'apple',
    op = '==',
    right = 'left',
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.leftList = ArrayList()
  self.leftList:add({userString = 'apple', codeString = 'apple'})
  self.leftList:add({userString = 'basket', codeString = 'basket'})
  
  self.opList = ArrayList()
  self.opList:add({userString = '==', codeString = '=='})
  self.opList:add({userString = '!=', codeString = '~='})
  
  self.rightList = ArrayList()
  self.rightList:add({userString = 'left', codeString = 'left'})
  self.rightList:add({userString = 'right', codeString = 'right'})
  self.rightList:add({userString = 'apple', codeString = 'apple'})
  self.rightList:add({userString = 'basket', codeString = 'basket'})
  
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function AppleCondition:toUserString()
  local op = tostring(self.params.op)
  if op == '~=' then op = '!=' end
  local s = "if  "..tostring(self.params.left)..' '..tostring(op)..' '..tostring(self.params.right)
  return s
end

-- Translate to valid lua code
function AppleCondition:toLuaStringList()  
  local list = ArrayList()
  local rightSide = self.params.right
  if rightSide == 'left' then rightSide = "'left'" end
  if rightSide == 'right' then rightSide = "'right'" end
  list:add('if '..tostring(self.params.left)..' '..tostring(self.params.op)..' '..tostring(rightSide).." then ")
  return list
end

-- Param list as shown above
function AppleCondition:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.left, codeString = 'left', optionList = self.leftList})
  local us = self.params.op
  if self.params.op == '~=' then us = '!=' end
  self.paramList:add({userString = us, codeString = 'op', optionList = self.opList})
  self.paramList:add({userString = self.params.right, codeString = 'right', optionList = self.rightList})
  return self.paramList
end

function AppleCondition:increaseIndent() return true end