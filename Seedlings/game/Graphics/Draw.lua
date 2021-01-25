Draw = Object:extend()

function Draw:new()
  
end

function Draw:reset()
  love.graphics.setColor(1,1,1)
end

-- 0 degrees is positive X axis, going clockwise
-- draw:arc({mode='line', arctype='open', x=200, y=50, radius = 50, fromAngle = 0, toAngle = 3*math.pi/2.0, segments = 20, color = Color.BLUE, lineWidth=4})
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
    args.lineWidth or 1
    
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  
  if not (mode == 'line' and arctype == 'open') then
    -- Use polygon for it
    local index = 1
    local points = {}
    -- Add the center of the circle
    if arctype == 'pie' then
      points[index] = x
      points[index+1] = y
      index = index + 2
    end
    
    -- Create the points around the arc with segment segs
    local angle = fromAngle
    local dAngle = (toAngle - fromAngle) / segments
    for i = 0, segments, 1 do
      points[index] = x + (radius * math.cos(angle))
      points[index+1] = y + (radius * math.sin(angle))
      index = index + 2
      angle = angle + dAngle
    end
    
    love.graphics.polygon(mode, points)
  else
    -- Need to use lines for it
    local index = 1
    local points = {}
    local angle = fromAngle
    local dAngle = (toAngle - fromAngle) / segments
    for i = 0, segments, 1 do
      points[index] = x + (radius * math.cos(angle))
      points[index+1] = y + (radius * math.sin(angle))
      index = index + 2
      angle = angle + dAngle
    end
    
    local n = table.getn(points)
    for i = 1, n-2, 2 do
      local x1 = points[i]
      local y1 = points[i+1]
      local x2 = points[i+2]
      local y2 = points[i+3]
      -- if i > 1 then
      --  love.graphics.circle('fill', x1, y1, lineWidth/2.0)
      -- end 
      love.graphics.line(x1,y1,x2,y2)
    end
    
  end
  
  self:reset()
end

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
  self:reset()
end


-- draw:ellipse({mode='line', x=100, y=100, radiusX=50, radiusY = 60, lineWidth=2, segments=15})
function Draw:ellipse(args)
  local mode, x, y, radiusX, radiusY, segments, color, lineWidth = 
    args.mode or 'fill',
    args.x or 0,
    args.y or 0,
    args.radiusX or 1,
    args.radiusY or 1,
    args.segments or 5,
    args.color or Color(1,1,1),
    args.lineWidth or 1
  
  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  
  local points = {}
  local leftIndex = 1
  local rightIndex = 2 * 2 * segments
  -- use segment number of segs above and below major axis
  if radiusX >= radiusY then
    -- do far right point
    points[leftIndex] = x + radiusX
    points[leftIndex+1] = y
    leftIndex = leftIndex + 2
    
    -- Now get the points in the middle
    local cAngle = 0
    local dAngle = math.pi / segments
    for i = 1, segments - 1, 1 do
      cAngle = cAngle + dAngle
      local cx = radiusX * math.cos(cAngle)
      local cy = math.sqrt(radiusY*radiusY * (1 - ((cx*cx)/(radiusX*radiusX))))
      
      points[leftIndex] = x + cx
      points[leftIndex+1] = y + cy
      leftIndex = leftIndex + 2
      
      points[rightIndex-1] = x + cx
      points[rightIndex] = y + (-cy)
      rightIndex = rightIndex - 2
    end
    
    -- Now do the far left point
    points[leftIndex] = x - radiusX
    points[leftIndex+1] = y
  else
    -- do far up point
    points[leftIndex] = x
    points[leftIndex+1] = y + radiusY
    leftIndex = leftIndex + 2
    
    -- Now get points in the middle
    local cAngle = math.pi / 2
    local dAngle = math.pi / segments
    for i = 1, segments - 1, 1 do
      cAngle = cAngle + dAngle
      local cy = radiusY * math.sin(cAngle)
      local cx = math.sqrt(radiusX*radiusX * (1 - ((cy*cy)/(radiusY*radiusY))))
      
      points[leftIndex] = x + cx
      points[leftIndex+1] = y + cy
      leftIndex = leftIndex + 2
      
      points[rightIndex-1] = x + (-cx)
      points[rightIndex] = y + cy
      rightIndex = rightIndex - 2
    end
    
    -- Now do the far down point
    points[leftIndex] = x
    points[leftIndex+1] = y - radiusY
    
  end
  love.graphics.polygon(mode, points)
  self:reset()
end
  

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
  self:reset()
end

-- draw:points({points={10,10,20,20,30,30},pointSize=4,color=Color.RED})
function Draw:points(args)
  local points, pointSize, color = 
    args.points or {},
    args.pointSize or 1,
    args.color or Color(1,1,1)
  
  love.graphics.setColor(color.r, color.g, color.b, color.alpha)
  local n = table.getn(points)
  for i = 1, n-2, 2 do
    love.graphics.circle('fill', points[i], points[i+1], pointSize / 2)
  end
  
  self:reset()
end


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
  self:reset()
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
  self:reset()
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
  
  self:reset()
end