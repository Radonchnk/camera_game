-- define a "class" (table)
class_projectile = {}
class_projectile.__index = class_projectile

-- constructor
function class_projectile:new(x,y,dir,speed,col,acc)
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

function class_projectile:update()
    local error = 0 -- vary movement

    -- accuracy rng
    if rnd(101) > self.accuracy then
        error = rnd({0.25,-0.25})
    end

    if self.dir == 0 then -- left
        self:move(-1,error)
    elseif self.dir == 1 then -- right
        self:move(1,error)
    elseif self.dir == 2 then -- up
        self:move(error,-1)
    elseif self.dir == 3 then -- down
        self:move(error,1)
    elseif self.dir == 4 then -- up left
        self:move(-1+error,-1+error)
    elseif self.dir == 5 then -- up right
        self:move(1+error,-1+error)
    elseif self.dir == 6 then -- down left
        self:move(-1+error,1+error)
    else -- down right
        self:move(1+error,1+error)
    end
end

function class_projectile:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
end

function class_projectile:draw()
    pset(self.x,self.y,self.colour+1)
end