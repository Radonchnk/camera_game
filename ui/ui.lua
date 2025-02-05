function draw_ui()
    -- draw film icon and value
    spr(18, 0, 0, 1, 1)
    print(p.film, 8, 1, 11)

    -- draw snapshot indicator
    if #snapshot[1] > 0 then
        if in_snapshot then
            spr(34, 0, 8, 1, 1) -- loaded snapshot icon
        else
            spr(33, 0, 8, 1, 1) -- unloaded snapshot icon
        end
    end

    -- write snapshot acknowledgement
    if text_timer > 0 then
        print(display_text, 9, 9, 7)
        text_timer -= 1
    end
end

function draw_death_screen()
    cls()
    print("you died", 50, 50, 8)
    print("z - new run", 45, 70, 7)
end

function draw_win_screen()
    cls()
    print("you win!", 50, 50, 11)
    print("z - new run", 45, 70, 7)
end

title_delay = 0
title_colour_toggle = false
function draw_title_screen()
    cls()

    -- title animation
    local gap = -13
    if title_delay < 5 then
        gap = -12
    end
    for col=13,1,gap do
		for i=1,8 do
			t1 = t()*60 + i*4 - col*2
			x = 24+i*8     +cos(t1/90)*2
			y = 24+(0.5*col-7)+cos(t1/50)*2
			pal(13,col)
            if i == 7 and title_colour_toggle then
			    spr(57, x, y)
            else
                spr(48+i, x, y)
            end
		end
    end

    -- flashing shadow and colour switch
    if title_delay == 31 then
        title_colour_toggle = not title_colour_toggle
        title_delay = 0
    else
        title_delay += 1
    end

    print("z - start game", 35, 60, 12)

    print("controls", 48, 80, 6)

    print("z - interact", 40, 90, 6)
    print("x - shoot beam", 36, 100, 6)
    print("y - take snapshot", 30, 110, 6)
    print("u - load snapshot", 30, 120, 6)

 end