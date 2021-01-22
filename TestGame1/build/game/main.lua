function love.load(arg)
  -- Import the files
  require 'FileImports'
  
  -- Instantiate Sandbox environment
  sandbox = {}
  
  -- Instantiate gameManager object
  gameManager = GameManager()
  
  -- Instantiate inputManager object
  inputManager = InputManager()
  
  -- Instantiate fontManager object
  fontManager = FontManager()
  
  -- Instantiate the soundManager object
  sm = SoundManager()
  
  -- Instantiate the saveManager object
  saveManager = SaveManager()
  saveManager:loadData()
end

function love.update()  
  -- Update the inputManager
  inputManager:update()
  -- Update the gameManager
	gameManager:update()
  -- Update the fontManager
  fontManager:update()
end

function love.draw(screen)
  -- Reset font
  fontManager:setFont('default')
  
  -- Draw to the screens
  if screen == "top" or screen == nil then
    gameManager:drawTopScreen()
  end
  if screen == "bottom" then
    gameManager:drawBottomScreen()
  end
  
  -- This is needed to avoid issues with fonts disappearing 
  fontManager:fix()
end

function love.quit()
  saveManager:saveData()
  love.event.quit()
end