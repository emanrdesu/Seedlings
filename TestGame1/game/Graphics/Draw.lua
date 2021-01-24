Draw = Object:extend()

function Draw:new()

end

--[[
Doesn't work in DS for some reason
function Draw:arc(args)
  local mode, arctype, x, y, radius, fromAngle, toAngle, segments, color, lineWidth = 
    args.mode or 'fill',
    args.arctype or nil,
    args.x or 0,
    args.y or 0,
    args.radius or 1,
    args.fromAngle or 0,
    args.toAngle or 0,
    args.segments or 10,
    args.color or Color(1,1,1),
    args.lineWidth or 0

  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  if arctype == nil then
    love.graphics.arc(mode, x, y, radius, fromAngle, toAngle, segments)
  else
    love.graphics.arc(mode, arctype, x, y, radius, fromAngle, toAngle, segments)
  end
  love.graphics.reset()
end
--]]

-- draw:circle({mode='fill', x=200,y=150, radius=30, color=Color(0.5,0.2,0.9)})
function Draw:circle(args)
  local mode, x, y, radius, segments, color, lineWidth = 
    args.mode or 'fill',
    args.x or 0,
    args.y or 0,
    args.radius or 1,
    args.segments or nil,
    args.color or Color(1,1,1),
    args.lineWidth or 0
    
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  if segments == nil then
    love.graphics.circle(mode, x, y, radius)
  else
    love.graphics.circle(mode, x, y, radius, segments)
  end
  love.graphics.reset()
end

--[[
Doesn't work in DS for some reason
function Draw:ellipse(args)
  local mode, x, y, radiusX, radiusY, segments, color, lineWidth = 
    args.mode or 'fill',
    args.x or 0,
    args.y or 0,
    args.radiusX or 1,
    args.radiusY or 1,
    args.segments or nil,
    args.color or Color(1,1,1),
    args.lineWidth or 0
    
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  if segments == nil then
    love.graphics.ellipse(mode, x, y, radiusX, radiusY)
  else
    love.graphics.ellipse(mode, x, y, radiusX, radiusY, segments)
  end
  love.graphics.reset()
end
--]]

-- draw:line({points={40,20,30,40,400, 400}, color=Color(.6,.2,.8), lineWidth=10})
function Draw:line(args)
  local points, lineWidth, color = 
    args.points or {0,0,0,0},
    args.lineWidth or 1,
    args.color or Color(1,1,1)
    
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  
  local n = table.getn(points)
  for i = 1, n-2, 2 do
    local x1 = points[i]
    local y1 = points[i+1]
    local x2 = points[i+2]
    local y2 = points[i+3]
    love.graphics.line(x1,y1,x2,y2)
    if i > 1 then
      love.graphics.circle('fill', x1, y1, lineWidth/2.0)
    end
  end
  -- love.graphics.line(points)
  love.graphics.reset()
end

--[[
Points function only exists on switch
function Draw:points(args)
  local points, pointSize, color = 
    args.points or {0,0},
    args.pointSize or 1,
    args.color or Color(1,1,1)
    
  love.graphics.setPointSize(pointSize)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  love.graphics.points(points)
  love.graphics.reset()
end
--]]


-- draw:polygon({points={200,0,200,50,260,10},color=Color.RED,mode='line',lineWidth=6})
function Draw:polygon(args)
  local mode, points, color, lineWidth = 
    args.mode or 'fill',
    args.points or {0,0,0,0,0,0},
    args.color or Color(1,1,1),
    args.lineWidth or 1
  
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  love.graphics.polygon(mode, points)
  love.graphics.reset()
end

-- draw:rectangle({mode='line', x=10, y=10, width=30, height=30, color=Color.BLUE, lineWidth=5})
function Draw:rectangle(args)
  local mode, x, y, width, height, rx, ry, segments, color, lineWidth = 
    args.mode or 'fill',
    args.x or 0,
    args.y or 0,
    args.width or 0,
    args.height or 0,
    args.rx or 0,
    args.ry or 0,
    args.segments or nil,
    args.color or Color(1,1,1),
    args.lineWidth or 0

  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  love.graphics.rectangle(mode, x, y, width, height, rx, ry, segments)
  love.graphics.reset()
end

function Draw:draw(args)
  local drawable, x, y, r, sx, sy, ox, oy, kx, ky =
    args.drawable or nil,
    args.x or 0,
    args.y or 0,
    args.r or 0,
    args.sx or 1,
    args.sy or 1,
    args.ox or 0,
    args.oy or 0,
    args.kx or 0,
    args.ky or 0
    
  love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end

-- draw:print({text="test message", x = 230, y = 160, color = Color.BLUE, font='36px'})
function Draw:print(args)
  local text, x, y, r, sx, sy, ox, oy, font, color = 
    args.text or "",
    args.x or 0,
    args.y or 0,
    args.r or 0,
    args.sx or 1,
    args.sy or 1,
    args.ox or 0,
    args.oy or 0,
    args.font or 'default',
    args.color or Color(1,1,1)
    
  local coloredtext = {{color.r, color.g, color.b, color.alpha},text}
  fontManager:setFont(font)
  love.graphics.print(coloredtext, x, y, r, sc, sy, ox, oy)
  
  love.graphics.reset()
end