List = Object:extend()

function List:new()
  self.list = nil
  self.size = 0
end

function List:size()
  return self.size
end

function List:clear()
  self.list = nil
  self.size = 0
end

function List:add(v)
  self.list = {next = list, value = v}
  self.size = self.size + 1
end

function List:traverse()
  local ar = {}
  local idx = 1
  local cur = self.list
  while(cur) do
    ar[idx] = cur.value
    idx = idx + 1
    cur = cur.next
  end
end