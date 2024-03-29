CommandUI = Object:extend()

--[[
This is the root object for commandUI on the bottom screen.

Will store the command manager object and a list of available commands for the current minigame

New creates a blank one. Have a setDefault function that will be able to set the default code for a minigame to be something.

Will be based after the UI from the previous senior design team. First will draw black rectangle over entire bottom screen. Then there will be the 'interface' on the left and the 4 buttons on the right (add, edit, del, and run)

On the left will be all the commands being listed. This object will store a stack of updatables. The stack initially has just a commandLister object which will draw the commands on the left side. If Add/edit is selected, a commandEditor/commandSelector will be added to the stack. Only the update function of what is on the top of the stack will be called for the left side. (If the stack is size > 1, the buttons on the right will 'deactivate'

Add -> adds a commandSelector to the top of the stack
Edit -> adds a command editor for the current command to the top of the stack
Del -> deletes the current selected command
Run -> Runs the current code

CommandLister -> lists the commands in the command manager

CommandEditor -> will be passed the index that is being edited as well as a ref to this object for passing to commandLister
  (if you edit the command itself, command lister will be added on top of the stack)
  
CommandSelector ->  (will be passed a reference to this object to reference the available commands)
(will also be passed an index to potentially be changing)

--]]

function CommandUI:new(isTraining)
  -- Initialize stuff. Have the command lister on the top of the stack
  self.commandLister = CommandLister(self)
  self.availableCommands = ArrayList()
  self.commandManager = CommandManager()
  self.commandManager:addCommand(Header())
  self.uiStack = Queue()
  self.uiStack:addLast(self.commandLister)
  self.buttonList = ArrayList()
  
  self.onRun = function() end
  
  -- Create buttons
  local width = 62
  local height = 42
  local x = 250;
  local deltaHeight = 3
  
  -- Functions for drawing buttons
  function getDrawNormal(x, y, w, h, text)
    return function()
      local clr = Color.LIGHT_GRAY
      if (text == "DEL" or text == "EDIT") and not self.commandManager.commandList:get(self.commandLister.selectedIndex):canEdit() then clr = Color:byte(178, 178, 178) end
      draw:rectangle({x=x, y=y, width=w, height=h, color = clr})
      
      fontManager:setFont('18px')
      local th = fontManager:getHeight()
      local tw = fontManager:getWidth(text)
      
      draw:print({
          x=math.floor(x + (w - tw) / 2) - 1, 
          y=math.floor(y + (h - th) / 2) - 3, 
          text = text, color = Color.BLACK, font = '18px'})
    end
  end
  
  function getDrawHovered(x, y, w, h, text)
    return function()
      draw:rectangle({x=x, y=y, width=w, height=h, color = Color:byte(178, 178, 178)})
      fontManager:setFont('18px')
      local th = fontManager:getHeight()
      local tw = fontManager:getWidth(text)
      draw:print({
          x=math.floor(x + (w - tw) / 2) - 1, 
          y=math.floor(y + (h - th) / 2) - 3, 
          text = text, color = Color.BLACK, font = '18px'})
    end
  end
  
  -- ADD button
  local y1 = 3
  self.buttonList:add(
    Button({
      hitbox = {shape = 'rectangle', x = x, y = y1, width = width, height = height},
      drawNormal = getDrawNormal(x, y1, width, height, "ADD"),
      drawHovered = getDrawHovered(x, y1, width, height, "ADD"),
      onClick = function()
        -- Add the command selector to the top of the stack
        self.uiStack:addLast(CommandSelector(self, nil, self.commandLister.selectedIndex), nil)
      end
    })
  )

  -- EDIT button
  local y2 = y1 + height + deltaHeight
  self.buttonList:add(
    Button({
      hitbox = {shape = 'rectangle', x = x, y = y2, width = width, height = height},
      drawNormal = getDrawNormal(x, y2, width, height, "EDIT"),
      drawHovered = getDrawHovered(x, y2, width, height, "EDIT"),
      onClick = function()
        -- Add a command editor to the top of the stack for the selected command
        if self.commandManager.commandList:getSize() > 0 then
          local cmd = self.commandManager.commandList:get(self.commandLister.selectedIndex)
          if cmd:canEdit() then self.uiStack:addLast(CommandEditor(self, cmd)) end
        end
      end
    })
  )
  
  -- Del button
  local y3 = y2 + height + deltaHeight
  self.buttonList:add(
    Button({
      hitbox = {shape = 'rectangle', x = x, y = y3, width = width, height = height},
      drawNormal = getDrawNormal(x, y3, width, height, "DEL"),
      drawHovered = getDrawHovered(x, y3, width, height, "DEL"),
      onClick = function()
        -- If there are commands, delete the selected one
        -- Then update the current selected index
        if self.commandManager.commandList:getSize() > 0 then
          local cmd = self.commandManager.commandList:get(self.commandLister.selectedIndex)
          if cmd:canEdit() then
            self.commandManager:removeCommand(self.commandLister.selectedIndex)
            if self.commandLister.selectedIndex >= self.commandManager.commandList:getSize() then
              self.commandLister.selectedIndex = self.commandManager.commandList:getSize() - 1
            end
            if self.commandLister.selectedIndex < 0 then self.commandLister.selectedIndex = 0 end
          end
        end
      end
    })
  )
  
  -- Run button
  local runHeight = height + 8
  local y4 = y3 + height + deltaHeight
  self.buttonList:add(
    Button({
      hitbox = {shape = 'rectangle', x = x, y = y4, width = width, height = runHeight},
      drawNormal = getDrawNormal(x, y4, width, runHeight, "RUN"),
      drawHovered = getDrawHovered(x, y4, width, runHeight, "RUN"),
      onClick = function() self:execute() end
    })
  )
  
  local y5 = y4 + runHeight + deltaHeight
  local helpButton = Button({
    hitbox = {shape = 'rectangle', x = x, y = y5, width = width, height = runHeight},
    drawNormal = getDrawNormal(x, y5, width, runHeight, "HELP"),
    drawHovered = getDrawHovered(x, y5, width, runHeight, "HELP"),
    onClick = function() self:help() end
  })

  local backButton = Button({
    hitbox = {shape = 'rectangle', x = x, y = y5, width = width, height = runHeight},
    drawNormal = getDrawNormal(x, y5, width, runHeight, "BACK"),
    drawHovered = getDrawHovered(x, y5, width, runHeight, "BACK"),
    onClick = function() self:back() end
  })

  if isTraining == true then
    self.buttonList:add(backButton)
  else
    self.buttonList:add(helpButton)
  end
  
  
end

function CommandUI:update()
  -- Get top of the stack and call its update function
  local top = self.uiStack:peekLast()
  top:update()
  
  -- Update buttons if stack is only size 1
  if self.uiStack:getSize() <= 1 then
    for i = 0, self.buttonList:getSize() - 1, 1 do
      self.buttonList:get(i):update()
    end
  end
end

function CommandUI:drawBottomScreen()
  -- Draw background and buttons on right
  draw:rectangle({
    x = 0,
    y = 0,
    color = Color.EIGENGRAU,
    width = Constants.BOTTOM_SCREEN_WIDTH,
    height = Constants.BOTTOM_SCREEN_HEIGHT,
  })

  --Draw buttons
  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):draw()
  end
    
  -- Draw what is on the top of the stack
  local top = self.uiStack:peekLast()
  top:drawBottomScreen()
end

-- Add an available command for this manager
function CommandUI:addAvailableCommand(cmd)
  self.availableCommands:add(cmd)
end

function CommandUI:execute()
  local compiles = self.commandManager:doesItCompile()
  if compiles == false then
    -- Add a compile error to the stack
    self.uiStack:addLast(CompileError(self))
  end
  self.onRun()
end

function CommandUI:help()
  self.onHelp()
end

function CommandUI:back()
  self.onBack()
end

function CommandUI:setOnRun(func)
  self.onRun = func
end

function CommandUI:setOnHelp(func)
  self.onHelp = func
end

function CommandUI:setOnBack(func)
  self.onBack = func
end