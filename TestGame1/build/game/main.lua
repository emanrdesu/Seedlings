function love.load(arg)
  -- Import the files
  require 'FileImports'
  
  -- Instantiate Sandbox environment
  sandbox = {}
  
  -- Instantiate gameManager object
  gameManager = GameManager()
  
  -- Instantiate inputManager object
  inputManager = InputManager()
end

function love.update()
  -- Update the inputManager
  inputManager:update()
  -- Update the gameManager
	gameManager:update()
end

function love.draw(screen)
  -- Draw to the screens
  if screen == "top" or screen == nil then
    gameManager:drawTopScreen()
  end
  if screen == "bottom" then
    gameManager:drawBottomScreen()
  end
end