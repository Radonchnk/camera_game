-- define a "class" (table)
projectile = {}
projectile.__index = projectile

function projectile:new(x,y,dir,speed)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.dir = dir  -- direction (0,1,2,3) <-> (left,right,up,down)
    obj.speed = speed
    
    return obj
end

function projectile:draw()
    self.x += dx * self.speed
    self.y += dy * self.speed
    self.colission_box:offset(dx * self.speed,  dy * self.speed)
    pset(self.x,self.y,1)
end