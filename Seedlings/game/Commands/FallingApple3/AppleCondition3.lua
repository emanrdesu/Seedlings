AppleCondition3 = Command:extend()
AppleCondition3.COMMAND_NAME = 'If'

function AppleCondition3:new(args)
  -- Params is the set of things that the user can modify for this command
  if args == nil then args = {} end
  self.params = {
    left = args.left or 'apple',
    mathOp = args.mathOp or '+',
    value = args.value or '10',
    compOp = args.compOp or '<=',
    right = args.right or 'basket',
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.leftList = ArrayList()
  self.leftList:add({userString = 'apple', codeString = 'apple'})
  self.leftList:add({userString = 'basket', codeString = 'basket'})
  
  self.mathOpList = ArrayList()
  self.mathOpList:add({userString = '+', codeString = '+'})
  self.mathOpList:add({userString = '-', codeString = '-'})
  
  self.valList = ArrayList()
  self.valList:add({userString = '0', codeString = '0'})
  self.valList:add({userString = '1', codeString = '1'})
  self.valList:add({userString = '5', codeString = '5'})
  self.valList:add({userString = '10', codeString = '10'})
  self.valList:add({userString = '20', codeString = '20'})
  self.valList:add({userString = '30', codeString = '30'})
  self.valList:add({userString = '40', codeString = '40'})
  self.valList:add({userString = '50', codeString = '50'})
  self.valList:add({userString = '60', codeString = '60'})
  self.valList:add({userString = '70', codeString = '70'})
  self.valList:add({userString = '80', codeString = '80'})
  self.valList:add({userString = '90', codeString = '90'})

  self.opList = ArrayList()
  self.opList:add({userString = '==', codeString = '=='})
  self.opList:add({userString = '<', codeString = '<'})
  self.opList:add({userString = '>', codeString = '>'})
  self.opList:add({userString = '<=', codeString = '<='})
  self.opList:add({userString = '>=', codeString = '>='})
  self.opList:add({userString = '!=', codeString = '~='})
  
  self.rightList = ArrayList()
  self.rightList:add({userString = 'apple', codeString = 'apple'})
  self.rightList:add({userString = 'basket', codeString = 'basket'})
  
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function AppleCondition3:toUserString()
  local op = tostring(self.params.compOp)
  if op == '~=' then op = '!=' end
  local s = "if  "..tostring(self.params.left)..' '..tostring(self.params.mathOp)..' '..tostring(self.params.value)..' '..tostring(op)..' '..tostring(self.params.right)
  return s
end

-- Translate to valid lua code
function AppleCondition3:toLuaStringList()  
  local list = ArrayList()
  
  local s = "if  "..tostring(self.params.left)..' '..tostring(self.params.mathOp)..' '..tostring(self.params.value)..' '..tostring(self.params.compOp)..' '..tostring(self.params.right)
  
  list:add(s.." then ")
  return list
end

-- Param list as shown above
function AppleCondition3:getParamList()
  self.paramList = ArrayList()
  
  self.paramList:add({userString = self.params.left, codeString = 'left', optionList = self.leftList})
  
  self.paramList:add({userString = self.params.mathOp, codeString = 'mathOp', optionList = self.mathOpList})
  
  self.paramList:add({userString = self.params.value, codeString = 'value', optionList = self.valList})
  
  local us = self.params.compOp
  if self.params.compOp == '~=' then us = '!=' end
  self.paramList:add({userString = us, codeString = 'compOp', optionList = self.opList})
  
  self.paramList:add({userString = self.params.right, codeString = 'right', optionList = self.rightList})
  
  return self.paramList
end

function AppleCondition3:increaseIndent() return true end