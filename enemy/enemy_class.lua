-- define a "class" (table)
class_enemy = {}
class_enemy.__index = class_enemy


-- constructor
function class_enemy:new(x, y, width, height, name)
    local obj = setmetatable({}, self)

    -- used to check who owns projectile
    obj.name = name

    obj.x = x
    obj.y = y

    obj.max_health_points = 10
    obj.health_points = 10

    obj.speed = 1
    obj.base_spr = 8
    obj.dir = 1

    -- can shoot every 10 sframes
    self.reload_speed = 10
    self.reload_value = 0

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)

    return obj
end

function class_enemy:rotate(direction)
    if direction == "left" then
        self.dir = 0
        self.base_spr = 10
    elseif direction == "right" then
        self.dir = 1
        self.base_spr = 8
    elseif direction == "up" then
        self.dir = 2
        self.base_spr = 9
    elseif direction == "down" then
        self.dir = 3
        self.base_spr = 11
    end
end
-- method to move the enemy
function class_enemy:move(dx, dy)

    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)

    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_player = collision_to_list(self, {p}, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_player == 2 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)
    end

    -- takes some amount of frames to reload
    if self.reload_value > 0 then
        self.reload_value -= 1
    end
end


-- enemy ai and actions
function class_enemy:update()
    -- calculate distance to player
    local dx = p.x - self.x
    local dy = p.y - self.y
    local distance = sqrt(dx^2 + dy^2)

    -- move towards the player if the distance is greater than a threshold
    if distance > 32 then
        -- normalize the direction vector and move
        local dir_x = dx / distance
        local dir_y = dy / distance
        self:move(dir_x, dir_y)
    end
    -- rotate towards player
    if abs(dx) > abs(dy) then
        if dx > 8 then
            self:rotate("right")
        elseif dx < -8 then
            self:rotate("left")
        end
    else
        if dy > 8 then
            self:rotate("down")
        elseif dy < -8 then
            self:rotate("up")
        end
    end

    -- shoot at the player if close enough
    if distance <= 64 then
        self:shoot()
    end

    -- takes some amount of frames to reload
    if self.reload_value ~= 0 then
        self.reload_value -= 1
    end
end

function class_enemy:draw_hp_bar()
    rectfill(self.x-3, self.y-2, self.x+10-3, self.y-2, 5)
    rectfill(self.x-3, self.y-2, self.x+flr(self.health_points/self.max_health_points*10)-3, self.y-2, 8)
end

function class_enemy:process_death()
    --log("enemy death")
    self.health_points = self.max_health_points
    p.kill_count += 1
    log("Kill count: " .. p.kill_count)
end

function class_enemy:take_damage(damage)
    self.health_points -= damage

    if self.health_points < 1 then
        self:process_death()
    end

end

-- method to draw the enemy
function class_enemy:draw()
    spr(self.base_spr, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function class_enemy:draw_collision_box()
    self.collision_box:draw()
end

function class_enemy:shoot()
    if self.reload_value == 0 then
        add(enemy_proj_list, class_projectile:new(self, self.x, self.y, self.dir, 6, 6, 50))
        self.reload_value = self.reload_speed
    end
end