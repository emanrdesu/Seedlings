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

-- Function to convert 0-255 values
function Color:byte(r, g, b, alpha)
  local a = alpha or 255.0
  return Color(r/255.0, g/255.0, b/255.0, a/255.0)
end

-- Constants have to go below constructor
Color.RED = Color(1,0,0)
Color.BLUE = Color(0,0,1)
Color.GREEN = Color(0,1,0)
Color.WHITE = Color(1,1,1)
Color.LIGHT_GRAY = Color(0.9, 0.9, 0.9)
Color.BLACK = Color(0,0,0)
Color.EIGENGRAU = Color(22.0/255.0, 22.0/255.0, 29.0/255.0)
Color.GRAY = Color(0.6, 0.6, 0.6)
Color.SAND = Color:byte(255, 255, 237)
Color.YELLOW = Color(1,1,0)

function Color:tostring(color)
  if color == Color.RED then return "RED" end
  if color == Color.BLUE then return "BLUE" end
  if color == Color.GREEN then return "GREEN" end
  if color == Color.WHITE then return "WHITE" end
  if color == Color.LIGHT_GRAY then return "LIGHT GRAY" end
  if color == Color.BLACK then return "BLACK" end
  if color == Color.EIGENGRAU then return "EIGENGRAU" end
  if color == Color.GRAY then return "GRAY" end
  if color == Color.SAND then return "SAND" end
  if color == Color.YELLOW then return "YELLOW" end
  return nil
end