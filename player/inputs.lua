function _update()
    -- player movemens
    if btn(0) then 
        p:move(-1, 0)   -- left
        log("move left")
    end

    if btn(1) then 
        p:move(1, 0)    -- right
        log("move right")
    end

    if btn(2) then 
        p:move(0, -1)   -- up
        log("move up")
    end 

    if btn(3) then 
        p:move(0, 1)    -- down
        log("move down")
    end  
    

    -- player keyboard inputs
    local key = stat(31)
    if key ~= "" then
        log("Key pressed: " .. key)
    end
    
    if key == "c" and debug_mode == 1 then
        if colission_box_toggle == 1 then
            colission_box_toggle = 0
            log("Colission boarders: OFF")
        else
            colission_box_toggle = 1
            log("Colisiion boarders: ON")
        end
    end
end