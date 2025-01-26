-- define a "class" (table)
class_wall = {}
class_wall.__index = class_wall

-- constructor
function class_wall:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 2

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to draw the wall
function class_wall:draw()
    spr(32, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function class_wall:draw_collision_box()
    self.collision_box:draw()
end
