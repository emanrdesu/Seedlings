Friend = Object:extend()

function Friend:new(friendName, friendHasHat)
  self.friendName = friendName
  self.friendHasHat = friendHasHat
  self.objectName = 'Friend'
end

function Friend:toString()
  local s = tostring("friendName is " .. self.friendName .. " \nfriendHasHat is " ..  tostring(self.friendHasHat))
  return s
end