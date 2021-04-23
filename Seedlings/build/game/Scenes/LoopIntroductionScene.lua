LoopIntroductionScene = Object:extend()

function LoopIntroductionScene:new()
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Now let's introduce something call an 'loop' statement. Loop statements are useful when you want to repeat the same command multiple times.")
  self.textBoxes:addText("For example, if you had a command that pushes a button, and you wanted to push the button 6 times, you could write each one out:")
  self.textBoxes:addTextAlign("push button\npush button\npush button\npush button\npush button\npush button", 'left')
  self.textBoxes:addText("Or, you can simplify the code by using a loop:")
  self.textBoxes:addTextAlign("loop 6\n    push button\nend", 'left')
  self.textBoxes:addText("Loops will repeat all the code up until the 'end' command, similar to an if statement. The number next to the loop is how many times it will repeat the segment.")
  self.textBoxes:addTextAlign("For example, if you have:\nloop 10\n    push button\n    push button\nend", 'left')
  self.textBoxes:addText("The loop will repeat both button pushes 10 times, for a total of 20 button pushes.")
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 11 then lock = 11 end
  saveManager:setValue('lock', lock)
end

function LoopIntroductionScene:update()
  local finished = self.textBoxes:update()
  if finished then return SnakeScene() end
  return self
end

function LoopIntroductionScene:drawTopScreen()
  self.textBoxes:drawTopScreen()
end

function LoopIntroductionScene:drawBottomScreen()
  self.textBoxes:drawBottomScreen()
end