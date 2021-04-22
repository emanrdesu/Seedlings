CodeIntroductionScene = Object:extend()

function CodeIntroductionScene:new()
  self.commandUI = CommandUI()
  self.textBoxes = TextBoxList()
  self.textBoxes:addText("Welcome to the code introduction. In the following games, you will be entering code through the bottom screen to create a program.")
  self.textBoxes:addText("The left side of the screen shows the current program. The text highlighted in blue is the current selected line.")
  self.textBoxes:addText("On the right side of the screen there are 4 buttons: ADD, EDIT, DEL, and RUN.")
  self.textBoxes:addText("The ADD button lets you select a command to add to the program. The command will be inserted after the selected line.")
  self.textBoxes:addText("Depending on the game, different commands will be available.")
  self.textBoxes:addText("The EDIT button lets you edit the values of the current selected command. After clicking edit, you can select the values on the left to change them.")
  self.textBoxes:addText("You will either be able to select from a list of options, or type in your own value.")
  self.textBoxes:addText("The DEL button will delete the currently selected command.")
  self.textBoxes:addText("The RUN button will run the code that you have entered onto the screen.")
  self.textBoxes:addText("Depending on the game, your goal will be to have your code do different things. The games will each explain their own goal.")
  self.textBoxes:addText("Now you will be introduced to the first game!")
  
  local lock = saveManager:getValue('lock') or 0
  if lock < 3 then lock = 3 end
  saveManager:setValue('lock', lock)
end

function CodeIntroductionScene:update()
  local finished = self.textBoxes:update()
  if finished then return TutorialScene() end
  return self
end

function CodeIntroductionScene:drawTopScreen()
  self.textBoxes:drawTopScreen()
end

function CodeIntroductionScene:drawBottomScreen()
  self.commandUI:drawBottomScreen()
  self.textBoxes:drawBottomScreen()
end