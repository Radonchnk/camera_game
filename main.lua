-- to check tokens: INFO

-- I love global variables
--              (c) Artem

player_pos_x=64
player_pos_y=64

movement_speed=1


function _init()
    log("Game has started")
    poke(0x5f2d, 1)
end 

function _update()
    local key = stat(31)
    
    if key ~= "" then
        log("Key pressed: " .. key)
    end
    
    if key == "c" then
        cls()
    end

    if (btn(0)) then
        player_pos_x-=movement_speed    --left
        log("left")
    end
    if (btn(1)) then
        player_pos_x+=movement_speed    --right
        log("right")
    end
    if (btn(2)) then
        player_pos_y-=movement_speed    --up
        log("up")
    end
    if (btn(3)) then
        player_pos_y+=movement_speed    --down
        log("down")    
    end
end

function _draw()
    pset(player_pos_x, player_pos_y, 12)
end 