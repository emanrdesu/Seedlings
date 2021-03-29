SetChordTo2 = Command:extend()

function SetChordTo2:new(var1, value1, var2, value2)
  self.var1 = var1
  self.value1 = value1
  
  self.var2 = var2
  self.value2 = value2
end

function SetChordTo2:toUserString()
  local s = tostring(self.var1).. ' = ' ..tostring(self.value1) .. 
            ', ' ..tostring(self.var2).. ' = ' ..tostring(self.value2)
            
  return s
end

function SetChordTo2:toLuaStringList()
  local list = ArrayList()
  
  list:add("SM:play('audio_"..tostring(self.value1).."'); ")
  list:add("SM:play('audio_"..tostring(self.value2).."'); ")
  list:add(Command.YIELD)
  
  return list
end