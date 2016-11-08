//
//  SpaceGroupHallTable.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/05/30.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func spacegroupHallToSymopIndex(_ name:String) -> (Int,Int)? {
    switch name {
    case "P 1":
        return (1,1)
    case "-P 1":
        return (2,1)
    case "P 2y":
        return (3,1)
    case "P 2":
        return (3,2)
    case "P 2x":
        return (3,3)
    case "P 2yb":
        return (4,1)
    case "P 2c":
        return (4,2)
    case "P 2xa":
        return (4,3)
    case "C 2y":
        return (5,1)
    case "A 2y":
        return (5,2)
    case "I 2y":
        return (5,3)
    case "A 2":
        return (5,4)
    case "B 2":
        return (5,5)
    case "I 2":
        return (5,6)
    case "B 2x":
        return (5,7)
    case "C 2x":
        return (5,8)
    case "I 2x":
        return (5,9)
    case "P -2y":
        return (6,1)
    case "P -2":
        return (6,2)
    case "P -2x":
        return (6,3)
    case "P -2yc":
        return (7,1)
    case "P -2yac":
        return (7,2)
    case "P -2ya":
        return (7,3)
    case "P -2a":
        return (7,4)
    case "P -2ab":
        return (7,5)
    case "P -2b":
        return (7,6)
    case "P -2xb":
        return (7,7)
    case "P -2xbc":
        return (7,8)
    case "P -2xc":
        return (7,9)
    case "C -2y":
        return (8,1)
    case "A -2y":
        return (8,2)
    case "I -2y":
        return (8,3)
    case "A -2":
        return (8,4)
    case "B -2":
        return (8,5)
    case "I -2":
        return (8,6)
    case "B -2x":
        return (8,7)
    case "C -2x":
        return (8,8)
    case "I -2x":
        return (8,9)
    case "C -2yc":
        return (9,1)
    case "A -2yac":
        return (9,2)
    case "I -2ya":
        return (9,3)
    case "A -2ya":
        return (9,4)
    case "C -2ybc":
        return (9,5)
    case "I -2yc":
        return (9,6)
    case "A -2a":
        return (9,7)
    case "B -2bc":
        return (9,8)
    case "I -2b":
        return (9,9)
    case "B -2b":
        return (9,10)
    case "A -2ac":
        return (9,11)
    case "I -2a":
        return (9,12)
    case "B -2xb":
        return (9,13)
    case "C -2xbc":
        return (9,14)
    case "I -2xc":
        return (9,15)
    case "C -2xc":
        return (9,16)
    case "B -2xbc":
        return (9,17)
    case "I -2xb":
        return (9,18)
    case "-P 2y":
        return (10,1)
    case "-P 2":
        return (10,2)
    case "-P 2x":
        return (10,3)
    case "-P 2yb":
        return (11,1)
    case "-P 2c":
        return (11,2)
    case "-P 2xa":
        return (11,3)
    case "-C 2y":
        return (12,1)
    case "-A 2y":
        return (12,2)
    case "-I 2y":
        return (12,3)
    case "-A 2":
        return (12,4)
    case "-B 2":
        return (12,5)
    case "-I 2":
        return (12,6)
    case "-B 2x":
        return (12,7)
    case "-C 2x":
        return (12,8)
    case "-I 2x":
        return (12,9)
    case "-P 2yc":
        return (13,1)
    case "-P 2yac":
        return (13,2)
    case "-P 2ya":
        return (13,3)
    case "-P 2a":
        return (13,4)
    case "-P 2ab":
        return (13,5)
    case "-P 2b":
        return (13,6)
    case "-P 2xb":
        return (13,7)
    case "-P 2xbc":
        return (13,8)
    case "-P 2xc":
        return (13,9)
    case "-P 2ybc":
        return (14,1)
    case "-P 2yn":
        return (14,2)
    case "-P 2yab":
        return (14,3)
    case "-P 2ac":
        return (14,4)
    case "-P 2n":
        return (14,5)
    case "-P 2bc":
        return (14,6)
    case "-P 2xab":
        return (14,7)
    case "-P 2xn":
        return (14,8)
    case "-P 2xac":
        return (14,9)
    case "-C 2yc":
        return (15,1)
    case "-A 2yac":
        return (15,2)
    case "-I 2ya":
        return (15,3)
    case "-A 2ya":
        return (15,4)
    case "-C 2ybc":
        return (15,5)
    case "-I 2yc":
        return (15,6)
    case "-A 2a":
        return (15,7)
    case "-B 2bc":
        return (15,8)
    case "-I 2b":
        return (15,9)
    case "-B 2b":
        return (15,10)
    case "-A 2ac":
        return (15,11)
    case "-I 2a":
        return (15,12)
    case "-B 2xb":
        return (15,13)
    case "-C 2xbc":
        return (15,14)
    case "-I 2xc":
        return (15,15)
    case "-C 2xc":
        return (15,16)
    case "-B 2xbc":
        return (15,17)
    case "-I 2xb":
        return (15,18)
    case "P 2 2":
        return (16,1)
    case "P 2c 2":
        return (17,1)
    case "P 2a 2a":
        return (17,3)
    case "P 2 2b":
        return (17,5)
    case "P 2 2ab":
        return (18,1)
    case "P 2bc 2":
        return (18,3)
    case "P 2ac 2ac":
        return (18,5)
    case "P 2ac 2ab":
        return (19,1)
    case "C 2c 2":
        return (20,1)
    case "A 2a 2a":
        return (20,3)
    case "B 2 2b":
        return (20,5)
    case "C 2 2":
        return (21,1)
    case "A 2 2":
        return (21,3)
    case "B 2 2":
        return (21,5)
    case "F 2 2":
        return (22,1)
    case "I 2 2":
        return (23,1)
    case "I 2b 2c":
        return (24,1)
    case "P 2 -2":
        return (25,1)
    case "P -2 2":
        return (25,3)
    case "P -2 -2":
        return (25,5)
    case "P 2c -2":
        return (26,1)
    case "P 2c -2c":
        return (26,2)
    case "P -2a 2a":
        return (26,3)
    case "P -2 2a":
        return (26,4)
    case "P -2 -2b":
        return (26,5)
    case "P -2b -2":
        return (26,6)
    case "P 2 -2c":
        return (27,1)
    case "P -2a 2":
        return (27,3)
    case "P -2b -2b":
        return (27,5)
    case "P 2 -2a":
        return (28,1)
    case "P 2 -2b":
        return (28,2)
    case "P -2b 2":
        return (28,3)
    case "P -2c 2":
        return (28,4)
    case "P -2c -2c":
        return (28,5)
    case "P -2a -2a":
        return (28,6)
    case "P 2c -2ac":
        return (29,1)
    case "P 2c -2b":
        return (29,2)
    case "P -2b 2a":
        return (29,3)
    case "P -2ac 2a":
        return (29,4)
    case "P -2bc -2c":
        return (29,5)
    case "P -2a -2ab":
        return (29,6)
    case "P 2 -2bc":
        return (30,1)
    case "P 2 -2ac":
        return (30,2)
    case "P -2ac 2":
        return (30,3)
    case "P -2ab 2":
        return (30,4)
    case "P -2ab -2ab":
        return (30,5)
    case "P -2bc -2bc":
        return (30,6)
    case "P 2ac -2":
        return (31,1)
    case "P 2bc -2bc":
        return (31,2)
    case "P -2ab 2ab":
        return (31,3)
    case "P -2 2ac":
        return (31,4)
    case "P -2 -2bc":
        return (31,5)
    case "P -2ab -2":
        return (31,6)
    case "P 2 -2ab":
        return (32,1)
    case "P -2bc 2":
        return (32,3)
    case "P -2ac -2ac":
        return (32,5)
    case "P 2c -2n":
        return (33,1)
    case "P 2c -2ab":
        return (33,2)
    case "P -2bc 2a":
        return (33,3)
    case "P -2n 2a":
        return (33,4)
    case "P -2n -2ac":
        return (33,5)
    case "P -2ac -2n":
        return (33,6)
    case "P 2 -2n":
        return (34,1)
    case "P -2n 2":
        return (34,3)
    case "P -2n -2n":
        return (34,5)
    case "C 2 -2":
        return (35,1)
    case "A -2 2":
        return (35,3)
    case "B -2 -2":
        return (35,5)
    case "C 2c -2":
        return (36,1)
    case "C 2c -2c":
        return (36,2)
    case "A -2a 2a":
        return (36,3)
    case "A -2 2a":
        return (36,4)
    case "B -2 -2b":
        return (36,5)
    case "B -2b -2":
        return (36,6)
    case "C 2 -2c":
        return (37,1)
    case "A -2a 2":
        return (37,3)
    case "B -2b -2b":
        return (37,5)
    case "A 2 -2":
        return (38,1)
    case "B 2 -2":
        return (38,2)
    case "B -2 2":
        return (38,3)
    case "C -2 2":
        return (38,4)
    case "C -2 -2":
        return (38,5)
    case "A -2 -2":
        return (38,6)
    case "A 2 -2c":
        return (39,1)
    case "B 2 -2c":
        return (39,2)
    case "B -2c 2":
        return (39,3)
    case "C -2b 2":
        return (39,4)
    case "C -2b -2b":
        return (39,5)
    case "A -2c -2c":
        return (39,6)
    case "A 2 -2a":
        return (40,1)
    case "B 2 -2b":
        return (40,2)
    case "B -2b 2":
        return (40,3)
    case "C -2c 2":
        return (40,4)
    case "C -2c -2c":
        return (40,5)
    case "A -2a -2a":
        return (40,6)
    case "A 2 -2ac":
        return (41,1)
    case "B 2 -2bc":
        return (41,2)
    case "B -2bc 2":
        return (41,3)
    case "C -2bc 2":
        return (41,4)
    case "C -2bc -2bc":
        return (41,5)
    case "A -2ac -2ac":
        return (41,6)
    case "F 2 -2":
        return (42,1)
    case "F -2 2":
        return (42,3)
    case "F -2 -2":
        return (42,5)
    case "F 2 -2d":
        return (43,1)
    case "F -2d 2":
        return (43,3)
    case "F -2d -2d":
        return (43,5)
    case "I 2 -2":
        return (44,1)
    case "I -2 2":
        return (44,3)
    case "I -2 -2":
        return (44,5)
    case "I 2 -2c":
        return (45,1)
    case "I -2a 2":
        return (45,3)
    case "I -2b -2b":
        return (45,5)
    case "I 2 -2a":
        return (46,1)
    case "I 2 -2b":
        return (46,2)
    case "I -2b 2":
        return (46,3)
    case "I -2c 2":
        return (46,4)
    case "I -2c -2c":
        return (46,5)
    case "I -2a -2a":
        return (46,6)
    case "-P 2 2":
        return (47,1)
    case "P 2 2 -1n":
        return (48,1)
    case "-P 2ab 2bc":
        return (48,2)
    case "-P 2 2c":
        return (49,1)
    case "-P 2a 2":
        return (49,3)
    case "-P 2b 2b":
        return (49,5)
    case "P 2 2 -1ab":
        return (50,1)
    case "-P 2ab 2b":
        return (50,2)
    case "P 2 2 -1bc":
        return (50,5)
    case "-P 2b 2bc":
        return (50,6)
    case "P 2 2 -1ac":
        return (50,9)
    case "-P 2a 2c":
        return (50,10)
    case "-P 2a 2a":
        return (51,1)
    case "-P 2b 2":
        return (51,2)
    case "-P 2 2b":
        return (51,3)
    case "-P 2c 2c":
        return (51,4)
    case "-P 2c 2":
        return (51,5)
    case "-P 2 2a":
        return (51,6)
    case "-P 2a 2bc":
        return (52,1)
    case "-P 2b 2n":
        return (52,2)
    case "-P 2n 2b":
        return (52,3)
    case "-P 2ab 2c":
        return (52,4)
    case "-P 2ab 2n":
        return (52,5)
    case "-P 2n 2bc":
        return (52,6)
    case "-P 2ac 2":
        return (53,1)
    case "-P 2bc 2bc":
        return (53,2)
    case "-P 2ab 2ab":
        return (53,3)
    case "-P 2 2ac":
        return (53,4)
    case "-P 2 2bc":
        return (53,5)
    case "-P 2ab 2":
        return (53,6)
    case "-P 2a 2ac":
        return (54,1)
    case "-P 2b 2c":
        return (54,2)
    case "-P 2a 2b":
        return (54,3)
    case "-P 2ac 2c":
        return (54,4)
    case "-P 2bc 2b":
        return (54,5)
    case "-P 2b 2ab":
        return (54,6)
    case "-P 2 2ab":
        return (55,1)
    case "-P 2bc 2":
        return (55,3)
    case "-P 2ac 2ac":
        return (55,5)
    case "-P 2ab 2ac":
        return (56,1)
    case "-P 2ac 2bc":
        return (56,3)
    case "-P 2bc 2ab":
        return (56,5)
    case "-P 2c 2b":
        return (57,1)
    case "-P 2c 2ac":
        return (57,2)
    case "-P 2ac 2a":
        return (57,3)
    case "-P 2b 2a":
        return (57,4)
    case "-P 2a 2ab":
        return (57,5)
    case "-P 2bc 2c":
        return (57,6)
    case "-P 2 2n":
        return (58,1)
    case "-P 2n 2":
        return (58,3)
    case "-P 2n 2n":
        return (58,5)
    case "P 2 2ab -1ab":
        return (59,1)
    case "-P 2ab 2a":
        return (59,2)
    case "P 2bc 2 -1bc":
        return (59,5)
    case "-P 2c 2bc":
        return (59,6)
    case "P 2ac 2ac -1ac":
        return (59,9)
    case "-P 2c 2a":
        return (59,10)
    case "-P 2n 2ab":
        return (60,1)
    case "-P 2n 2c":
        return (60,2)
    case "-P 2a 2n":
        return (60,3)
    case "-P 2bc 2n":
        return (60,4)
    case "-P 2ac 2b":
        return (60,5)
    case "-P 2b 2ac":
        return (60,6)
    case "-P 2ac 2ab":
        return (61,1)
    case "-P 2bc 2ac":
        return (61,2)
    case "-P 2ac 2n":
        return (62,1)
    case "-P 2bc 2a":
        return (62,2)
    case "-P 2c 2ab":
        return (62,3)
    case "-P 2n 2ac":
        return (62,4)
    case "-P 2n 2a":
        return (62,5)
    case "-P 2c 2n":
        return (62,6)
    case "-C 2c 2":
        return (63,1)
    case "-C 2c 2c":
        return (63,2)
    case "-A 2a 2a":
        return (63,3)
    case "-A 2 2a":
        return (63,4)
    case "-B 2 2b":
        return (63,5)
    case "-B 2b 2":
        return (63,6)
    case "-C 2bc 2":
        return (64,1)
    case "-C 2bc 2bc":
        return (64,2)
    case "-A 2ac 2ac":
        return (64,3)
    case "-A 2 2ac":
        return (64,4)
    case "-B 2 2bc":
        return (64,5)
    case "-B 2bc 2":
        return (64,6)
    case "-C 2 2":
        return (65,1)
    case "-A 2 2":
        return (65,3)
    case "-B 2 2":
        return (65,5)
    case "-C 2 2c":
        return (66,1)
    case "-A 2a 2":
        return (66,3)
    case "-B 2b 2b":
        return (66,5)
    case "-C 2b 2":
        return (67,1)
    case "-C 2b 2b":
        return (67,2)
    case "-A 2c 2c":
        return (67,3)
    case "-A 2 2c":
        return (67,4)
    case "-B 2 2c":
        return (67,5)
    case "-B 2c 2":
        return (67,6)
    case "C 2 2 -1bc":
        return (68,1)
    case "-C 2b 2bc":
        return (68,2)
    case "-C 2b 2c":
        return (68,4)
    case "A 2 2 -1ac":
        return (68,5)
    case "-A 2a 2c":
        return (68,6)
    case "-A 2ac 2c":
        return (68,8)
    case "B 2 2 -1bc":
        return (68,9)
    case "-B 2bc 2b":
        return (68,10)
    case "-B 2b 2bc":
        return (68,12)
    case "-F 2 2":
        return (69,1)
    case "F 2 2 -1d":
        return (70,1)
    case "-F 2uv 2vw":
        return (70,2)
    case "-I 2 2":
        return (71,1)
    case "-I 2 2c":
        return (72,1)
    case "-I 2a 2":
        return (72,3)
    case "-I 2b 2b":
        return (72,5)
    case "-I 2b 2c":
        return (73,1)
    case "-I 2a 2b":
        return (73,2)
    case "-I 2b 2":
        return (74,1)
    case "-I 2a 2a":
        return (74,2)
    case "-I 2c 2c":
        return (74,3)
    case "-I 2 2b":
        return (74,4)
    case "-I 2 2a":
        return (74,5)
    case "-I 2c 2":
        return (74,6)
    case "P 4":
        return (75,1)
    case "P 4w":
        return (76,1)
    case "P 4c":
        return (77,1)
    case "P 4cw":
        return (78,1)
    case "I 4":
        return (79,1)
    case "I 4bw":
        return (80,1)
    case "P -4":
        return (81,1)
    case "I -4":
        return (82,1)
    case "-P 4":
        return (83,1)
    case "-P 4c":
        return (84,1)
    case "P 4ab -1ab":
        return (85,1)
    case "-P 4a":
        return (85,2)
    case "P 4n -1n":
        return (86,1)
    case "-P 4bc":
        return (86,2)
    case "-I 4":
        return (87,1)
    case "I 4bw -1bw":
        return (88,1)
    case "-I 4ad":
        return (88,2)
    case "P 4 2":
        return (89,1)
    case "P 4ab 2ab":
        return (90,1)
    case "P 4w 2c":
        return (91,1)
    case "P 4abw 2nw":
        return (92,1)
    case "P 4c 2":
        return (93,1)
    case "P 4n 2n":
        return (94,1)
    case "P 4cw 2c":
        return (95,1)
    case "P 4nw 2abw":
        return (96,1)
    case "I 4 2":
        return (97,1)
    case "I 4bw 2bw":
        return (98,1)
    case "P 4 -2":
        return (99,1)
    case "P 4 -2ab":
        return (100,1)
    case "P 4c -2c":
        return (101,1)
    case "P 4n -2n":
        return (102,1)
    case "P 4 -2c":
        return (103,1)
    case "P 4 -2n":
        return (104,1)
    case "P 4c -2":
        return (105,1)
    case "P 4c -2ab":
        return (106,1)
    case "I 4 -2":
        return (107,1)
    case "I 4 -2c":
        return (108,1)
    case "I 4bw -2":
        return (109,1)
    case "I 4bw -2c":
        return (110,1)
    case "P -4 2":
        return (111,1)
    case "P -4 2c":
        return (112,1)
    case "P -4 2ab":
        return (113,1)
    case "P -4 2n":
        return (114,1)
    case "P -4 -2":
        return (115,1)
    case "P -4 -2c":
        return (116,1)
    case "P -4 -2ab":
        return (117,1)
    case "P -4 -2n":
        return (118,1)
    case "I -4 -2":
        return (119,1)
    case "I -4 -2c":
        return (120,1)
    case "I -4 2":
        return (121,1)
    case "I -4 2bw":
        return (122,1)
    case "-P 4 2":
        return (123,1)
    case "-P 4 2c":
        return (124,1)
    case "P 4 2 -1ab":
        return (125,1)
    case "-P 4a 2b":
        return (125,2)
    case "P 4 2 -1n":
        return (126,1)
    case "-P 4a 2bc":
        return (126,2)
    case "-P 4 2ab":
        return (127,1)
    case "-P 4 2n":
        return (128,1)
    case "P 4ab 2ab -1ab":
        return (129,1)
    case "-P 4a 2a":
        return (129,2)
    case "P 4ab 2n -1ab":
        return (130,1)
    case "-P 4a 2ac":
        return (130,2)
    case "-P 4c 2":
        return (131,1)
    case "-P 4c 2c":
        return (132,1)
    case "P 4n 2c -1n":
        return (133,1)
    case "-P 4ac 2b":
        return (133,2)
    case "P 4n 2 -1n":
        return (134,1)
    case "-P 4ac 2bc":
        return (134,2)
    case "-P 4c 2ab":
        return (135,1)
    case "-P 4n 2n":
        return (136,1)
    case "P 4n 2n -1n":
        return (137,1)
    case "-P 4ac 2a":
        return (137,2)
    case "P 4n 2ab -1n":
        return (138,1)
    case "-P 4ac 2ac":
        return (138,2)
    case "-I 4 2":
        return (139,1)
    case "-I 4 2c":
        return (140,1)
    case "I 4bw 2bw -1bw":
        return (141,1)
    case "-I 4bd 2":
        return (141,2)
    case "I 4bw 2aw -1bw":
        return (142,1)
    case "-I 4bd 2c":
        return (142,2)
    case "P 3":
        return (143,1)
    case "P 31":
        return (144,1)
    case "P 32":
        return (145,1)
    case "R 3":
        return (146,1)
    case "P 3*":
        return (146,2)
    case "-P 3":
        return (147,1)
    case "-R 3":
        return (148,1)
    case "-P 3*":
        return (148,2)
    case "P 3 2":
        return (149,1)
    case "P 3 2\\":
        return (150,1)
    case "P 31 2c (0 0 1)":
        return (151,1)
    case "P 31 2\\":
        return (152,1)
    case "P 32 2c (0 0 -1)":
        return (153,1)
    case "P 32 2\\":
        return (154,1)
    case "R 3 2\\":
        return (155,1)
    case "P 3* 2":
        return (155,2)
    case "P 3 -2\\":
        return (156,1)
    case "P 3 -2":
        return (157,1)
    case "P 3 -2\\c":
        return (158,1)
    case "P 3 -2c":
        return (159,1)
    case "R 3 -2\\":
        return (160,1)
    case "P 3* -2":
        return (160,2)
    case "R 3 -2\\c":
        return (161,1)
    case "P 3* -2n":
        return (161,2)
    case "-P 3 2":
        return (162,1)
    case "-P 3 2c":
        return (163,1)
    case "-P 3 2\\":
        return (164,1)
    case "-P 3 2\\c":
        return (165,1)
    case "-R 3 2\\":
        return (166,1)
    case "-P 3* 2":
        return (166,2)
    case "-R 3 2\\c":
        return (167,1)
    case "-P 3* 2n":
        return (167,2)
    case "P 6":
        return (168,1)
    case "P 61":
        return (169,1)
    case "P 65":
        return (170,1)
    case "P 62":
        return (171,1)
    case "P 64":
        return (172,1)
    case "P 6c":
        return (173,1)
    case "P -6":
        return (174,1)
    case "-P 6":
        return (175,1)
    case "-P 6c":
        return (176,1)
    case "P 6 2":
        return (177,1)
    case "P 61 2 (0 0 -1)":
        return (178,1)
    case "P 65 2 (0 0 1)":
        return (179,1)
    case "P 62 2c (0 0 1)":
        return (180,1)
    case "P 64 2c (0 0 -1)":
        return (181,1)
    case "P 6c 2c":
        return (182,1)
    case "P 6 -2":
        return (183,1)
    case "P 6 -2c":
        return (184,1)
    case "P 6c -2":
        return (185,1)
    case "P 6c -2c":
        return (186,1)
    case "P -6 2":
        return (187,1)
    case "P -6c 2":
        return (188,1)
    case "P -6 -2":
        return (189,1)
    case "P -6c -2c":
        return (190,1)
    case "-P 6 2":
        return (191,1)
    case "-P 6 2c":
        return (192,1)
    case "-P 6c 2":
        return (193,1)
    case "-P 6c 2c":
        return (194,1)
    case "P 2 2 3":
        return (195,1)
    case "F 2 2 3":
        return (196,1)
    case "I 2 2 3":
        return (197,1)
    case "P 2ac 2ab 3":
        return (198,1)
    case "I 2b 2c 3":
        return (199,1)
    case "-P 2 2 3":
        return (200,1)
    case "P 2 2 3 -1n":
        return (201,1)
    case "-P 2ab 2bc 3":
        return (201,2)
    case "-F 2 2 3":
        return (202,1)
    case "F 2 2 3 -1d":
        return (203,1)
    case "-F 2uv 2vw 3":
        return (203,2)
    case "-I 2 2 3":
        return (204,1)
    case "-P 2ac 2ab 3":
        return (205,1)
    case "-I 2b 2c 3":
        return (206,1)
    case "P 4 2 3":
        return (207,1)
    case "P 4n 2 3":
        return (208,1)
    case "F 4 2 3":
        return (209,1)
    case "F 4d 2 3":
        return (210,1)
    case "I 4 2 3":
        return (211,1)
    case "P 4acd 2ab 3":
        return (212,1)
    case "P 4bd 2ab 3":
        return (213,1)
    case "I 4bd 2c 3":
        return (214,1)
    case "P -4 2 3":
        return (215,1)
    case "F -4 2 3":
        return (216,1)
    case "I -4 2 3":
        return (217,1)
    case "P -4n 2 3":
        return (218,1)
    case "F -4c 2 3":
        return (219,1)
    case "I -4bd 2c 3":
        return (220,1)
    case "-P 4 2 3":
        return (221,1)
    case "P 4 2 3 -1n":
        return (222,1)
    case "-P 4a 2bc 3":
        return (222,2)
    case "-P 4n 2 3":
        return (223,1)
    case "P 4n 2 3 -1n":
        return (224,1)
    case "-P 4bc 2bc 3":
        return (224,2)
    case "-F 4 2 3":
        return (225,1)
    case "-F 4c 2 3":
        return (226,1)
    case "F 4d 2 3 -1d":
        return (227,1)
    case "-F 4vw 2vw 3":
        return (227,2)
    case "F 4d 2 3 -1cd":
        return (228,1)
    case "-F 4cvw 2vw 3":
        return (228,2)
    case "-I 4 2 3":
        return (229,1)
    case "-I 4bd 2c 3":
        return (230,1)
    default:
        return nil
    }
}
