-- to check tokens type: INFO

-- May god help you
--              (c) Artem

-- debug toggles


debug_mode = 1
colission_box_toggle = 1


-- executes on startap
function _init()
    log("Game has started")

    -- enter devkit mode to accept keyboard inputs
    poke(0x5f2d, 1)

    -- innitialise player
    p = player:new(tile_to_pixel(1), tile_to_pixel(1))

    -- make level and shit
    setup_level()

    --log(walls)

end 

-- draw every frame
function _draw()
    cls()
    p:draw()
    camera_follow()
    for i = 1, #walls do
        walls[i]:draw()
    end

    -- debug shit
    if colission_box_toggle == 1 then
        p:draw_colission_box()

        for i = 1, #walls do
            walls[i]:draw_colission_box()
        end
    end
end 