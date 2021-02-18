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

function CommandUI:new()
  self.availableCommands = ArrayList()
  self.commandManager = CommandManager()
  self.uiStack = Queue()
  self.uiStack:addLast(CommandLister(this))
  self.buttonList = ArrayList()
  self.buttonList:add(
    Button({
      hitbox = {shape = 'circle', x = 300, y = 50, r = 15},
      drawNormal = function()
        draw:circle({mode = 'fill', x = 300, y = 50, radius = 15, segments = 10, color = Color.RED})
      end,
      drawHovered = function()
        draw:circle({mode = 'fill', x = 300, y = 50, radius = 15, segments = 10, color = Color.BLUE})
      end
    })
  );
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

  -- TODO: Draw buttons
  for i = 0, self.buttonList:getSize() - 1, 1 do
    self.buttonList:get(i):draw()
  end
    
  -- Draw what is on the top of the stack
  local top = self.uiStack:peekLast()
  top:drawBottomScreen()
end