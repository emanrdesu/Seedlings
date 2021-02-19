ArrayList = Object:extend()

function ArrayList:new()
  self.ar = {}
  self.size = 0
end

function ArrayList:getSize()
  return self.size
end

function ArrayList:clear()
  self.ar = {}
  self.size = 0
end

function ArrayList:add(v)
  self.ar[self.size] = v
  self.size = self.size + 1
end

function ArrayList:remove(id)
  local newAr = {}
  local idx = 0
  for i = 0, id-1, 1 do
    newAr[idx] = self.ar[i]
    idx = idx + 1
  end
  for i = id+1, self.size-1, 1 do
    newAr[idx] = self.ar[i]
    idx = idx + 1
  end
  self.ar = newAr
  self.size = self.size - 1
end

function ArrayList:insert(index, v)
  local newAr = {}
  local idx = 0
  
  for i = 0, index-1, 1 do
    newAr[idx] = self.ar[i]
    idx = idx + 1
  end
  
  newAr[idx] = v
  idx = idx + 1
  
  for i = index, self.size-1, 1 do
    newAr[idx] = self.ar[i]
    idx = idx + 1
  end
  
  self.ar = newAr
  self.size = self.size + 1
end

function ArrayList:insertBefore(index, v)
  self:insert(index, v)
end

function ArrayList:insertAfter(index, v)
  self:insert(index + 1, v)
end

function ArrayList:get0Indexed(v)
  return self.ar[v]
end

function ArrayList:get1Indexed(v)
  return self.ar[v - 1]
end

function ArrayList:get(v)
  return self:get0Indexed(v)
end

function ArrayList:set(index, v)
  self.ar[index] = v
end

function ArrayList:traverse()
  local res = {}
  local idx = 1
  
  for i = 0, self.size - 1, 1 do
    res[idx] = self.ar[i]
    idx = idx + 1
  end
  
  return res
end
