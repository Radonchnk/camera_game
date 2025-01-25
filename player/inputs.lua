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
    
    if key == "c" then
        cls()
    end
end