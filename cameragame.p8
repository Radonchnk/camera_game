pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- add includes onyly in
-- pico8 redactor
--buttons ⬅️➡️⬆️⬇️

#include main.lua
#include player/inputs.lua
#include utils/utils.lua
#include utils/collision_engine.lua
#include player/item.lua
#include player/player_class.lua
#include utils/tiling.lua
#include map/wall_class.lua
#include map/level_setup.lua
#include projectile/projectile_class.lua
#include enemy/enemy_class.lua
#include enemy/enemy_manager.lua
#include items/item_classes.lua
#include ui/ui.lua
__gfx__
0116d0000500500000d611000611600000016d000111000000d6100000001110204200000a000000000024022400420000004440099009900444000000044000
6d5d555005005000555d5d601d11d1000115d5000dd65d00005d511000d56dd04244444a04009000094444240244200000422009400000049002240000489400
11d50000d5005d000005d11015dd510006dd5000111d65500005dd600556d1110498000004004000000098404489440004440a0940a00a0490a0444004498440
11d500006d55d6000005d1106d55d600611d5505611d55055055d1165055d1160489000004004000000089402498420049800000420000240000098402400420
6d5d555015dd5100555d5d60d5005d00111d655006dd50000556d1110005dd604244449024894200a44444240400400048900000024004200000089442000024
0116d0001d11d10000d61100050050000dd65d000115d50000d56dd0005d51102042000044984400000024020400400004440a090448944090a0444040a00a04
000000000611600000000000050050000111000000016d000000111000d610000000000002442000000000000900400000422009004984009002240040000004
00000000000000000000000000000000000000000000000000000000000000000000000024004200000000000000a00000004440000440000444000009900990
000a0000000000000066600000000000000000000000000000000000000000000090090000000000000000000000000000000000000000000000000000000000
0022420000e00e000665660000080000000800000008000000090000000000000a0900a800000000000000000000000000000000000000000000000000000000
020420200e0000e0656665600080800000808000008090000080000000900000900a050900000000000000000000000000000000000000000000000000000000
0402404000088000666566600555080005550900055500000555000005550000a900a00000000000000000000000000000000000000000000000000000000000
40244204000880006566656056555090565550005655500056555000565550000000009000000000000000000000000000000000000000000000000000000000
404894040e0000e006656600555550005555500055555000555550005555500090a50a0900000000000000000000000000000000000000000000000000000000
0449844000e00e000066600055555000555550005555500055555000555550000800900000000000000000000000000000000000000000000000000000000000
0024420000000000000555550555000005550000055500000555000005550000009a090000000000000000000000000000000000000000000000000000000000
94400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49922994000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49822894000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022aa220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022aa220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49822894000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49922994000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94400449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
911200000c04300000000000c043000000000000000000000000000000000000000000000000000c0430c0430c04300000000000c04300000000000000000000000000000000000000000000000000000000c023
911200000313503105031050313503105001050010500105001050010500105001050010500105031350313303135031050310503135001050010500105001050010500105001050010500105001050010503133
cf12000001611036110061104611026110461103611046110a6110e61110621126310261100611046110161102611056110661102611006110161106611026110161103611006110561100611026110261105611
491200000c04300000000000c04300000000000c023000002461300000000000000000000000000c0430c0430c04300000000000c04300000000000c02300000246130c04300000000000c043000000c02300000
0112000003135031050310503135031050010503113031150d7110f01503015001050f01303013031350313303135061150310503135001050811503115031130f71112015030150010514013030130313503133
cf12000001611036110061104611026110461103611046110a6110e61110621126310261100611046110161102611056110661102611006110161106611026110161103611006110561100611026110261105611
011200000c0433d7053f7050c04331005330050c023250052461325005270052700525005270050c0430c0430c0433d0053f0050c04331005330050c02325005246130c043270052a0050c0432a0050c0232c005
0112000003145031050310503145031050010503123031250d7210f02503025001050f02303023031450314303145061250310503145001050812503125031130f72112025030250010514023030230314503143
411000000c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c0161001613026170260c016100161302617026
411000001001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a0261001613016170261a026
411000000c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f01613026160260c0160f0161302616026
4110000013016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d02613016160161a0261d026
011000000c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c0730005000050000500c073000500005000050
011000000c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c0730405004050040500c073040500405004050
011000000c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c0730705007050070500c073070500705007050
011000000033000320003100031518640186201861500005003320032000310003151864018620186150000500330003200031000315186401862018615000050033000320003100031502330023200231002315
001000000433004320043100431518640186201861500005043300432004310043151864018620186150000504330043200431004315186401862018615000050433004320043100431506330063200631006315
011000000733007320073100731518640186201861500005073300732007310073151864018620186150000507330073200731007315186401862018615000050733007320073100731509330093200931009315
411000000c0161001613026170260c0001000013000170000c0161001613026170260c0161001613026170260c0161001613026170260c0001000013000170000c0161001613026170260c016100161302617026
411000001001613016170261a0261000013000170001a0001001613016170261a0261001613016170261a0261001613016170261a0261000013000170001a0001001613016170261a0261001613016170261a026
411000000c0160f01613026160260c0000f00013000160000c0160f01613026160260c0160f01613026160260c0160f01613026160260c0000f00013000160000c0160f01613026160260c0160f0161302616026
4110000013016160161a0261d02613000160001a0001d00013016160161a0261d02613016160161a0261d02613016160161a0261d02613000160001a0001d00013016160161a0261d02613016160161a0261d026
011000000c0730005000050000500c0730000000000000000c0730005000050000500c0730005000170000500c0730005000050000500c0730000000000000000c0730005000050000500c073000500017000550
011000000c0730405004050040500c0730400004000040000c0730405004050040500c0730405004170040500c0730405004050040500c0730400004000040000c0730405004050040500c073040500417004550
011000000c0730705007050070500c0730700007000070000c0730705007050070500c0730705007170070500c0730705007050070500c0730700007000070000c0730705007050070500c073070500717007550
011700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031110f1111b111
01170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000246151e620
0117000003073030000306503562030000306503562080650307303000030650356203000065550b062100650307303000030650356203000030650356208065030730d052080650355204065095550e05213055
011700001b1121b1101b1101b1101b1121b1121b1121b1121b1111a1111b1111a1111b1111a1111b1111a1111b1111a1111b1111b1121b1121b1121b1121b1121b1121b1121b1121b1111c1111d1111e11120111
011700000c0030f053246250f053000000f053246250f0530c0030f053246250f053000000f053246151e6200c0030f053246250f053000000f053246250f053000000f053246250f05324625246250f0531e620
0117000008073030000806508562030000806508562090650807303000080650856203000095550e062075650307303000030650356203000030650356208065030730d052080650355204065095550e05213055
01170000201101f1112011120110201122011220112201122011221115201151b1251612510125151251a1251b1101a1111b1111b1101b1121b1121b1121b1121b1121b1121b1121b1121b1121b1121b1121b112
__music__
03 08090a41
03 0b0c0d44
03 0e0f4c4d
01 10144344
00 11154344
00 12144344
00 13164344
01 10141754
00 11151855
00 12141754
00 13161956
00 1a1e1754
00 1b1f1855
00 1c1e1754
02 1d201956
01 23214344
00 23244350
00 26274322
00 23424025
02 26424325

