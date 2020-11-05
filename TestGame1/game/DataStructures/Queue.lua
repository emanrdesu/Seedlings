Queue = Object:extend()

function Queue:new()
  self.l = 0
  self.r = -1
  self.ar = {}
end

function Queue:size()
  return self.r - self.l + 1
end

function Queue:isEmpty()
  if self:size() == 0 then
    return true
  else
    return false
  end
end

function Queue:clear()
  self.l = 0
  self.r = -1
end

function Queue:addLast(v)
  self.r = self.r + 1
  self.ar[self.r] = v
end

function Queue:addFirst(v)
  self.l = self.l - 1
  self.ar[self.l] = v
end

function Queue:peekFirst()
  return self.ar[self.l]
end

function Queue:peekLast()
  return self.ar[self.r]
end

function Queue:pollFirst()
  res = self.ar[self.l]
  self.l = self.l + 1
  return res
end

function Queue:pollLast()
  res = self.ar[self.r]
  self.r = self.r - 1
  return res
end

function Queue:add(v)
  self:addLast(v)
end

function Queue:peek()
  return self:peekFirst()
end

function Queue:poll()
  return self:pollFirst()
end