function camera_follow()
    cam_x = p.x-60
    cam_y = p.y-60

    cam_x = mid(0,cam_x,896)
    cam_y = mid(0,cam_y,128)

    camera(cam_x,cam_y)
end