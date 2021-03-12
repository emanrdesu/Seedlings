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
    radius = 15,
    x = centX,
    y = centY,
    segments = 15,
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
  local w = 25
  local h = 12
  local dx = 3
  local dy = 4
  local sy = 0
  
  draw:rectangle({
    x = x,
    y = sy,
    width = w,
    height = h,
    color = Color.BLACK,
  })

  local pl = {x = x + dx, y = sy + h - dy}
  local pm = {x = x + (w/2), y = sy + dy}
  local pr = {x = x + w - dx, y = sy + h - dy}
  draw:line({
    points = {pl.x, pl.y, pm.x, pm.y, pr.x, pr.y},
    lineWidth = 3,
    color = Color.WHITE,
  })

end

CommandUIButtons.scrollDown = function(x)
  local w = 25
  local h = 12
  local dx = 3
  local dy = 4
  local sy = Constants.BOTTOM_SCREEN_HEIGHT - h
  
  draw:rectangle({
    x = x,
    y = sy,
    width = w,
    height = h,
    color = Color.BLACK,
  })

  local pl = {x = x + dx, y = sy + dy}
  local pm = {x = x + (w/2), y = sy + h - dy}
  local pr = {x = x + w - dx, y = sy + dy}
  draw:line({
    points = {pl.x, pl.y, pm.x, pm.y, pr.x, pr.y},
    lineWidth = 3,
    color = Color.WHITE,
  })
end