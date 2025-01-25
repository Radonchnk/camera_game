-- to check tokens: INFO

-- I love global variables
--              (c) Artem

function _init()
    log("Game has started")
    poke(0x5f2d, 1)

    -- innitialise player
    p = player:new(64, 64)

end 

function _draw()
    p:draw()
end 