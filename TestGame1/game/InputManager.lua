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

function InputManager:hasTouchPress()
  return self.touchPress ~= nil
end

function InputManager:hasTouchRelease()
  return self.touchRelease ~= nil
end

function InputManager:hasTouchMove()
  return self.touchMove ~= nil
end

function InputManager:isTouchDown()
  return self.lastTouch ~= nil
end

function InputManager:getTouchPress()
  return self.touchPress
end

function InputManager:getTouchMove()
  return self.touchMove
end

function InputManager:getTouchRelease()
  return self.touchRelease
end

function InputManager:getLastTouch()
  return self.lastTouch
end


-- Constructor and backend stuff down here

function InputManager:new()
  self.pressQueue = Queue()
  self.releaseQueue = Queue()
  self.touchPressQueue = Queue()
  self.touchReleaseQueue = Queue()
  self.touchMoveQueue = Queue()
  
  self.isHeldDownMap = {}
  self.isPressedMap = {}
  self.isReleasedMap = {}
  
  self.touchPress = nil
  self.touchRelease = nil
  self.touchMove = nil
  self.lastTouch = nil
  
end

function InputManager:update()
  -- Clear everything that is pressed or released
  self.isPressedMap = {}
  self.isReleasedMap = {}
  self.touchMap = {}
  self.touchPress = nil
  self.touchRelease = nil
  self.touchMove = nil
  
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
  
  while not self.touchPressQueue:isEmpty() do
    local touch = self.touchPressQueue:poll()
    self.touchPress = touch
    self.lastTouch = touch
  end
  
  while not self.touchReleaseQueue:isEmpty() do
    local touch = self.touchReleaseQueue:poll()
    self.touchRelease = touch
    self.lastTouch = nil
  end
  
  while not self.touchMoveQueue:isEmpty() do
    local touch = self.touchMoveQueue:poll()
    self.touchMove = touch
    self.lastTouch = touch
  end
  
end


-- Functions for adding to the Queues

function InputManager:addPress(button)
  self.pressQueue:add(button)
end

function InputManager:addRelease(button)
  self.releaseQueue:add(button)
end

function InputManager:addTouchPress(touch)
  self.touchPressQueue:add(touch)
end

function InputManager:addTouchRelease(touch)
  self.touchReleaseQueue:add(touch)
end

function InputManager:addTouchMove(touch)
  self.touchMoveQueue:add(touch)
end


-- Love functions down here

function love.gamepadpressed( joystick, button )
  inputManager:addPress(button)
end

function love.gamepadreleased( joystick, button )
  inputManager:addRelease(button)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
  inputManager:addTouchPress(Touch(id,x,y,dx,dy,pressure,"press"))
end

function love.touchreleased( id, x, y, dx, dy, pressure )
  inputManager:addTouchRelease(Touch(id,x,y,dx,dy,pressure,"release"))
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  inputManager:addTouchMove(Touch(id,x,y,dx,dy,pressure,"move"))
end