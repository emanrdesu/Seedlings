SnakeLoop = Command:extend()
SnakeLoop.COMMAND_NAME = 'Loop'

function SnakeLoop:new()
  -- Params is the set of things that the user can modify for this command
  self.params = {
    times = '2'
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
  self.options = ArrayList()
  self.options:add({userString = '1', codeString = '1'})
  self.options:add({userString = '2', codeString = '2'})
  self.options:add({userString = '3', codeString = '3'})
  self.options:add({userString = '4', codeString = '4'})
  self.options:add({userString = '5', codeString = '5'})
  self.options:add({userString = '6', codeString = '6'})
  self.options:add({userString = '7', codeString = '7'})
  self.options:add({userString = '8', codeString = '8'})
  self.options:add({userString = '9', codeString = '9'})
  self.options:add({userString = '10', codeString = '10'})
  self.options:add({userString = '11', codeString = '11'})
  self.options:add({userString = '12', codeString = '12'})
  self.options:add({userString = '13', codeString = '13'})
  self.options:add({userString = '14', codeString = '14'})
  self.options:add({userString = '15', codeString = '15'})
  self.options:add({userString = '16', codeString = '16'})
  self.options:add({userString = '17', codeString = '17'})
  self.options:add({userString = '18', codeString = '18'})
  self.options:add({userString = '19', codeString = '19'})
  self.options:add({userString = '20', codeString = '20'})
end

-- What the user sees in the command list
function SnakeLoop:toUserString()
  local s = "Loop "..tostring(self.params['times'])
  return s
end

-- Translate to valid lua code
function SnakeLoop:toLuaStringList()  
  local list = ArrayList()
  list:add('for __i__ = 1, '..tostring(self.params['times'])..', 1 do ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SnakeLoop:getParamList()
  self.paramList:clear()
  self.paramList:add({userString = self.params['times'], codeString = 'times', optionList = self.options})
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function SnakeLoop:increaseIndent() return true end
-- Return true if indent decreases RIGHT BEFORE this command
function SnakeLoop:decreaseIndent() return false end

function SnakeLoop:getColor() return Color.LIGHT_GRAY end

function SnakeLoop:canEdit() return true end