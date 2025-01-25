-- to check tokens type: INFO

-- May god help you
--              (c) Artem

-- debug toggles


debug_mode = 1
collision_box_toggle = 1


-- executes on startap
function _init()
    log("Game has started")

    -- enter devkit mode to accept keyboard inputs
    poke(0x5f2d, 1)

    -- innitialise player
    p = player:new(tile_to_pixel(1), tile_to_pixel(1), 10, 6)

    -- make level and shit
    setup_walls()

    setup_enemies()

end 

-- draw every frame
function _draw()
    camera_follow()
    cls()
    p:draw()

    for i = 1, #player_proj_list do
        player_proj_list[i]:update()
        player_proj_list[i]:draw()
    end

    for i = 1, #enemies do
        enemies[i]:update()
        enemies[i]:draw()
    end

    
    for i = 1, #walls do
        walls[i]:draw()
    end

    -- debug shit
    if collision_box_toggle == 1 then
        p:draw_collision_box()

        for i = 1, #walls do
            walls[i]:draw_collision_box()
        end

        for i = 1, #enemies do
            enemies[i]:draw_collision_box()
        end
    end
end 