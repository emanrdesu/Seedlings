SetChordTo = Command:extend()

function SetChordTo:new(var1, value1, var2, value2, var3, value3)
  self.var1 = var1
  self.value1 = value1
  
  self.var2 = var2
  self.value2 = value2
  
  self.var3 = var3
  self.value3 = value3
end

function SetChordTo:toUserString()
  local s = tostring(self.var1).. ' = ' ..tostring(self.value1) .. 
            ', ' ..tostring(self.var2).. ' = ' ..tostring(self.value2) ..
            ', ' ..tostring(self.var3).. ' = ' ..tostring(self.value3)
            
  return s
end

function SetChordTo:toLuaStringList()
  local list = ArrayList()
  
  list:add("SM:play('audio_"..tostring(self.value1).."'); ")
  list:add("SM:play('audio_"..tostring(self.value2).."'); ")
  list:add("SM:play('audio_"..tostring(self.value3).."'); ")
  list:add(Command.YIELD)
  
  return list
end