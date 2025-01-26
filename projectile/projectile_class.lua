-- define a "class" (table)
class_projectile = {}
class_projectile.__index = class_projectile

-- projectiles that collide with something are added here to be deleted later
delete_queue = {}

-- constructor
function class_projectile:new(owner, x, y, dir, speed, col, acc)
    local obj = setmetatable({}, self)

    obj.owner = owner
    obj.dir = dir  -- direction (0,1,2,3) <-> (left,right,up,down)
    obj.speed = speed
    obj.colour = col
    obj.accuracy = acc -- number 0 -> 100

    obj.width = 1
    obj.height = 1

    -- random start point for projectile in lens range
    if obj.dir < 2 then
        obj.x = x+6
        obj.y = y+2+rnd(2)  
    else
        obj.x = x+2+rnd(2)
        obj.y = y+6
    end
    
    obj.collision_box = class_collision_entity:new(obj.x,obj.y,obj.width,obj.height)

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


-- moves projectiles and checks for colission
function class_projectile:move(dx, dy)
    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)


    -- check player against walls & enemies 
    collision_wall = collision_to_list(self, walls, 16)
    collision_enemy = collision_to_list(self, enemies, 16)
    collision_player = collision_to_list(self, {p}, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    -- used to process different attacks
    if #collision_wall == 2 then
        -- collision of a bullet to a wall processing

        log("projectile collided wall from author:")
        log(self.owner.name)
        add(delete_queue, self, #delete_queue+1)
    elseif #collision_enemy == 2 then
        -- collision of a bullet into enemy frendly fire or by player

        if self.owner.name == "player" then
            log("projectile collided enemy from author: player")
            log("projectile have impacted: ")
            log(collision_enemy[2].name)
        else
            log("projectile collided enemy from author: an enemy")
            log("projectile have impacted: ")
            log(collision_enemy[2].name)
        end
        add(delete_queue, self, #delete_queue+1)
    elseif #collision_player == 2 then
        -- enemy attack on player or player attacking themselves

        if self.owner.name == "player" then
            log("projectile collided player from author: player")
            log("projectile have impacted: ")
            log(collision_player[2].name)
        else
            log("projectile collided player from author: an enemy")
            log("projectile have impacted: ")
            log(collision_player[2].name)
        end
        add(delete_queue, self, #delete_queue+1)
    end

end

function class_projectile:draw()
    pset(self.x,self.y,self.colour+1)
end

-- transfers collision box draw signal
function class_projectile:draw_collision_box()
    self.collision_box:draw()
end


function deal_with_delete_queue(obj)
    -- dealt with it
    for i = 1, #delete_queue do
        del(delete_queue[1], obj.proj_list)
        del(delete_queue[1], delete_queue)
    end
end