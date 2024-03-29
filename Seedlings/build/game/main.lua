function love.load(arg)
  -- Import the files
  require 'FileImports'

  local START_TIME = love.timer.getTime()

  function getTime()
     return love.timer.getTime() - START_TIME
  end

  -- set random seed
  math.randomseed(os.time())
  
  -- Instantiate Sandbox environment
  sandbox = {}

  -- Instantiate fontManager object
  fontManager = FontManager()
  
  -- Instantiate gameManager object
  gameManager = GameManager()
  
  -- Instantiate inputManager object
  inputManager = InputManager()

  -- Instantiate the soundManager object
  sm = SoundManager()
  
  -- Instantiate the saveManager object
  saveManager = SaveManager()
  saveManager:loadData()
  
  -- Instantiate draw object
  draw = Draw()
  
  -- Have a variable that is whether or not the game is playing on PC
  __PLAYING_ON_PC = false
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
  if screen == "bottom" or screen == nil then
    if screen == nil then
      __PLAYING_ON_PC = true
      local sx = (Constants.TOP_SCREEN_WIDTH - Constants.BOTTOM_SCREEN_WIDTH)/2
      local sy = 20 + Constants.TOP_SCREEN_HEIGHT
      love.graphics.translate(sx, sy)
      love.graphics.setScissor(sx,sy,Constants.BOTTOM_SCREEN_WIDTH, Constants.BOTTOM_SCREEN_HEIGHT)
    end
    gameManager:drawBottomScreen()
    if screen == nil then
      love.graphics.setScissor()
    end
  end
  
  -- This is needed to avoid issues with fonts disappearing 
  fontManager:fix()
end

function love.focus(f)
  if f then
    -- Focus
    -- Say we aren't reading input anymore
    inputManager:setReadingInput(false)
  else
    -- Losing focus. Quit the game if this focus wasn't from brining up text input
    if not inputManager:isReadingInput() then love.event.quit() end
  end
end

function love.quit()
  saveManager:saveData()
  love.event.quit()
end
