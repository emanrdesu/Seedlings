MainMenuScene = Scene:extend()

function MainMenuScene:new()
  self.sceneList = ArrayList()
  self.sceneList:add({name="TestScene1", ref=TestScene1(), lock = 0})
  self.sceneList:add({name="TestScene2", ref=TestScene2(), lock = 0})
  self.sceneList:add({name="TestScene3", ref=TestScene3(), lock = 0})
  self.sceneList:add({name="Title Screen", ref = TitleScene(), lock = 0})
  self.scenesPerScreen = 3
  self.currentPage = 0
  self.currentIndex = 0
  self.currentProgress = saveManager:getValue('lock') or 0
  self.totalPages = math.ceil(self.sceneList:getSize() / self.scenesPerScreen)
end

function MainMenuScene:update()
  if inputManager:isPressed('dpup') then
    self.currentIndex = math.max(0, self.currentIndex - 1)
  end
  if inputManager:isPressed('dpdown') then
    local scenesOnThisPage = math.min(self.scenesPerScreen, self.sceneList:getSize() - self.scenesPerScreen * self.currentPage)
    self.currentIndex = math.min(self.currentIndex + 1, scenesOnThisPage - 1)
  end
  
  if inputManager:isPressed('dpleft') and self.currentPage > 0 then
    self.currentPage = self.currentPage - 1
    self.currentIndex = 0
  end
  
  if inputManager:isPressed('dpright') and self.currentPage < self.totalPages - 1 then
    self.currentPage = self.currentPage + 1
    self.currentIndex = 0
  end
  
  return self
end

function MainMenuScene:drawTopScreen()
  
end

function MainMenuScene:drawBottomScreen()
  -- Print page number at the bottom
  draw:print({
      text = "Page "..(self.currentPage+1).." / "..self.totalPages, 
      x = 130,
      y = 200,
      color = Color.BLACK,
      font = 'default',
    })
  
  -- Print current options
  

end