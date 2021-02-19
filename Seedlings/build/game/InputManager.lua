InputManager = Object:extend()

-- Callable functions for rest of code
-- *** Select button is technically 'back'

function InputManager:isDown(button)
  if button == 'select' then button = 'back' end
  if self.isHeldDownMap[button] == true then 
    return true 
  else 
    return false 
  end
end

function InputManager:isPressed(button)
  if button == 'select' then button = 'back' end
  if self.isPressedMap[button] == true then
    return true
  else
    return false
  end
end

function InputManager:isReleased(button)
  if button == 'select' then button = 'back' end
  if self.isReleasedMap[button] == true then
    return true
  else
    return false
  end
end

function InputManager:hasTouch()
  return self.lastTouch ~= nil
end

function InputManager:getWhereTouchStarted()
  if self.lastTouch == nil then return nil end
  return self.touchOrigin
end

function InputManager:getLastTouch()
  return self.lastTouch
end

function InputManager:isReadingInput()
  return self.readingTextInput
end

function InputManager:setReadingInput(b)
  self.readingTextInput = b
end

-- Start reading in text input
function InputManager:setTextInput(hint)
  self:setReadingInput(true)
  if __PLAYING_ON_PC then
    love.keyboard.setTextInput(true)
  else
    love.keyboard.setTextInput({isPassword=false, hint=(hint or '')})
  end
end

-- Disable the text input
function InputManager:disableTextInput()
  self:setReadingInput(false)
  if __PLAYING_ON_PC then
    love.keyboard.setTextInput(false)
  end
end

-- Set a receiver for the text input. Currently only used for editing commands
function InputManager:setReceiver(command, paramName, editorRef)
  self.command = command
  self.paramName = paramName
  self.editorRef = editorRef
end


-- Constructor and backend stuff down here

function InputManager:new()
  self.pressQueue = Queue()
  self.releaseQueue = Queue()
  self.touchQueue = Queue()
  
  self.isHeldDownMap = {}
  self.isPressedMap = {}
  self.isReleasedMap = {}

  self.lastTouch = nil
  self.touchOrigin = nil
  self.hasPress = false
  
  self.command = nil
  self.paramName = nil
  self.editorRef = nil
  
  self.readingTextInput = false
  self.pcString = ''
  
  self.keyMap = {}
  self.keyMap['up'] = 'dpup'
  self.keyMap['left'] = 'dpleft'
  self.keyMap['down'] = 'dpdown'
  self.keyMap['right'] = 'dpright'
  self.keyMap['f'] = 'start'
  self.keyMap['r'] = 'back'
  self.keyMap['w'] = 'x'
  self.keyMap['a'] = 'y'
  self.keyMap['s'] = 'b'
  self.keyMap['d'] = 'a'
  
  self.mdx = (Constants.TOP_SCREEN_WIDTH - Constants.BOTTOM_SCREEN_WIDTH)/2
  self.mdy = 20 + Constants.TOP_SCREEN_HEIGHT
end

function InputManager:update()
  -- Clear everything that is pressed or released
  self.isPressedMap = {}
  self.isReleasedMap = {}
  self.touchMap = {}
  self.touchPress = nil
  self.touchRelease = nil
  self.touchMove = nil
  self.lastTouch = nil
  
  -- Clear the press queue
  while not self.pressQueue:isEmpty() do
    local button = self.pressQueue:poll()
    self.isPressedMap[button] = true
    self.isHeldDownMap[button] = true
  end
  
  -- Clear the release queue
  while not self.releaseQueue:isEmpty() do
    local button = self.releaseQueue:poll()
    self.isReleasedMap[button] = true
    self.isHeldDownMap[button] = false
  end
  
  while not self.touchQueue:isEmpty() do
    local touch = self.touchQueue:poll()
    self.lastTouch = touch
    
    if touch.eventType == Touch.PRESS then
      self.touchOrigin = touch
      self.hasPress = true
    end
    if touch.eventType == Touch.RELEASE then
      self.hasPress = false
    end
  end
end


-- Functions for adding to the Queues

function InputManager:addPress(button)
  self.pressQueue:add(button)
end

function InputManager:addRelease(button)
  self.releaseQueue:add(button)
end

function InputManager:addTouch(touch)
  self.touchQueue:add(touch)
end

-- Love functions down here

function love.gamepadpressed( joystick, button )
  inputManager:addPress(button)
end

function love.gamepadreleased( joystick, button )
  inputManager:addRelease(button)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
  inputManager:addTouch(Touch(id,x,y,dx,dy,pressure,Touch.PRESS))
end

function love.touchreleased( id, x, y, dx, dy, pressure )
  inputManager:addTouch(Touch(id,x,y,dx,dy,pressure,Touch.RELEASE))
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  local lt = inputManager:getLastTouch()
  if lt ~= nil then
    dx = x - lt.x
    dy = y - lt.y
  end
  inputManager:addTouch(Touch(id,x,y,dx,dy,pressure,Touch.MOVE))
end

function love.keypressed(key)
  -- If hitting enter, process the string that was entered
  if key == 'return' and __PLAYING_ON_PC then 
    if inputManager.command ~= nil and inputManager.pcString ~= '' then
      inputManager.command:setParameter(inputManager.paramName, inputManager.pcString)
      inputManager.editorRef:refresh()
      inputManager.pcString = ''
    end
    inputManager:disableTextInput() 
  end
  -- If hitting backspace, delete the last character from the string
  if key == 'backspace' and __PLAYING_ON_PC then
    -- substring
    if string.len(inputManager.pcString) > 0 then
      inputManager.pcString = string.sub(inputManager.pcString, 1, string.len(inputManager.pcString) - 1)
    end
  end
  
  if inputManager.keyMap[key] == nil then return end
  inputManager:addPress(inputManager.keyMap[key])
end

function love.keyreleased(key)
  if inputManager.keyMap[key] == nil then return end
  inputManager:addRelease(inputManager.keyMap[key])
end

function love.mousepressed(x, y, button, istouch, presses)
  inputManager:addTouch(Touch(0,x - inputManager.mdx,y - inputManager.mdy,0,0,1,Touch.PRESS))
end

function love.mousereleased(x, y, button, istouch, presses)
  inputManager:addTouch(Touch(0,x - inputManager.mdx,y - inputManager.mdy,0,0,1,Touch.RELEASE))
end

function love.mousemoved(x, y, dx, dy, istouch)
  if not inputManager.hasPress then return end
  inputManager:addTouch(Touch(0,x - inputManager.mdx,y - inputManager.mdy,dx,dy,1,Touch.MOVE))
end


function love.textinput(text)
  -- If playing on PC, then append the character to the current string
  if __PLAYING_ON_PC then
    if inputManager:isReadingInput() then
      inputManager.pcString = inputManager.pcString..text
    end
    return
  end
  
  -- If not playing on pc, process the whole string
  if inputManager.command ~= nil and text ~= nil and text ~= '' then
    -- Set the parameter for the command and refresh the editor
    inputManager.command:setParameter(inputManager.paramName, text)
    inputManager.editorRef:refresh()
  end
end

function love.textedited()
  
end