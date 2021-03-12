CommandUIButtons = Object:extend()

CommandUIButtons.drawConfirm = function()
  local confirmW = 50
  local confirmH = 50
  local confirmX = Constants.BOTTOM_SCREEN_WIDTH - confirmW
  local confirmY = Constants.BOTTOM_SCREEN_HEIGHT - confirmH
  draw:rectangle({
    x = confirmX,
    y = confirmY,
    width = confirmW,
    height = confirmH,
    color = Color:byte(38, 239, 10)
  })
  local centX = confirmX + (confirmW / 2)
  local centY = confirmY + (confirmH / 2)
  draw:circle({
    mode = 'line',
    lineWidth = 4,
    color = Color.WHITE,
    radius = 12,
    x = centX,
    y = centY,
  })
end

CommandUIButtons.drawClose = function()
  local xwidth = 30
  local xheight = 30
  local buttonX = 0 + Constants.BOTTOM_SCREEN_WIDTH - xwidth
  local buttonY = 0
  
  draw:rectangle({
    x = buttonX,
    y = buttonY,
    width = xwidth,
    height = xheight,
    color = Color.RED
  })
  local of = 8
  local tl = {x = buttonX + of, y = buttonY + of}
  local tr = {x = buttonX + xwidth - of, y = buttonY + of}
  local bl = {x = buttonX + of, y = buttonY + xheight - of}
  local br = {x = buttonX + xwidth - of, y = buttonY + xheight - of}
  draw:line({
    points = {tl.x, tl.y, br.x, br.y},
    color = Color.WHITE,
    lineWidth = 4,
  })
  draw:line({
    points = {tr.x, tr.y, bl.x, bl.y},
    color = Color.WHITE,
    lineWidth = 4,
  })
end


CommandUIButtons.scrollUp = function(x)
  -- Black rectangle with white arrow up
  local w = 20
  local h = 10
  
  draw:rectangle({
    x = x,
    y = 0,
    width = w,
    height = h,
  })
end

CommandUIButtons.scrollDown = function(x)
  local w = 20
  local h = 10
  
  draw:rectangle({
    x = x,
    y = Constants.BOTTOM_SCREEN_HEIGHT - h,
    width = w,
    height = h,
  })
end