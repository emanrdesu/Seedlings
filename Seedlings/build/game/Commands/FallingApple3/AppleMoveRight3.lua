AppleMoveRight3 = Command:extend()
AppleMoveRight3.COMMAND_NAME = 'Move Right'

function AppleMoveRight3:new(args)
  -- Params is the set of things that the user can modify for this command
  if args == nil then args = {} end
  self.params = {
      value = args.value or '1'
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
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
  
end

-- What the user sees in the command list
function AppleMoveRight3:toUserString()
  local s = "move right "..tostring(self.params.value)
  return s
end

-- Translate to valid lua code
function AppleMoveRight3:toLuaStringList()  
  local list = ArrayList()
  list:add('basket = basket + '..tostring(self.params.value)..'; ')
  list:add('if basket < 1 then basket = 1 end ')
  list:add('if basket > 100 then basket = 100 end')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function AppleMoveRight3:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.value, codeString = 'value', optionList = self.valList})
  return self.paramList
end