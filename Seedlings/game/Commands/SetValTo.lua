SetValTo = Command:extend()

function SetValTo:new(var, value)
  self.variable = var
  self.value = value
end

function SetValTo:toUserString()
  local s = "Set "..tostring(self.variable).." to "..tostring(self.value)
  return s
end

function SetValTo:toLuaStringList()
  -- local s = "__globalScene."..tostring(self.variable).." = "..tostring(self.value).."; coroutine.yield(); "
  -- local s = tostring(self.variable).." = "..tostring(self.value).."; coroutine.yield(); "
  -- return s
  
  local list = ArrayList()
  list:add(tostring(self.variable).." = "..tostring(self.value).."; ")
  list:add(Command.YIELD)
  return list
end