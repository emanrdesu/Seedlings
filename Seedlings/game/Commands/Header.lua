Header = Command:extend()
Header.COMMAND_NAME = 'N/A'

function Header:new(args)
end

-- What the user sees in the command list
function Header:toUserString()
  local s = "Program: "
  return s
end

-- Translate to valid lua code
function Header:toLuaStringList()  
  local list = ArrayList()
  list:add('')
  return list
end

-- Param list as shown above
function Header:getParamList()
  return ArrayList()
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent increases AFTER this command
function Header:inceraseIndent() return false end
-- Return true if indent decreases RIGHT BEFORE this command
function Header:decreaseIndent() return false end

function Header:getColor() return Color.LIGHT_GRAY end

function Header:canEdit() return false end