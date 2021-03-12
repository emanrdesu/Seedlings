Template = Command:extend()
Template.COMMAND_NAME = 'Name that user seems'

function Template:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    position = args.position or '0',
    canHaveOptions = ''
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.paramList = ArrayList()
  local options = ArrayList()
  options:add({userString = 'Option 1', codeString = 'abc'})
  options:add({userString = 'Option 1', codeString = 'def'})
  
  self.paramList:add({userString = 'myPosition', codeString = 'position'})
  self.paramList:add({userString = 'optionTest', codeString = 'canHaveOptions', optionList = options})
end

-- What the user sees in the command list
function Template:toUserString()
  local s = "Move to "..tostring(self.params['position'])
  return s
end

-- Translate to valid lua code
function Template:toLuaStringList()  
  local list = ArrayList()
  list:add('curPosition = '..tostring(self.params.position).."; ")
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function Template:getParamList()
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function Template:inceraseIndent() return false end
-- Return true if indent decreases RIGHT BEFORE this command
function Template:decreaseIndent() return false end

function Template:getColor() return Color.LIGHT_GRAY end

function Template:canEdit() return true end