-- to check tokens type: INFO

-- May god help you
--              (c) Artem

screen_size = 128 -- screen is cube 128 by 128, used to delete bullets that are outside screen


--walls = {}
--enemies = {}

player_proj_list = {}
enemy_proj_list = {}

dungeon = {}
snapshot = {{}, {}}

dead = false
entry_delay = 45 -- timer after entering room, before enemies can move.
-- debug toggles

debug_mode = true
collision_box_toggle = false


-- executes on startap
function _init()
    entry_delay = 45
    dead = false
    log("Game has started")

    if debug_mode then
        -- allow full keyboard input
        -- ONLY IN DEV MODE. BAD BAD BAD DO NOT USE THIS FOR ACTUAL INPUT
        poke(0x5F2D, 1)
    end

    -- initialise player
    p = class_player:new(tile_to_pixel(3), tile_to_pixel(3), 6, 6)

    dungeon = generate_dungeon(6, 4)

    -- Print dungeon grid
    log("dungeon structure: ")
    for y = 1, #dungeon do
        local row = ""
        for x = 1, #dungeon[y] do
            if dungeon[y][x] == 0 then
                row = row .. " 0 "
            else
                row = row .. " 1 "
            end
        end
        log(row)
    end

    generate_room_from_index(dungeon, p.current_room_y, p.current_room_x)

    -- to get room data for dungeon[p.current_room_y][p.current_room_x][2] is going to return walls, [3] going to return enemies
    -- make level and shit
    --local left_room = create_room(12, "e", 6)
    --local right_room = create_room(12, "w", 6)

    --setup_walls(dungeon[p.current_room_y][p.current_room_x][2], left_room)
    --setup_walls(dungeon[p.current_room_y][p.current_room_x+1][2], right_room)

    
    --setup_enemies(dungeon[p.current_room_y][p.current_room_x][3])
    --setup_enemies(dungeon[p.current_room_y][p.current_room_x+1][3])

    walls = dungeon[p.current_room_y][p.current_room_x][2]
    enemies = dungeon[p.current_room_y][p.current_room_x][3]

end 

-- draw every frame
function _draw()
    if dead then
        _init()
    end

    cls()
    p:draw()


    for i = 1, #walls do
        walls[i]:draw()
    end

    paused = showing_inventory -- add other things too later

    for i = 1, #player_proj_list do
        if not paused then
            player_proj_list[i]:update()
        end
    
    end

    kill_dead_enemies()
    
    -- delete projectiles before updating them
    for i = 1, #delete_queue do
        del(player_proj_list, delete_queue[1])
        del(enemy_proj_list, delete_queue[1])
        del(delete_queue, delete_queue[1])
    end

    for j = 1, #player_proj_list do
        player_proj_list[j]:draw()
    end


    -- update enemies
    for i = 1, #enemies do
        if not paused then
            if entry_delay == 0 then
                enemies[i]:update()
            else
                entry_delay -= 1
            end
        end
        if enemies[i] is not nil:
            -- enemies could be deleted during update()
            enemies[i]:draw()
            enemies[i]:draw_hp_bar()
        end
    end

    -- update enemy projectiles
    for j = 1, #enemy_proj_list do
        if not paused then
            enemy_proj_list[j]:update()
        end
        enemy_proj_list[j]:draw()
    end

    p:draw_inventory()
    p:draw_hp_bar()

    -- debug shit
    if collision_box_toggle then
        p:draw_collision_box()

        for i = 1, #walls do
            walls[i]:draw_collision_box()
        end

        for i = 1, #enemies do
            enemies[i]:draw_collision_box()
        end

        for i = 1, #player_proj_list do
            player_proj_list[i]:draw_collision_box()
        end
    
        for i = 1, #enemy_proj_list do
            enemy_proj_list[i]:draw_collision_box()
        end

    end
end 