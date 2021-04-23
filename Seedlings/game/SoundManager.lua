SoundManager = Object:extend()

function SoundManager:new()
  self.playStart = true
  self.path = {
     audio_A = "Assets/Audio/Piano/a.wav",
     audio_B = "Assets/Audio/Piano/b.wav",
     audio_C = "Assets/Audio/Piano/c.wav",
     audio_D = "Assets/Audio/Piano/d.wav",
     audio_E = "Assets/Audio/Piano/e_flat.wav",
     audio_F = "Assets/Audio/Piano/f.wav",
     audio_G = "Assets/Audio/Piano/g.wav"
  }

  self.audio = {}

  for k,v in pairs(self.path) do
     self.audio[k] = love.audio.newSource(v, "static")
  end


  self.path.button = {
     a = "Assets/Audio/Button/a.wav",
     b = "Assets/Audio/Button/b.wav",
     start = "Assets/Audio/Button/start.wav",
     dpleft = "Assets/Audio/Button/dpad.wav",
     dpright = "Assets/Audio/Button/dpad.wav",
     dpdown = "Assets/Audio/Button/dpad.wav",
     dpup = "Assets/Audio/Button/dpad.wav"
  }

  self.audio.button = {}

  for k,v in pairs(self.path.button) do
     self.audio.button[k] = love.audio.newSource(v, "static")
  end
end

function SoundManager:play(sourceName)
  --[[local src = nil
  if self.audio[sourceName]:isPlaying() then
    src = self.audio[sourceName]:clone()
  else
    src = self.audio[sourceName]
  end
  
  local counter = 0
  while((not src:isPlaying()) and counter < 50) do 
    src:play() 
    counter = counter + 1
  end
  --]]
  
  local src = nil
  if self.audio[sourceName]:isPlaying() then
    src = love.audio.newSource(self.path[sourceName], "static")
  else
    src = self.audio[sourceName]
  end
  
  local counter = 0
  while(counter < 500 and (not src:isPlaying())) do 
    src:play() 
    counter = counter + 1
  end
end



function SoundManager:playButton(button)
   if button == 'start' and not self.playStart then
      return
   end

   if self.audio.button[button] then
      local src
      if self.audio.button[button]:isPlaying() then
         src = love.audio.newSource(self.path.button[button], "static")
      else
         src = self.audio.button[button]
      end

      local counter = 0
      while(counter < 500 and (not src:isPlaying())) do 
         src:play() 
         counter = counter + 1
      end
   end
end
