-- define a "class" (table)
player = {}
player.__index = player

player_proj_list = {}
-- constructor
function player:new(x, y)
    local obj = setmetatable({}, self)
    obj.size = 8 -- in pixels for w and h
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 0
    obj.dir = 1
    obj.offset = {0,0}
    obj.colour = 9

    x = obj.x
    y = obj.y
    obj.width = obj.size
    obj.height = obj.size
    
    obj.collision_box = collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the player
function player:move(dx, dy)

    log(self.x)
    log(self.y)
    

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)
    radius_walls = get_close_elements(self, walls, 16)

    collision = 0

    for i = 1, #radius_walls do
        if do_collide(self.collision_box, radius_walls[i].collision_box) then
            collision = 1
            log("collision")
        end
    end

    if collision == 1 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)
        collision = 0
    end

end

-- method to draw the player
function player:draw()
    -- drawing setting filter offset depending on rotation
    if self.dir == 0 then 
        self.offset[0] = 1
        self.offset[1] = 2
    elseif self.dir == 1 then
        self.offset[0] = 4
        self.offset[1] = 2
    elseif self.dir == 2 then
        self.offset[0] = 2
        self.offset[1] = 1
    else
        self.offset[0] = 2
        self.offset[1] = 4
    end

    spr(self.base_spr, self.x, self.y, 1, 1)
    
    -- filter drawing
    pset(self.x+self.offset[0],self.y+self.offset[1],self.colour)
    pset(self.x+self.offset[0]+1,self.y+self.offset[1],self.colour+1)
    pset(self.x+self.offset[0],self.y+self.offset[1]+1,self.colour+1)
    pset(self.x+self.offset[0]+1,self.y+self.offset[1]+1,self.colour)
end

-- transfers collision box draw signal
function player:draw_collision_box()
    self.collision_box:draw()
end

-- creates a projectile
function player:shoot()
    add(player_proj_list, projectile:new(p.x,p.y,p.dir,6,p.colour))
end