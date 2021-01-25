SetNoteTo = Command:extend()

function SetNoteTo:new(var, value)
  self.variable = var
  self.value = value
end

function SetNoteTo:toUserString()
  local s = tostring(self.variable).." = "..tostring(self.value)
  return s
end

function SetNoteTo:toLuaStringList()
  local list = ArrayList()
  --local str = "local numSources = love.audio.getActiveSourceCount() while(love.audio.getActiveSourceCount() == numSources) do love.audio.play(audio_"..tostring(self.value)..") end;"
  --list:add("love.audio.play(audio_"..tostring(self.value).."); ")
  --list:add("love.audio.play(audio_"..tostring(self.value).."); ")
  --list:add(str)
  
  list:add("SM:play('audio_"..tostring(self.value).."'); ")
  list:add(Command.YIELD)
  return list
end