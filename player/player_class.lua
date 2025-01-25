-- define a "class" (table)
player = {}
player.__index = player

-- these are lists, i promise
player_proj_list = {}
player_inventory = {}

-- TODO: remove
for i=1, 5 do
    add(player_inventory, item:new(1))
end

showing_inventory = true

-- constructor
function player:new(x, y, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 0
    obj.dir = 1
    obj.offset = {0,0}
    obj.colour = 9

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the player
function player:move(dx, dy)

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)


    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_enemies = collision_to_list(self, enemies, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_enemies == 2 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)
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

    if showing_inventory then
        rectfill(36, 98, 98, 110, 6)
        -- draw items at (40, 20), (52, 20), (64, 20), (72, 20), (90, 20)
        -- space for 5 items, as needed
        for i = 1, #player_inventory do
            x = 28 + (i * 12)
            y = 100
            player_inventory[i]:draw(x, y)
        end
    end
end

-- transfers collision box draw signal
function player:draw_collision_box()
    self.collision_box:draw()
end

-- creates a projectile
function player:shoot()
    add(player_proj_list, projectile:new(p.x,p.y,p.dir,4,p.colour,80))
end