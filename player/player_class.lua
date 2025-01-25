-- define a "class" (table)
player = {}
player.__index = player

-- constructor
function player:new(x, y)
    local obj = setmetatable({}, self)
    obj.size = 4
    obj.x = x or 0
    obj.y = y or 0
    obj.speed = 2

    x = obj.x-obj.size
    y = obj.y-obj.size
    width = obj.size*2 + 1
    hight = obj.size*2 + 1
    
    obj.colission_box = colission_entity:new(x,y,width,hight)

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
    circfill(self.x, self.y, self.size, 7)
end

-- transfers draw signal
function player:draw_colission_box()
    self.colission_box:draw()
end