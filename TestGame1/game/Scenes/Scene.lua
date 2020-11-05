Scene = Object:extend()

function Scene:update()
  --[[
    To be overwritten by child classes
  --]]
  return self
end

function Scene:drawTopScreen()
  --[[
    To be overwritten by child classes
  --]]
end

function Scene:drawBottomScreen()
  --[[
    To be overwritten by child classes
  --]]
end