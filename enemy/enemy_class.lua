-- define a "class" (table)
class_enemy = {}
class_enemy.__index = class_enemy
dead_enemies = {}


-- constructor
function class_enemy:new(x, y, width, height, base_speed, base_spr, reload_speed, burst, accuracy, max_hp, agility, loot_choices, loot_chances, type)
    local obj = setmetatable({}, self)

    -- what type of enemy is this (turret, melee)
    obj.name = type

    obj.x = x
    obj.y = y

    obj.max_health_points = max_hp
    obj.health_points = max_hp

    obj.accuracy = accuracy  -- 0 -> 100, how correctly enemy pathfinds
    obj.agility = agility  -- 0 -> 100, how fast enemy rotates
    obj.rotate_now = false  -- rotates on every reload

    obj.speed = base_speed
    obj.base_spr = base_spr
    obj.spr = base_spr
    obj.dir = 1
    
    -- can shoot every [reload_speed] frames
    -- can shoot multiple projectiles before reloading
    obj.per_reload = burst
    obj.proj_counter = 0
    obj.reload_speed = reload_speed
    obj.reload_value = reload_speed

    obj.width = width or 8
    obj.height = height or 8
    
    obj.collision_box = class_collision_entity:new(x,y,obj.width,obj.height)

    -- loot table
    obj.loot = loot_choices
    obj.probabilities = loot_chances

    -- melee attack cooldown
    obj.cooldown = 1
    obj.cooldown_timer = 0
    return obj
end

function class_enemy:rotate(direction)
    if direction == "left" then
        self.dir = 0
        self.spr = self.base_spr + 2
    elseif direction == "right" then
        self.dir = 1
        self.spr = self.base_spr
    elseif direction == "up" then
        self.dir = 2
        self.spr = self.base_spr + 1
    elseif direction == "down" then
        self.dir = 3
        self.spr = self.base_spr + 3
    end

    self.rotation_timer = 100 - self.agility
end
-- method to move the enemy
function class_enemy:move(dx, dy)
    --log(self.health_points)
    --log(self.max_health_points)
    --log("---")
    self.x += dx * self.speed
    self.y += dy * self.speed
    self.collision_box:offset(dx * self.speed,  dy * self.speed)

    -- check player against walls & enemies 
    collision_walls = collision_to_list(self, walls, 16)
    collision_player = collision_to_list(self, {p}, 16)
    collision_enemies = collision_to_list(self, enemies, 16)

    -- when object collides, size of fuction return is 2 because object is being passed too
    if #collision_walls == 2 or #collision_player == 2 or #collision_enemies == 2 then
        self.x -= dx * self.speed
        self.y -= dy * self.speed
        self.collision_box:offset(-dx * self.speed, -dy * self.speed)

        -- knocks player back and deals damage
        if self.name ~= "turret" and #collision_player == 2 and self.cooldown_timer == 0 then
            p:take_damage(5)
            if self.dir == 0 then
                p:update(-2, 0)
                self.x += 2
                self.collision_box:offset(2,  0)
            elseif self.dir == 1 then
                p:update(2, 0)
                self.x -= 2
                self.collision_box:offset(-2,  0)
            elseif self.dir == 2 then
                p:update(0, -2)
                self.y += 2
                self.collision_box:offset(0,  2)
            elseif self.dir == 3 then
                p:update(0, 2)
                self.y -= 2
                self.collision_box:offset(0,  -2)
            end
        end

        if self.cooldown_timer == self.cooldown then
            self.cooldown_timer = 0
        else
            self.cooldown_timer += 1
        end
    end

    -- takes some amount of frames to reload
    if self.reload_value > 0 then
        self.reload_value -= 1
    end
end


-- enemy ai and actions
function class_enemy:update()
    -- random movement
    local error = {0, 0}

    if rnd(101) > self.accuracy then
        error = {16-flr(rnd(32)),16-flr(rnd(32))}
    end

    -- calculate distance to player
    local dx = p.x - self.x + error[1]
    local dy = p.y - self.y + error[2]
    local distance = sqrt(dx^2 + dy^2)

    -- move towards the player if the distance is greater than a threshold
    if distance > 8 then
        -- normalize the direction vector and move
        local dir_x = (dx / distance) + error[1]/12
        local dir_y = (dy / distance) + error[2]/12
        self:move(dir_x, dir_y)
    end
    -- rotate towards player
    if self.rotate_now or self.name == "melee" then
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
        self.rotate_now = false
    end

    -- shoot at the player if close enough
    if distance <= 128 then
        self:shoot()
    end

    -- takes some amount of frames to reload
    if self.reload_value > 0 then
        self.reload_value -= 1
    end
end

function class_enemy:draw_hp_bar()
    if self.name == "melee" then
        log(self.name)
        log(self.health_points)
        log(self.max_health_points)
        log("----")
    end
    rectfill(self.x-3, self.y-2, self.x+10-3, self.y-2, 5)
    rectfill(self.x-3, self.y-2, self.x+flr(self.health_points/self.max_health_points*10)-3, self.y-2, 8)
end

function class_enemy:process_death()
    add(dead_enemies, self, #dead_enemies+1)
    p.kill_count += 1
    p.battery = 100

    -- loot generation
    local ranges = {}
    local temp = 0
    for i = 1, #self.loot do
        add(ranges,{temp,self.probabilities[i]+temp},#ranges+1)
        temp += self.probabilities[i]
    end
    local rng = rnd(100)
    for i = 1, #ranges do
        if ranges[i][1] < rng and rng < ranges[i][2] then
            add(items,class_effect_item:new(self.x, self.y, self.loot[i]))
        end
    end 
end

function class_enemy:take_damage(damage)
    self.health_points -= damage

    if self.health_points < 1 then
        self:process_death()
    end

end

-- method to draw the enemy
function class_enemy:draw()
    spr(self.spr, self.x, self.y, 1, 1)
end

-- transfers collision box draw signal
function class_enemy:draw_collision_box()
    self.collision_box:draw()
end

function class_enemy:shoot()
    if self.reload_value == 0 then
        if self.proj_counter < self.per_reload then
            self.proj_counter += 1
        else
            self.reload_value = self.reload_speed
            self.proj_counter = 0
            self.rotate_now = true
        end
        add(enemy_proj_list, class_projectile:new(self, self.x, self.y, self.dir, 6, 6, 50))
    end
end