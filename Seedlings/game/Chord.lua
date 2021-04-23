Chord = Object:extend()

function Chord:new(note1, note2, note3)
  if note1 == nil then
    self.note1 = ""
  else
    self.note1 = note1
  end
  
  if note2 == nil then
    self.note2 = ""
  else
    self.note2 = note2
  end
  
  if note3 == nil then
    self.note3 = ""
  else
    self.note3 = note3
  end
end

function Chord:getSize()
  if self.note3 == "" and self.note2 == "" then 
    return 1
  elseif self.note3 == "" then
    return 2
  else 
    return 3
  end
end