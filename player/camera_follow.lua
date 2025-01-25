-- makes pico 8 camera track player
function camera_follow()
    -- centre camera position
    cam_x = p.x-60
    cam_y = p.y-60

    -- moves camera to stay in bounds of map
    cam_x = mid(0,cam_x,896)
    cam_y = mid(0,cam_y,128)

    -- gives position to camera
    camera(cam_x,cam_y)
end