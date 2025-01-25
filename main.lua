-- to check tokens type: INFO

-- May god help you
--              (c) Artem

-- debug toggles
debug_mode = 1
colission_box_toggle = 1

function _init()
    log("Game has started")
    poke(0x5f2d, 1)

    -- innitialise player
    p = player:new(64, 64)

end 

-- draw every frame
function _draw()
    cls()
    p:draw()

    -- debug shit
    if colission_box_toggle == 1 then
        p:draw_colission_box()
    end
end 