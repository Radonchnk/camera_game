-- define a "class" (table)
class_player = {}
class_player.__index = class_player

-- these are lists, i promise


showing_inventory = false


-- constructor
function class_player:new(x, y, width, height)
    local obj = setmetatable({}, self)

    obj.inventory = {}

    -- TODO: remove
    for i=1, 5 do
        add(obj.inventory, class_item:new(1))
    end

    obj.max_health_points = 100
    obj.health_points = 100
    obj.battery = 100  -- battery level, used up when shooting

    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 0
    obj.dir = 1
    obj.colour = 9

    obj.current_room_x = 1
    obj.current_room_y = 1

    -- can shoot every frame
    obj.reload_speed = 0
    obj.reload_value = 0

    -- count kills\
    obj.kill_count = 0 

    obj.name = "player"

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

function class_player:move(dx, dy)
    self.x += dx 
    self.y += dy 
    self.collision_box:offset(dx,  dy)
end

-- method to move the player
function class_player:update(dx, dy)
    if self.battery < 99 then
        self.battery += 2
    end

    if self.battery <= 20 then
        self.colour = 1
    else
        self.colour = 9
    end

    self:move(dx * self.speed, dy * self.speed)


    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_enemies = collision_to_list(self, enemies, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_enemies == 2 then
        self:move(-dx * self.speed, -dy * self.speed)
    end

    -- takes some amount of frames to reload
    if self.reload_value > 0 then
        self.reload_value -= 1
    end

    -- check for player moving to the edge of the map to trigger the teleport
    local middle_x = self.x + self.width / 2
    local middle_y = self.y + self.height / 2
    if middle_x < 0 then
        -- move to west room
        --log("move to west room")
        self:move(127, 0)
        self:room_transfer(-1, 0)
    elseif middle_x > 128 then
        -- move to east room
        --log("move to east room")
        self:move(-127, 0)
        self:room_transfer(1, 0)
    elseif middle_y < 0 then
        -- move to north room
        --log("move to morth room")
        self:move(0, 127)
        self:room_transfer(0, -1)
    elseif middle_y > 128 then 
        -- move to south
        --log("move to south room")
        self:move(0, -127)
        self:room_transfer(0, 1)
    end

end

-- method to draw the player
function class_player:draw()
    -- Define offsets for directions in a table for easier management
    local offsets = {
        {x = 1, y = 2},  -- left
        {x = 4, y = 2},  -- right
        {x = 2, y = 1},  -- up
        {x = 2, y = 4},  -- down
        {x = 1, y = 2},  -- up left
        {x = 6, y = 2},  -- up right
        {x = 1, y = 4},  -- down left
        {x = 6, y = 4}   -- down right
    }

    -- Get offset based on direction
    local offset = offsets[self.dir + 1]

    -- Draw the base sprite
    spr(self.base_spr, self.x, self.y, 1, 1)
    
    -- Define pixel patterns
    local function draw_square_filter(x, y, colour)
        pset(x, y, colour)
        pset(x + 1, y, colour + 1)
        pset(x, y + 1, colour + 1)
        pset(x + 1, y + 1, colour)
    end

    local function draw_cross_filter(x, y, colour)
        pset(x, y, colour)
        pset(x + 1, y, colour + 1)
        pset(x - 1, y, colour + 1)
        pset(x, y + 1, colour + 1)
        pset(x, y - 1, colour + 1)
    end

    -- Determine which filter to draw based on direction
    if self.dir < 4 then
        draw_square_filter(self.x + offset.x, self.y + offset.y, self.colour)
    else
        draw_cross_filter(self.x + offset.x, self.y + offset.y, self.colour)
    end



end

function class_player:draw_hp_bar()
    rectfill(self.x-3, self.y-2, self.x+10-3, self.y-2, 5)
    rectfill(self.x-3, self.y-2, self.x+flr(self.health_points/self.max_health_points*10)-3, self.y-2, 8)
end

function class_player:take_damage(damage)
    self.health_points -= damage
    self.battery -= 5
        if self.battery <= 20 then
            self.colour = 1
            self.battery = 0
        end

    if self.health_points < 1 then
        dead = true
    end
end

function class_player:draw_inventory() 
    if showing_inventory then
        rectfill(32, 98, 94, 110, 6)
        -- draw items at (40, 20), (52, 20), (64, 20), (72, 20), (90, 20)
        -- space for 5 items, as needed (with nice borders)
        for i = 1, #self.inventory do
            x = 24 + (i * 12)
            y = 100
            self.inventory[i]:draw(x, y)
        end
    end
end

-- transfers collision box draw signal
function class_player:draw_collision_box()
    self.collision_box:draw()
end

-- creates a projectile
function class_player:shoot()
    if self.reload_value == 0 and self.battery > 20 then
        local offsets = {
            {x = 2, y = -1}, -- left
            {x = -3, y = -1}, -- right
            {x = -1, y = 2}, -- up
            {x = -1, y = -4}, -- down
            {x = 0, y = -3},  -- up left
            {x = 4, y = -3},  -- up right
            {x = 1, y = -4},  -- down left
            {x = 3, y = -4}   -- down right
        }

        local offset = offsets[self.dir + 1]
        add(player_proj_list, class_projectile:new(self, self.x+offset.x,self.y+offset.y,self.dir,6,self.colour, 80))
        
        self.battery -= 1
        if self.battery <= 20 then
            self.colour = 1
            self.battery = 0
        end
        self.reload_value = self.reload_speed
    end
end

function class_player:room_transfer(dx, dy)
    -- save all data for the previous room
    dungeon[p.current_room_y][p.current_room_x][2] = walls
    dungeon[p.current_room_y][p.current_room_x][3] = enemies

    self.current_room_x += dx
    self.current_room_y += dy

    -- if no walls in room (not generated then generate
    if #dungeon[self.current_room_y][self.current_room_x][2] == 0 then
        generate_room_from_index(dungeon, p.current_room_y, p.current_room_x)
    end

    -- put new shit
    walls = dungeon[self.current_room_y][self.current_room_x][2]
    enemies = dungeon[self.current_room_y][self.current_room_x][3]

end