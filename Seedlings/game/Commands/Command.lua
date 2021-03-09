Command = Object:extend()
Command.YIELD = "yield"

function Command:toUserString()
  return ""
end

function Command:toLuaStringList()
  return ArrayList()
end

function Command:getParamList()
  return ArrayList()
end

function Command:setParameter(codeString, value)
  self.params[codeString] = value
end

function Command:getParameter(codeString)
  return self.params[codeString]
end

-- Example for below: end will decrease. else will both increase and decrease
-- Return true if indent decreases RIGHT BEFORE this command
function Command:decreaseIndent()
  return false
end

-- Return true if indent increases AFTER this command
function Command:increaseIndent()
  return false
end