-- to check tokens type: INFO

-- May god help you
--              (c) Artem

screen_size = 128 -- screen is cube 128 by 128, used to delete bullets that are outside screen
-- debug toggles


debug_mode = true
collision_box_toggle = false


-- executes on startap
function _init()
    log("Game has started")

    if debug_mode then
        -- allow full keyboard input
        -- ONLY IN DEV MODE. BAD BAD BAD DO NOT USE THIS FOR ACTUAL INPUT
        poke(0x5F2D, 1)
    end

    -- innitialise player
    p = class_player:new(tile_to_pixel(3), tile_to_pixel(3), 6, 6)

    dungeon = generate_dungeon()

    -- make level and shit
    local left_room = create_room(12, "e", 5)
    local right_room = create_room(12, "w", 5)

    setup_walls(left_room)

    setup_enemies()

end 

-- draw every frame
function _draw()
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

    -- delete projectiles from player before drawing them
    for i = 1, #delete_queue do 
        log(i)
        del(player_proj_list, delete_queue[1])
        del(delete_queue, delete_queue[1]) 
    end

    for j = 1, #player_proj_list do
        player_proj_list[j]:draw()
    end



    for i = 1, #enemies do
        if not paused then
            enemies[i]:update()
            for j = 1, #enemy_proj_list do
                if not paused then
                    enemy_proj_list[j]:update()
                end
            end
        end
        enemies[i]:draw()
        
        -- delete projectiles from enemy before drawing them
        for i = 1, #delete_queue do 
            del(enemy_proj_list, delete_queue[1])
            del(delete_queue, delete_queue[1]) 
        end

        for j = 1, #enemy_proj_list do
            enemy_proj_list[j]:draw()
        end
    end

    p:draw_inventory()

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