SnakeMoveLeft = Command:extend()
SnakeMoveLeft.COMMAND_NAME = 'Move left'

function SnakeMoveLeft:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function SnakeMoveLeft:toUserString()
  local s = "Move left"
  return s
end

-- Translate to valid lua code
function SnakeMoveLeft:toLuaStringList()  
  local list = ArrayList()
  list:add(' snakeC = snakeC - 1 ')
  list:add(' if snakeC < 1 then snakeC = 1 end ')
  list:add(' if grid[snakeR][snakeC] == 1 then snakeC = snakeC + 1 end ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SnakeMoveLeft:getParamList()
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function SnakeMoveLeft:increaseIndent() return false end
-- Return  if indent decreases RIGHT BEFORE this command
function SnakeMoveLeft:decreaseIndent() return false end

function SnakeMoveLeft:getColor() return Color.LIGHT_GRAY end

function SnakeMoveLeft:canEdit() return true end