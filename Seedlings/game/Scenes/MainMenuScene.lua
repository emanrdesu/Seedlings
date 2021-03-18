MainMenuScene = Scene:extend()

function MainMenuScene:new()
  self.sceneList = ArrayList()
  self.sceneList:add({name="TestScene1", ref=TestScene1, lock = 0})
  self.sceneList:add({name="TestScene2", ref=TestScene2, lock = 0})
  self.sceneList:add({name="TestScene3", ref=TestScene3, lock = 0})
  self.sceneList:add({name="Title Screen", ref = TitleScene, lock = 0})
  self.sceneList:add({name="TestScene4", ref = TestScene4, lock = 0})
  self.sceneList:add({name='VarTutBackpackScene', ref = VarTutBackpackScene, lock = 0})
  self.sceneList:add({name="Lock 1", ref = TitleScene, lock = 1})
  self.sceneList:add({name='VarMinigameIntro', ref = VarMinigameIntro, lock = 0})
  self.sceneList:add({name='VarMinigameBackpack', ref = VarMinigameBackpack, lock = 0})
  self.sceneList:add({name='MultiVarMusicIntro', ref = MultiVarMusicIntro, lock = 0})
  self.sceneList:add({name='MultiVarMelodyMaker', ref = MultiVarMelodyMaker, lock = 0})
  self.sceneList:add({name='Command Test', ref = CTS, lock = 0})
  self.sceneList:add({name='If Introduction', ref = IfIntroductionScene, lock = 0})
  self.sceneList:add({name='Fill the Bowl', ref = FillBowlScene, lock = 0})
  self.sceneList:add({name='Falling Apple', ref = FallingAppleScene, lock = 0})
  self.sceneList:add({name='Falling Apple 2', ref = FallingApple2Scene, lock = 0})
  self.sceneList:add({name='Falling Apple 3', ref = FallingApple3Scene, lock = 0})
  
  self.scenesPerScreen = 3
  self.currentPage = 0
  self.currentIndex = 0
  self.currentProgress = saveManager:getValue('lock') or 0
  self.totalPages = math.ceil(self.sceneList:getSize() / self.scenesPerScreen)
  
  local bx = 285
  local by = 210
  local br = 17
  self.helpMenu = false
  self.helpButton = Button({
    hitbox = {shape = 'circle', x = bx, y = by, r = br},
    drawNormal = function()
      draw:circle({x=bx, y=by, radius=br+3, color = Color.BLACK, mode = 'fill'})
      draw:circle({x=bx, y=by, radius=br, color = Color.SAND, mode = 'fill'})
      draw:print({text='?', color = Color.BLACK, x = bx - 4, y = by - 13, font = '18px_bold'})
    end,
    onClick = function()
      self.helpMenu = true
    end
  })

  local rx = 35
  local ry = 210
  local rr = 17
  self.resetMenu = false
  self.resetButton = Button({
    hitbox = {shape = 'circle', x = rx, y = ry, r = rr},
    drawNormal = function()
      draw:circle({x=rx, y=ry, radius=rr+3, color = Color.BLACK, mode = 'fill'})
      draw:circle({x=rx, y=ry, radius=rr, color = Color.SAND, mode = 'fill'})
      draw:print({text='R', color = Color.BLACK, x = rx - 6, y = ry - 13, font = '18px_bold'})
    end,
    onClick = function()
      self.resetMenu = true
    end
  })
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
    if scene.lock <= self.currentProgress then return scene.ref() end
  end
  
  self.helpButton:update()
  if self.helpMenu == true then return IntroductionScene() end
  self.resetButton:update()
  if self.resetMenu == true then return ClearDataScene() end
  
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
  local pageText = "Page "..(self.currentPage+1).." / "..self.totalPages
  local pageTextWidth = fontManager:getWidth(pageText)
  draw:print({
      text = pageText,
      x = (Constants.BOTTOM_SCREEN_WIDTH - pageTextWidth) / 2.0,
      y = 200,
      color = Color.BLACK,
      font = 'default',
    })
  
  -- Print current options
  local startRecY = 50
  local height = 150
  local dy = height / self.scenesPerScreen 
  
  local startIndex = self.currentPage * self.scenesPerScreen
  for i = 0, self.scenesPerScreen - 1, 1 do
    if startIndex + i >= self.sceneList:getSize() then break end
    local section = self.sceneList:get(startIndex + i)
    local text = "LOCKED"
    if self.currentProgress >= section.lock then
      text = section.name
    end
    local textWidth = fontManager:getWidth(text)
    local textHeight = fontManager:getHeight()
    local recX = (Constants.BOTTOM_SCREEN_WIDTH - textWidth) / 2.0
    local PADDING = 10
    local BORDER = 4
    if i == self.currentIndex and textWidth > 0 then
      draw:brectangle({
          x = recX - PADDING - BORDER,
          y = math.floor(startRecY + dy * i - BORDER),
          width = textWidth + 2 * PADDING + 2 * BORDER,
          height = textHeight + 5 + 2 * BORDER,
          borderWidth = BORDER,
          color = Color.WHITE,
          borderColor = Color.BLACK,
      })
    else
      draw:rectangle({
          x = recX - PADDING,
          y = math.floor(startRecY + dy * i),
          width = textWidth + 2 * PADDING,
          height = textHeight + 5,
          color = Color.WHITE,
      })
    end
    draw:print({
      text = text,
      x = recX,
      y = math.floor(startRecY + dy * i),
      font = 'default',
      color = Color.BLACK,
    })
  end

  self.helpButton:draw()
  self.resetButton:draw()
end