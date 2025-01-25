-- define a "class" (table)
wall = {}
wall.__index = wall

-- constructor
function wall:new(x, y)
    local obj = setmetatable({}, self)
    obj.size = 8 -- in pixels for w and h
    obj.x = x
    obj.y = y
    obj.speed = 2

    x = obj.x
    y = obj.y
    obj.width = obj.size
    obj.height = obj.size
    
    obj.collision_box = collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to draw the wall
function wall:draw()
    spr(32, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function wall:draw_collision_box()
    self.collision_box:draw()
end
