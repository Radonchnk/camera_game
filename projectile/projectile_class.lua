-- define a "class" (table)
projectile = {}
projectile.__index = projectile

function projectile:new(x,y,dir,speed)
    local obj = setmetatable({}, self)
    obj.x = x+4
    obj.y = y+4
    obj.dir = dir  -- direction (0,1,2,3) <-> (left,right,up,down)
    obj.speed = speed
    
    return obj
end

function projectile:update()
    if self.dir == 0 then
        self.x -= self.speed
    elseif self.dir == 1 then
        self.x += self.speed
    elseif self.dir == 2 then
        self.y -= self.speed
    elseif self.dir == 3 then
        self.y += self.speed
    end
end

function projectile:draw()
    pset(self.x,self.y)
end