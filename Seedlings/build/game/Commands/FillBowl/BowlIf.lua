BowlIf = Command:extend()
BowlIf.COMMAND_NAME = 'If bowl is'

function BowlIf:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    bowl = 'full'
  }
end

-- What the user sees in the command list
function BowlIf:toUserString()
  local s = "if bowl is "..tostring(self.params.bowl).." then "
  return s
end

-- Translate to valid lua code
function BowlIf:toLuaStringList()  
  local list = ArrayList()
  list:add('if bowlStatus == "'..tostring(self.params.bowl)..'" then ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function BowlIf:getParamList()
  self.paramList = ArrayList()
  local options = ArrayList()
  options:add({userString = 'empty', codeString = 'empty'})
  options:add({userString = 'full', codeString = 'full'})
  
  self.paramList:add({userString = self.params.bowl, codeString = 'bowl', optionList = options})
  
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function BowlIf:increaseIndent() return true end
-- Return true if indent decreases RIGHT BEFORE this command
function BowlIf:decreaseIndent() return false end