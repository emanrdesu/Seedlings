FillBowl = Command:extend()
FillBowl.COMMAND_NAME = 'Fill bowl'

function FillBowl:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
end

-- What the user sees in the command list
function FillBowl:toUserString()
  local s = "fill bowl"
  return s
end

-- Translate to valid lua code
function FillBowl:toLuaStringList()  
  local list = ArrayList()
  list:add(' fillingBowl = true ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function FillBowl:getParamList()
  return ArrayList()
end