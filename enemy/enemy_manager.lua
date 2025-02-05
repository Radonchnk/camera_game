-- general enemy spawn function
function spawn_enemy(type, spawn_x, spawn_y)
    -- class_enemy:new(x, y, width, height, base_speed, base_spr, reload_speed, burst, accuracy, max_hp, agility, loot_choices, loot_chances, type)
    if type == "turret" then
        return class_enemy:new(spawn_x, spawn_y, 8, 6, 0, 8, 45, 30, 100, 75, 80, {"health", "film"}, {50, 50}, type)
    elseif type == "melee" then
        if boss_fight then
            return class_enemy:new(spawn_x, spawn_y, 8, 8, 1, 12, 30, 10, 80, 10, 100, {"health", "explosive"}, {50,50}, type)
        else
            return class_enemy:new(spawn_x, spawn_y, 8, 8, 1, 12, -1, -1, 50, 10, 100, {"health", "explosive", "film"}, {40, 20, 20}, type)
        end
    elseif type == "loot pot" then
        return class_enemy:new(spawn_x, spawn_y, 8, 8, 0, 16, -1, -1, -1, 5, -1, {"health", "film"}, {20, 60}, type)
    end
end

-- delete dead enemies
function kill_dead_enemies()
    for i = 1, #dead_enemies do
        del(dungeon[p.current_room_y][p.current_room_x][3], dead_enemies[i])
        del(dead_enemies, dead_enemies[1])
    end
end