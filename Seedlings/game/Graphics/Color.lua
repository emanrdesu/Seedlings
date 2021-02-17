Color = Object:extend()

function Color:new(r, g, b, alpha)
  self.r = r
  self.g = g
  self.b = b
  self.alpha = alpha or 1
end

-- Function to take a color and get a different alpha
function Color:withAlpha(newAlpha)
  return Color(self.r, self.g, self.b, newAlpha)
end

-- Constants have to go below constructor
Color.RED = Color(1,0,0)
Color.BLUE = Color(0,0,1)
Color.GREEN = Color(0,1,0)
Color.WHITE = Color(1,1,1)
Color.LIGHT_GRAY = Color(0.9, 0.9, 0.9)
Color.BLACK = Color(0,0,0)
Color.EIGENGRAU = Color(22.0/255.0, 22.0/255.0, 29.0/255.0)