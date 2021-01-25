Command = Object:extend()
Command.YIELD = "yield"

function Command:toUserString()
  return ""
end

function Command:toLuaStringList()
  return ArrayList()
end