
function drawLayout(screen, layout)

   -- begin prepareLayout
   local function prepareLayout(layout)

      local function plus(a,b) return a+b end
      local function mult(a,b) return a*b end

      local function combine1(a, b, f, d)
	 return (a and b) and f(a,b) or (a or b or d)
      end

      local function combine2(a, b, f, d)
	 local function z(a) return {x = a[1], y = a[2]} end
	 local function g(f, a, b)
	    return {x = f(a[1],b[1]), y = f(a[2], b[2])}
	 end

	 a = type(a) ~= 'table' and (a and {a,a}) or a
	 b = type(b) ~= 'table' and (b and {b,b}) or b

	 return (a and b) and g(f,a,b) or z(a or b or d)
      end

      for _,asset in ipairs(layout) do
	 asset.drawable = asset[1]

         for k,p in pairs(asset) do
            if type(k) ~= 'number' then
               asset.drawable[k] = p
            end
         end

	 asset.drawable.scale = combine2(layout.scale, asset.scale, mult, {1,1})
	 asset.drawable.margin = combine2(layout.margin, asset.margin, plus, {0,0})
	 asset.drawable.radians = combine1(layout.radians, asset.radians, plus, 0)
	 asset.drawable.opacity = combine1(layout.opacity, asset.opacity, plus, 1)

	 asset.vcx = asset[2][1] -- vague center x
	 asset.vcy = asset[2][2] -- vague center y

	 if asset.children then
	    prepareLayout(asset.children)
	 end
      end
   end
   -- end prepareLayout

   --begin drawLayoutHelper
   local function drawLayoutHelper(land, layout)

      local function assetRadius(asset)
	 return math.floor(asset.drawable:getWidth() / 2),
                math.floor(asset.drawable:getHeight() / 2)
      end

      -- begin prepareAsset
      local function prepareAsset(asset)
	 local function vtoc(a, n)
            local density = layout.density or n
	    return math.floor(a / (density - 1) * n)
	 end

         asset.cx = vtoc(asset.vcx, land.width)
         asset.cy = vtoc(asset.vcy, land.height)
         local aswr, ashr = assetRadius(asset)
         asset.drawable.x = asset.cx - aswr
         asset.drawable.y = asset.cy - ashr

         if asset.cx - aswr < 0 then
            asset.drawable.x = 0
         end

         if asset.cx + aswr > land.width then
            asset.drawable.x = land.width - (2 * aswr)
         end

         if asset.cy - ashr < 0 then
            asset.drawable.y = 0
         end

         if asset.cy + ashr > land.height then
            asset.drawable.y = land.height - (2 * ashr)
         end

         asset.drawable.x = asset.drawable.x + land.offset.x
         asset.drawable.y = asset.drawable.y + land.offset.y
      end
      -- end prepareAsset

      for _,asset in ipairs(layout) do
	 prepareAsset(asset)
         asset.drawable:draw()
         if asset.children then
            local assetLand = {}
            assetLand.offset = {}
            assetLand.width = asset.drawable:getWidth()
            assetLand.height = asset.drawable:getHeight()
            assetLand.offset.x = asset.drawable.x
            assetLand.offset.y = asset.drawable.y
            drawLayoutHelper(assetLand, asset.children)
         end
      end
   end
   -- end drawLayoutHelper

   local land = { offset = {x = 0, y = 0} }
   if screen == 'top' then
      land.width = Constants.TOP_SCREEN_WIDTH
      land.height = Constants.TOP_SCREEN_HEIGHT
   else
      land.width = Constants.BOTTOM_SCREEN_WIDTH
      land.height = Constants.BOTTOM_SCREEN_HEIGHT
   end

   prepareLayout(layout)
   drawLayoutHelper(land, layout)
end
