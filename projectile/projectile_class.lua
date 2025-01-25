-- define a "class" (table)
projectile = {}
projectile.__index = projectile

-- constructor
function projectile:new(x,y,dir,speed,col)
    local obj = setmetatable({}, self)

    obj.dir = dir  -- direction (0,1,2,3) <-> (left,right,up,down)
    obj.speed = speed
    obj.colour = col
    
    -- random start point for projectile in lens range
    if obj.dir < 2 then
        obj.x = x+6
        obj.y = y+2+rnd(2)
    else
        obj.x = x+2+rnd(2)
        obj.y = y+6
    end

    return obj
end

-- update function called every frame, moves projectile
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

function projectile:move()

end

function projectile:draw()
    pset(self.x,self.y,self.colour+1)
end