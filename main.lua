-- to check tokens: INFO

-- I love global variables
--              (c) Artem
key = 0 

player_pos_x=64
player_pos_y=64

movement_speed=1

function _init()
    log("Game has started")
end 

function _update()
    key = stat(97)

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
    log(key)
    if (key == 99) then -- 99 is ASCII for c
        cls()
        log(cleared)
    end
    pset(player_pos_x, player_pos_y, 12)
end 