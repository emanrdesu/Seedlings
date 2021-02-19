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