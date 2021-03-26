IfIntroductionScene = Object:extend()

function IfIntroductionScene:new()
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Now let's introduce something call an 'if' statement. Sometimes there is code you only want to run when certain conditions are met.")
  self.textBoxes:addText("For example, let's say you are taking care of a cat.")
  self.textBoxes:addText("If the cat's food bowl is full, you do not want to put more food in it. If the cat's food bowl is empty, you want to put more food in it.")
  self.textBoxes:addText("If you were making a machine to do this, the code may look like the code on the following page:")
  self.textBoxes:addTextAlign("if food bowl is empty then\n      fill bowl\nend", 'left')
  self.textBoxes:addText("If statements have what is called a 'condition' that is either true or false. In the previous example, the condition is 'food bowl is empty'.")
  self.textBoxes:addText("If this condition is true, the code below it will run it until it sees an 'end' statement. If the condition is not true, the code will be skipped instead.")
  self.textBoxes:addText("Only the code that is between the 'if' and 'end' statement will be skipped if the condition is false.")
  self.textBoxes:addText("For example, if you attached a camera to this machine and wanted it to take a bunch of pictures of the food bowl, the code may look like:")
  self.textBoxes:addTextAlign("if food bowl is empty then\n      fill bowl\nend\ntake picture", 'left')
  self.textBoxes:addText("Even if the food bowl is full, the machine will still take the picture!")
end

function IfIntroductionScene:update()
  local finished = self.textBoxes:update()
  if finished then return FillBowlScene() end
  return self
end

function IfIntroductionScene:drawTopScreen()
  self.textBoxes:drawTopScreen()
end

function IfIntroductionScene:drawBottomScreen()
  self.textBoxes:drawBottomScreen()
end