SnakeMoveUp = Command:extend()
SnakeMoveUp.COMMAND_NAME = 'Move up'

function SnakeMoveUp:new(args)
  -- Params is the set of things that the user can modify for this command
  self.params = {}
  self.paramList = ArrayList()
end

-- What the user sees in the command list
function SnakeMoveUp:toUserString()
  local s = "Move up"
  return s
end

-- Translate to valid lua code
function SnakeMoveUp:toLuaStringList()  
  local list = ArrayList()
  list:add(' snakeR = snakeR - 1 ')
  list:add(' if snakeR < 1 then snakeR = 1 end ')
  list:add(' if grid[snakeR][snakeC] == 1 then snakeR = snakeR + 1 end ')
  list:add(Command.YIELD)
  return list
end

-- Param list as shown above
function SnakeMoveUp:getParamList()
  return self.paramList
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function SnakeMoveUp:increaseIndent() return false end
-- Return true if indent decreases RIGHT BEFORE this command
function SnakeMoveUp:decreaseIndent() return false end

function SnakeMoveUp:getColor() return Color.LIGHT_GRAY end

function SnakeMoveUp:canEdit() return true end