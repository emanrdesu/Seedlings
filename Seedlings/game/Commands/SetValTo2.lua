SetValTo2 = Command:extend()
SetValTo2.COMMAND_NAME = 'Set variable'

function SetValTo2:new(var, value)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    variable = var,
    value = value,
  }
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the
  -- get paramList function like so
  self.paramList = ArrayList()
  self.paramList:add({userString = 'variable', codeString = 'variable'})
  self.paramList:add({userString = 'value', codeString = 'value'})
end

function SetValTo2:toUserString()
  local s = "Set "..tostring(self.params['variable']).." to "..tostring(self.params.value)
  return s
end

function SetValTo2:toLuaStringList()
  -- local s = "__globalScene."..tostring(self.variable).." = "..tostring(self.value).."; coroutine.yield(); "
  -- local s = tostring(self.variable).." = "..tostring(self.value).."; coroutine.yield(); "
  -- return s
  
  local list = ArrayList()
  list:add(tostring(self.params.variable).." = "..tostring(self.params.value).."; ")
  list:add(Command.YIELD)
  return list
end

function SetValTo2:getParamList()
  local paramList = ArrayList()
  paramList:add({userString = 'variable'..': '..tostring(self.params.variable), codeString = 'variable'})
  paramList:add({userString = 'value'..': '..tostring(self.params.value), codeString = 'value'})
  return paramList
end