-- define a "class" (table)
player = {}
player.__index = player

-- constructor
function player:new(x, y)
    local obj = setmetatable({}, self)
    obj.size = 8 -- in pixels for w and h
    obj.x = x
    obj.y = y
    obj.speed = 2

    x = obj.x
    y = obj.y
    width = obj.size
    height = obj.size
    
    obj.colission_box = colission_entity:new(x,y,width,height)

    return obj
end

-- method to move the player
function player:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
    self.colission_box:offset(dx * self.speed,  dy * self.speed)
end

-- method to draw the player
function player:draw()
    spr(1, self.x, self.y, 1, 1)
end

-- transfers colission box draw signal
function player:draw_colission_box()
    self.colission_box:draw()
end