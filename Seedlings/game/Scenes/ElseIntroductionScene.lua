ElseIntroductionScene = Object:extend()

function ElseIntroductionScene:new()
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("'If' statements can have something that comes after them, called an 'else'. Let's say that you are looking for a baseball that can be in one of two boxes.")
  self.textBoxes:addText("One of the boxes is on the left, and the other is on the right. You can shake the boxes to check whether the baseball is inside it or not.")
  self.textBoxes:addText("If you shake the left box and hear a sound, the ball is in the left box. Otherwise, you know the ball is in the right box.")
  self.textBoxes:addText("'Else' statements are used to run code if the condition in the 'if' statement turns out to be not true.")
  self.textBoxes:addText("In this example, if we hear a sound after shaking the left box, we want to open the left box. If we don't hear a sound, we want to open the right box.")
  self.textBoxes:addText("In code, instead of placing an 'end' statement at the end of the 'if', we instead place an 'else'. After this else, we put code to run if the condition was false.")
  self.textBoxes:addText("Then after this new set of code, the 'end' statement is added. The code for this example would look like the following page:")
  self.textBoxes:addTextAlign(""
    .."shake left box\n"
    .."if hear sound then\n"
    .."      open left box\n"
    .."else\n"
    .."      open right box\n"
    .."end"
    , 
    'left'
  )
  self.textBoxes:addText("The 'else' statement is not always needed, but it can be helpful for situations like this. The next game can be solved with or without it.")
end

function ElseIntroductionScene:update()
  local finished = self.textBoxes:update()
  if finished then return FallingAppleScene() end
  return self
end

function ElseIntroductionScene:drawTopScreen()
  self.textBoxes:drawTopScreen()
end

function ElseIntroductionScene:drawBottomScreen()
  self.textBoxes:drawBottomScreen()
end