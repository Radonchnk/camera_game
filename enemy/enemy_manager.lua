-- general enemy spawn function
function spawn_enemy(type, spawn_x, spawn_y)
    if type == "turret" then
        return class_enemy:new(spawn_x, spawn_y, 8, 6, 0, 8, 1, 100, 100, 70, type)
    elseif type == "melee" then
        return class_enemy:new(spawn_x, spawn_y, 8, 8, 1, 12, -1, 50, 10, 100, type)
    end
end

-- delete dead enemies
function kill_dead_enemies()
    for i = 1, #dead_enemies do
        del(dungeon[p.current_room_y][p.current_room_x][3], dead_enemies[i])
        del(dead_enemies, dead_enemies[1])
    end
end