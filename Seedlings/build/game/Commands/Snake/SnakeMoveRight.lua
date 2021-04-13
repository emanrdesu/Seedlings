SnakeMoveRight = Command:extend()
SnakeMoveRight.COMMAND_NAME = 'Move right'

function SnakeMoveRight:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function SnakeMoveRight:toUserString()
  local s = "Move right"
  return s
end

-- Translate to valid lua code
function SnakeMoveRight:toLuaStringList()  
  local list = ArrayList()
  list:add(' snakeC = snakeC + 1 ')
  list:add(' if snakeC > gridC then snakeC = gridC end ')
  list:add(' if grid[snakeR][snakeC] == 1 then snakeC = snakeC - 1 end ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SnakeMoveRight:getParamList()
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function SnakeMoveRight:increaseIndent() return false end
-- Return  if indent decreases RIGHT BEFORE this command
function SnakeMoveRight:decreaseIndent() return false end

function SnakeMoveRight:getColor() return Color.LIGHT_GRAY end

function SnakeMoveRight:canEdit() return true end