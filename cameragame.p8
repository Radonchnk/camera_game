pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- add includes onyly in
-- pico8 redactor
--	buttons ⬅️➡️⬆️⬇️

#include main.lua
#include player/inputs.lua
#include utils/log.lua
#include utils/collision_engine.lua
#include player/player_class.lua
#include utils/tiling.lua
#include map/shit.lua
#include map/level_setup.lua


--#include main.lua
__gfx__
44444444000110000000110000001100000011000000110000010000000100000000100000001000000000000000000000000000000000000000000000000000
444444440f66111100f6611100f6611100f6611100f6611100101000000100000001010000001000000000000000000000000000000000000000000000000000
44444444f55ddd000f55ddd00f55ddd00f55ddd00f55ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445bbd7000050bd7000500d7000500d7000500d70000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445bbd700005bbd70005bbd700050bd7000500d70000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444f55ddd000f55ddd00f55ddd00f55ddd00f55ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444440f66111100f6611100f6611100f6611100f6611100000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444001110000001110000011100000111000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010000100100001001000010010000100100001000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001d00d1001d00d1001d00d1001d00d1001d00d1000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011d77d1111d77d1111d77d1111d77d1111d77d1100000000000000000100000000000000000000000000000000000000000000000000000000000000
0000000016dddd6116dddd6116dddd6116dddd6116dddd6101000000000000001000000011000000000000000000000000000000000000000000000000000000
00000000065bb561065bb5610650b561065b05610650056110000000110000000100000000000000000000000000000000000000000000000000000000000000
000000000f5bb5f00f50b5f00f50b5f00f5bb5f00f5005f001000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f55f0000f55f0000f55f0000f55f0000f55f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001110000011100000111000001110000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011166f0011166f0011166f0011166f0011166f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddd55f00ddd55f00ddd55f00ddd55f00ddd55f000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007dbb50007db050007d0050007d0050007d005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007dbb50007dbb50007dbb50007db050007d005000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddd55f00ddd55f00ddd55f00ddd55f00ddd55f000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011166f0011166f0011166f0011166f0011166f0000101000000100000001010000001000000000000000000000000000000000000000000000000000
00000000001100000011000000110000001100000011000000010000000100000000100000001000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f55f0000f55f0000f55f0000f55f0000f55f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000f5bb5f00f5b05f00f5b05f00f5005f00f5005f000000010000000000000000000000000000000000000000000000000000000000000000000000000
00000000165bb560165bb560165b0560165b05601650056000000001000000110000001000000000000000000000000000000000000000000000000000000000
0000000016dddd6116dddd6116dddd6116dddd6116dddd6100000010000000000000000100000011000000000000000000000000000000000000000000000000
0000000011d77d1111d77d1111d77d1111d77d1111d77d1100000000000000000000001000000000000000000000000000000000000000000000000000000000
0000000001d00d1001d00d1001d00d1001d00d1001d00d1000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010000100100001001000010010000100100001000000000000000000000000000000000000000000000000000000000000000000000000000000000
