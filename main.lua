-- to check tokens type: INFO

-- May god help you
--              (c) Artem

-- debug toggles


debug_mode = true
collision_box_toggle = true


-- executes on startap
function _init()
    log("Game has started")

    -- innitialise player
    p = player:new(tile_to_pixel(1), tile_to_pixel(1), 10, 6)

    -- make level and shit
    setup_walls()

    setup_enemies()

end 

-- draw every frame
function _draw()
    cls()
    p:draw()

    for i = 1, #player_proj_list do
        player_proj_list[i]:update()
        player_proj_list[i]:draw()
    end

    for i = 1, #enemy_proj_list do
        enemy_proj_list[i]:update()
        enemy_proj_list[i]:draw()
    end

    -- delete colided projectiles from all lists
    for i = 1, #delete_queue do
        del(player_proj_list, delete_queue[i])
        del(enemy_proj_list, delete_queue[i])
    end

    -- clear deleating queue
    for i = 1, #delete_queue do
        del(delete_queue, delete_queue[1])
    end

    for i = 1, #enemies do
        enemies[i]:update()
        enemies[i]:draw()
    end

    for i = 1, #walls do
        walls[i]:draw()
    end

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