MainMenuScene = Scene:extend()

function MainMenuScene:new()
  self.sceneList = ArrayList()
  self.sceneList:add({name="TestScene1", ref=TestScene1()})
  self.sceneList:add({name="TestScene2", ref=TestScene2()})
  self.sceneList:add({name="TestScene3", ref=TestScene3()})
  self.sceneList:add({name="Title Screen", ref = TitleScene()})
  self.scenesPerScreen = 3
  self.currentPage = 0
  
end

function MainMenuScene:update()
  
end

function MainMenuScene:drawTopScreen()

end

function MainMenuScene:drawBottomScreen()
  love.graphics.print("Menu! "..tostring(self.timeLeft), 50, 50)
end