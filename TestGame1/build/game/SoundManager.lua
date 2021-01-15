SoundManager = Object:extend()

function SoundManager:new()
  self.audio = {}
  self.path = {}
  self.audio['audio_A'] = love.audio.newSource("Assets/Audio/Piano/a.wav", "static")
  self.audio['audio_B'] = love.audio.newSource("Assets/Audio/Piano/b.wav", "static")
  self.audio['audio_C'] = love.audio.newSource("Assets/Audio/Piano/c.wav", "static")
  self.audio['audio_D'] = love.audio.newSource("Assets/Audio/Piano/d.wav", "static")
  self.audio['audio_E'] = love.audio.newSource("Assets/Audio/Piano/e_flat.wav", "static")
  self.audio['audio_F'] = love.audio.newSource("Assets/Audio/Piano/f.wav", "static")
  self.audio['audio_G'] = love.audio.newSource("Assets/Audio/Piano/g.wav", "static")
  
  self.path['audio_A'] = "Assets/Audio/Piano/a.wav"
  self.path['audio_B'] = "Assets/Audio/Piano/b.wav"
  self.path['audio_C'] = "Assets/Audio/Piano/c.wav"
  self.path['audio_D'] = "Assets/Audio/Piano/d.wav"
  self.path['audio_E'] = "Assets/Audio/Piano/e_flat.wav"
  self.path['audio_F'] = "Assets/Audio/Piano/f.wav"
  self.path['audio_G'] = "Assets/Audio/Piano/g.wav"
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