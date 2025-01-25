-- define a "class" (table)
wall = {}
wall.__index = wall

-- constructor
function wall:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 2

    obj.width = width or 8
    obj.height = height or 8
    
    obj.colission_box = colission_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to draw the wall
function wall:draw()
    spr(16, self.x, self.y, 1, 1)
end

-- transfers colission box draw signal
function wall:draw_colission_box()
    self.colission_box:draw()
end
