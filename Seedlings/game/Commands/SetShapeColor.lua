SetShapeColor = Command:extend()
SetShapeColor.COMMAND_NAME = 'SetColor'

function SetShapeColor:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {
    shape = 'square.color',
    op = '=',
    color = 'white',
  }
  
  -- paramList stores a list of params with 2 values: userString is what will appear in the UI when modifying it
  -- codeString is the name of the variable in the params table above
  -- If you want the user string to hold other info that changes with the values, create a new list and return in the getParamList function
  
  self.shapeList = ArrayList()
  self.shapeList:add({userString = 'square.color', codeString = 'square.color'})
  self.shapeList:add({userString = 'triangle.color', codeString = 'triangle.color'})
  self.shapeList:add({userString = 'circle.color', codeString = 'circle.color'})

  self.opList = ArrayList()
  self.opList:add({userString = '=', codeString = '='})

  self.colorList = ArrayList()
  self.colorList:add({userString = 'white', codeString = 'white'})
  self.colorList:add({userString = 'black', codeString = 'black'})
  self.colorList:add({userString = 'red', codeString = 'red'})
  self.colorList:add({userString = 'blue', codeString = 'blue'})
  self.colorList:add({userString = 'green', codeString = 'green'})
  
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function SetShapeColor:toUserString()
  return tostring(self.params.shape)..' = '..tostring(self.params.color)
end

-- Translate to valid lua code
function SetShapeColor:toLuaStringList()
  local list = ArrayList()
  list:add(tostring(self.params.shape)..' = '..'Color.'..tostring(self.params.color):upper())
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SetShapeColor:getParamList()
  self.paramList = ArrayList()
  self.paramList:add({userString = self.params.shape, codeString = 'shape', optionList = self.shapeList})
  self.paramList:add({userString = self.params.op, codeString = 'op', optionList = self.opList})
  self.paramList:add({userString = self.params.color, codeString = 'color', optionList = self.colorList})
  return self.paramList
end