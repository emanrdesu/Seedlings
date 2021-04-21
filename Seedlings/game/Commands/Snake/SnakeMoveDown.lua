SnakeMoveDown = Command:extend()
SnakeMoveDown.COMMAND_NAME = 'Move down'

function SnakeMoveDown:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function SnakeMoveDown:toUserString()
  local s = "Move down"
  return s
end

-- Translate to valid lua code
function SnakeMoveDown:toLuaStringList()  
  local list = ArrayList()
  list:add(' snakeR = snakeR + 1 ')
  list:add(' if snakeR > gridR then snakeR = gridR end ')
  list:add(' if grid[snakeR][snakeC] == 1 then snakeR = snakeR - 1 end ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SnakeMoveDown:getParamList()
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function SnakeMoveDown:increaseIndent() return false end
-- Return  if indent decreases RIGHT BEFORE this command
function SnakeMoveDown:decreaseIndent() return false end

function SnakeMoveDown:getColor() return Color.LIGHT_GRAY end

function SnakeMoveDown:canEdit() return true end