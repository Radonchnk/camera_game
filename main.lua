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

    paused = showing_inventory -- add other things too later

    for i = 1, #player_proj_list do
        if not paused then
            player_proj_list[i]:update()
        end
        player_proj_list[i]:draw()
    end

    for i = 1, #enemy_proj_list do
        if not paused then
            enemy_proj_list[i]:update()
        end
        enemy_proj_list[i]:draw()
    end

    for i = 1, #enemies do
        if not paused then
            enemies[i]:update()
        end
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
    end
end 