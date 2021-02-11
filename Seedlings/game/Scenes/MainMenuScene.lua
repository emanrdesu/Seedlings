MainMenuScene = Scene:extend()

function MainMenuScene:new()
  self.sceneList = ArrayList()
  self.sceneList:add({name="TestScene1", ref=TestScene1(), lock = 0})
  self.sceneList:add({name="TestScene2", ref=TestScene2(), lock = 0})
  self.sceneList:add({name="TestScene3", ref=TestScene3(), lock = 0})
  self.sceneList:add({name="Title Screen", ref = TitleScene(), lock = 0})
  self.sceneList:add({name="TestScene4", ref = TestScene4(), lock = 0})
  self.sceneList:add({name="Lock 1", ref = TitleScene(), lock = 1})
  self.sceneList:add({name='VarMinigameIntro', ref = VarMinigameIntro(), lock = 0})
  self.sceneList:add({name='Command Test', ref = CTS(), lock = 0})
  
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
  
  if inputManager:isPressed('a') then
    local scene = self.sceneList:get(self.scenesPerScreen * self.currentPage + self.currentIndex)
    if scene.lock <= self.currentProgress then return scene.ref end
  end
  
  return self
end

function MainMenuScene:drawTopScreen()
  draw:print({
    text = "Select a level",
    x = 90,
    y = 100,
    color = Color.BLACK,
    font = '36px',
  })
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
  local recX = 100
  local startRecY = 50
  local height = 150
  local dy = height / self.scenesPerScreen 
  
  local startIndex = self.currentPage * self.scenesPerScreen
  for i = 0, self.scenesPerScreen - 1, 1 do
    if startIndex + i >= self.sceneList:getSize() then break end
    local section = self.sceneList:get(startIndex + i)
    if i == self.currentIndex then
      draw:circle({
        x = recX - 30,
        y = math.floor(startRecY + dy * i + 10),
        radius = 5,
        color = Color.RED
      })
    end
    if self.currentProgress >= section.lock then
      draw:print({
        text = section.name,
        x = recX,
        y = math.floor(startRecY + dy * i),
        font = 'default',
        color = Color.BLACK,
      })
    else
      draw:print({
        text = "LOCKED",
        x = recX,
        y = math.floor(startRecY + dy * i),
        font = 'default',
        color = Color.BLACK,
      })
    end
  end

end