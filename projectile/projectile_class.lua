-- define a "class" (table)
projectile = {}
projectile.__index = projectile

-- constructor
function projectile:new(x,y,dir,speed,col,acc)
    local obj = setmetatable({}, self)

    obj.dir = dir  -- direction (0,1,2,3) <-> (left,right,up,down)
    obj.speed = speed
    obj.colour = col
    obj.accuracy = acc -- number 0 -> 100

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
    local error = 0 -- vary movement

    -- accuracy rng
    if rnd(101) > self.accuracy then
        error = rnd({0.25,-0.25})
    end

    if self.dir == 0 then
        self:move(-1,error)
    elseif self.dir == 1 then
        self:move(1,error)
    elseif self.dir == 2 then
        self:move(error,-1)
    elseif self.dir == 3 then
        self:move(error,1)
    end
end

function projectile:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
end

function projectile:draw()
    pset(self.x,self.y,self.colour+1)
end