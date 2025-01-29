-- define a "class" (table)
class_player = {}
class_player.__index = class_player

-- these are lists, i promise


showing_inventory = false

player_proj_list = {}

-- constructor
function class_player:new(x, y, width, height)
    local obj = setmetatable({}, self)

    obj.inventory = {}

    -- TODO: remove
    for i=1, 5 do
        add(obj.inventory, class_item:new(1))
    end
    obj.x = x
    obj.y = y
    obj.speed = 2
    obj.base_spr = 0
    obj.dir = 1
    obj.colour = 9

    -- can shoot every frame
    obj.reload_speed = 0
    obj.reload_value = 0

    obj.name = "player"

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

-- method to move the player
function class_player:move(dx, dy)
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

    -- takes some amount of frames to reload
    if self.reload_value > 0 then
        self.reload_value -= 1
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
    if self.reload_value == 0 then
        local offsets = {
            {x = -4, y = 0}, -- left
            {x = 12, y = 0}, -- right
            {x = 4, y = -4}, -- up
            {x = 4, y = 4}, -- down
            {x = 0, y = -4},  -- up left
            {x = 12, y = -4},  -- up right
            {x = -4, y = 4},  -- down left
            {x = 12, y = 4}   -- down right
        }

        local offset = offsets[self.dir + 1]
        log(self.colour)
        add(player_proj_list, class_projectile:new(self, self.x+offset.x,self.y+offset.y,self.dir,6,self.colour, 80))
        self.reload_value = self.reload_speed
    end
end