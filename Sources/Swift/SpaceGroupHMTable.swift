//
//  SpacegroupNameTable.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/05/30.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func spacegroupHMToSymopIndex(_ name:String) -> (Int,Int)? {
    switch name {
    case "P 1":
        return (1,1)
    case "P1":
        return (1,1)
    case "P -1":
        return (2,1)
    case "P-1":
        return (2,1)
    case "P 2":
        return (3,1)
    case "P 1 2 1":
        return (3,1)
    case "P2":
        return (3,1)
    case "P121":
        return (3,1)
    case "P 1 1 2":
        return (3,2)
    case "P112":
        return (3,2)
    case "P 2 1 1":
        return (3,3)
    case "P211":
        return (3,3)
    case "P 21":
        return (4,1)
    case "P 1 21 1":
        return (4,1)
    case "P21":
        return (4,1)
    case "P1211":
        return (4,1)
    case "P 1 1 21":
        return (4,2)
    case "P1121":
        return (4,2)
    case "P 21 1 1":
        return (4,3)
    case "P2111":
        return (4,3)
    case "C 2":
        return (5,1)
    case "C 1 2 1":
        return (5,1)
    case "C2":
        return (5,1)
    case "C121":
        return (5,1)
    case "A 1 2 1":
        return (5,2)
    case "A121":
        return (5,2)
    case "I 1 2 1":
        return (5,3)
    case "I121":
        return (5,3)
    case "A 1 1 2":
        return (5,4)
    case "A112":
        return (5,4)
    case "B 1 1 2":
        return (5,5)
    case "B 2":
        return (5,5)
    case "B112":
        return (5,5)
    case "B2":
        return (5,5)
    case "I 1 1 2":
        return (5,6)
    case "I112":
        return (5,6)
    case "B 2 1 1":
        return (5,7)
    case "B211":
        return (5,7)
    case "C 2 1 1":
        return (5,8)
    case "C211":
        return (5,8)
    case "I 2 1 1":
        return (5,9)
    case "I211":
        return (5,9)
    case "P m":
        return (6,1)
    case "P 1 m 1":
        return (6,1)
    case "Pm":
        return (6,1)
    case "P1m1":
        return (6,1)
    case "P 1 1 m":
        return (6,2)
    case "P11m":
        return (6,2)
    case "P m 1 1":
        return (6,3)
    case "Pm11":
        return (6,3)
    case "P c":
        return (7,1)
    case "P 1 c 1":
        return (7,1)
    case "Pc":
        return (7,1)
    case "P1c1":
        return (7,1)
    case "P 1 n 1":
        return (7,2)
    case "P1n1":
        return (7,2)
    case "P 1 a 1":
        return (7,3)
    case "P1a1":
        return (7,3)
    case "P 1 1 a":
        return (7,4)
    case "P11a":
        return (7,4)
    case "P 1 1 n":
        return (7,5)
    case "P11n":
        return (7,5)
    case "P 1 1 b":
        return (7,6)
    case "P b":
        return (7,6)
    case "P11b":
        return (7,6)
    case "Pb":
        return (7,6)
    case "P b 1 1":
        return (7,7)
    case "Pb11":
        return (7,7)
    case "P n 1 1":
        return (7,8)
    case "Pn11":
        return (7,8)
    case "P c 1 1":
        return (7,9)
    case "Pc11":
        return (7,9)
    case "C m":
        return (8,1)
    case "C 1 m 1":
        return (8,1)
    case "Cm":
        return (8,1)
    case "C1m1":
        return (8,1)
    case "A 1 m 1":
        return (8,2)
    case "A1m1":
        return (8,2)
    case "I 1 m 1":
        return (8,3)
    case "I1m1":
        return (8,3)
    case "A 1 1 m":
        return (8,4)
    case "A11m":
        return (8,4)
    case "B 1 1 m":
        return (8,5)
    case "B m":
        return (8,5)
    case "B11m":
        return (8,5)
    case "Bm":
        return (8,5)
    case "I 1 1 m":
        return (8,6)
    case "I11m":
        return (8,6)
    case "B m 1 1":
        return (8,7)
    case "Bm11":
        return (8,7)
    case "C m 1 1":
        return (8,8)
    case "Cm11":
        return (8,8)
    case "I m 1 1":
        return (8,9)
    case "Im11":
        return (8,9)
    case "C c":
        return (9,1)
    case "C 1 c 1":
        return (9,1)
    case "Cc":
        return (9,1)
    case "C1c1":
        return (9,1)
    case "A 1 n 1":
        return (9,2)
    case "A1n1":
        return (9,2)
    case "I 1 a 1":
        return (9,3)
    case "I1a1":
        return (9,3)
    case "A 1 a 1":
        return (9,4)
    case "A1a1":
        return (9,4)
    case "C 1 n 1":
        return (9,5)
    case "C1n1":
        return (9,5)
    case "I 1 c 1":
        return (9,6)
    case "I1c1":
        return (9,6)
    case "A 1 1 a":
        return (9,7)
    case "A11a":
        return (9,7)
    case "B 1 1 n":
        return (9,8)
    case "B11n":
        return (9,8)
    case "I 1 1 b":
        return (9,9)
    case "I11b":
        return (9,9)
    case "B 1 1 b":
        return (9,10)
    case "B b":
        return (9,10)
    case "B11b":
        return (9,10)
    case "Bb":
        return (9,10)
    case "A 1 1 n":
        return (9,11)
    case "A11n":
        return (9,11)
    case "I 1 1 a":
        return (9,12)
    case "I11a":
        return (9,12)
    case "B b 1 1":
        return (9,13)
    case "Bb11":
        return (9,13)
    case "C n 1 1":
        return (9,14)
    case "Cn11":
        return (9,14)
    case "I c 1 1":
        return (9,15)
    case "Ic11":
        return (9,15)
    case "C c 1 1":
        return (9,16)
    case "Cc11":
        return (9,16)
    case "B n 1 1":
        return (9,17)
    case "Bn11":
        return (9,17)
    case "I b 1 1":
        return (9,18)
    case "Ib11":
        return (9,18)
    case "P 2/m":
        return (10,1)
    case "P 1 2/m 1":
        return (10,1)
    case "P2/m":
        return (10,1)
    case "P12/m1":
        return (10,1)
    case "P 1 1 2/m":
        return (10,2)
    case "P112/m":
        return (10,2)
    case "P 2/m 1 1":
        return (10,3)
    case "P2/m11":
        return (10,3)
    case "P 21/m":
        return (11,1)
    case "P 1 21/m 1":
        return (11,1)
    case "P21/m":
        return (11,1)
    case "P121/m1":
        return (11,1)
    case "P 1 1 21/m":
        return (11,2)
    case "P1121/m":
        return (11,2)
    case "P 21/m 1 1":
        return (11,3)
    case "P21/m11":
        return (11,3)
    case "C 2/m":
        return (12,1)
    case "C 1 2/m 1":
        return (12,1)
    case "C2/m":
        return (12,1)
    case "C12/m1":
        return (12,1)
    case "A 1 2/m 1":
        return (12,2)
    case "A12/m1":
        return (12,2)
    case "I 1 2/m 1":
        return (12,3)
    case "I12/m1":
        return (12,3)
    case "A 1 1 2/m":
        return (12,4)
    case "A112/m":
        return (12,4)
    case "B 1 1 2/m":
        return (12,5)
    case "B 2/m":
        return (12,5)
    case "B112/m":
        return (12,5)
    case "B2/m":
        return (12,5)
    case "I 1 1 2/m":
        return (12,6)
    case "I112/m":
        return (12,6)
    case "B 2/m 1 1":
        return (12,7)
    case "B2/m11":
        return (12,7)
    case "C 2/m 1 1":
        return (12,8)
    case "C2/m11":
        return (12,8)
    case "I 2/m 1 1":
        return (12,9)
    case "I2/m11":
        return (12,9)
    case "P 2/c":
        return (13,1)
    case "P 1 2/c 1":
        return (13,1)
    case "P2/c":
        return (13,1)
    case "P12/c1":
        return (13,1)
    case "P 1 2/n 1":
        return (13,2)
    case "P12/n1":
        return (13,2)
    case "P 1 2/a 1":
        return (13,3)
    case "P12/a1":
        return (13,3)
    case "P 1 1 2/a":
        return (13,4)
    case "P112/a":
        return (13,4)
    case "P 1 1 2/n":
        return (13,5)
    case "P112/n":
        return (13,5)
    case "P 1 1 2/b":
        return (13,6)
    case "P 2/b":
        return (13,6)
    case "P112/b":
        return (13,6)
    case "P2/b":
        return (13,6)
    case "P 2/b 1 1":
        return (13,7)
    case "P2/b11":
        return (13,7)
    case "P 2/n 1 1":
        return (13,8)
    case "P2/n11":
        return (13,8)
    case "P 2/c 1 1":
        return (13,9)
    case "P2/c11":
        return (13,9)
    case "P 21/c":
        return (14,1)
    case "P 1 21/c 1":
        return (14,1)
    case "P21/c":
        return (14,1)
    case "P121/c1":
        return (14,1)
    case "P 1 21/n 1":
        return (14,2)
    case "P121/n1":
        return (14,2)
    case "P 1 21/a 1":
        return (14,3)
    case "P121/a1":
        return (14,3)
    case "P 1 1 21/a":
        return (14,4)
    case "P1121/a":
        return (14,4)
    case "P 1 1 21/n":
        return (14,5)
    case "P1121/n":
        return (14,5)
    case "P 1 1 21/b":
        return (14,6)
    case "P 21/b":
        return (14,6)
    case "P1121/b":
        return (14,6)
    case "P21/b":
        return (14,6)
    case "P 21/b 1 1":
        return (14,7)
    case "P21/b11":
        return (14,7)
    case "P 21/n 1 1":
        return (14,8)
    case "P21/n11":
        return (14,8)
    case "P 21/c 1 1":
        return (14,9)
    case "P21/c11":
        return (14,9)
    case "C 2/c":
        return (15,1)
    case "C 1 2/c 1":
        return (15,1)
    case "C2/c":
        return (15,1)
    case "C12/c1":
        return (15,1)
    case "A 1 2/n 1":
        return (15,2)
    case "A12/n1":
        return (15,2)
    case "I 1 2/a 1":
        return (15,3)
    case "I12/a1":
        return (15,3)
    case "A 1 2/a 1":
        return (15,4)
    case "A12/a1":
        return (15,4)
    case "C 1 2/n 1":
        return (15,5)
    case "C12/n1":
        return (15,5)
    case "I 1 2/c 1":
        return (15,6)
    case "I12/c1":
        return (15,6)
    case "A 1 1 2/a":
        return (15,7)
    case "A112/a":
        return (15,7)
    case "B 1 1 2/n":
        return (15,8)
    case "B112/n":
        return (15,8)
    case "I 1 1 2/b":
        return (15,9)
    case "I112/b":
        return (15,9)
    case "B 1 1 2/b":
        return (15,10)
    case "B 2/b":
        return (15,10)
    case "B112/b":
        return (15,10)
    case "B2/b":
        return (15,10)
    case "A 1 1 2/n":
        return (15,11)
    case "A112/n":
        return (15,11)
    case "I 1 1 2/a":
        return (15,12)
    case "I112/a":
        return (15,12)
    case "B 2/b 1 1":
        return (15,13)
    case "B2/b11":
        return (15,13)
    case "C 2/n 1 1":
        return (15,14)
    case "C2/n11":
        return (15,14)
    case "I 2/c 1 1":
        return (15,15)
    case "I2/c11":
        return (15,15)
    case "C 2/c 1 1":
        return (15,16)
    case "C2/c11":
        return (15,16)
    case "B 2/n 1 1":
        return (15,17)
    case "B2/n11":
        return (15,17)
    case "I 2/b 1 1":
        return (15,18)
    case "I2/b11":
        return (15,18)
    case "P 2 2 2":
        return (16,1)
    case "P222":
        return (16,1)
    case "?":
        return (16,2)
    case "P 2 2 21":
        return (17,1)
    case "P2221":
        return (17,1)
    case "P 21 2 2":
        return (17,3)
    case "P2122":
        return (17,3)
    case "P 2 21 2":
        return (17,5)
    case "P2212":
        return (17,5)
    case "P 21 21 2":
        return (18,1)
    case "P21212":
        return (18,1)
    case "P 2 21 21":
        return (18,3)
    case "P22121":
        return (18,3)
    case "P 21 2 21":
        return (18,5)
    case "P21221":
        return (18,5)
    case "P 21 21 21":
        return (19,1)
    case "P212121":
        return (19,1)
    case "C 2 2 21":
        return (20,1)
    case "C2221":
        return (20,1)
    case "A 21 2 2":
        return (20,3)
    case "A2122":
        return (20,3)
    case "B 2 21 2":
        return (20,5)
    case "B2212":
        return (20,5)
    case "C 2 2 2":
        return (21,1)
    case "C222":
        return (21,1)
    case "A 2 2 2":
        return (21,3)
    case "A222":
        return (21,3)
    case "B 2 2 2":
        return (21,5)
    case "B222":
        return (21,5)
    case "F 2 2 2":
        return (22,1)
    case "F222":
        return (22,1)
    case "I 2 2 2":
        return (23,1)
    case "I222":
        return (23,1)
    case "I 21 21 21":
        return (24,1)
    case "I212121":
        return (24,1)
    case "P m m 2":
        return (25,1)
    case "Pmm2":
        return (25,1)
    case "P 2 m m":
        return (25,3)
    case "P2mm":
        return (25,3)
    case "P m 2 m":
        return (25,5)
    case "Pm2m":
        return (25,5)
    case "P m c 21":
        return (26,1)
    case "Pmc21":
        return (26,1)
    case "P c m 21":
        return (26,2)
    case "Pcm21":
        return (26,2)
    case "P 21 m a":
        return (26,3)
    case "P21ma":
        return (26,3)
    case "P 21 a m":
        return (26,4)
    case "P21am":
        return (26,4)
    case "P b 21 m":
        return (26,5)
    case "Pb21m":
        return (26,5)
    case "P m 21 b":
        return (26,6)
    case "Pm21b":
        return (26,6)
    case "P c c 2":
        return (27,1)
    case "Pcc2":
        return (27,1)
    case "P 2 a a":
        return (27,3)
    case "P2aa":
        return (27,3)
    case "P b 2 b":
        return (27,5)
    case "Pb2b":
        return (27,5)
    case "P m a 2":
        return (28,1)
    case "Pma2":
        return (28,1)
    case "P b m 2":
        return (28,2)
    case "Pbm2":
        return (28,2)
    case "P 2 m b":
        return (28,3)
    case "P2mb":
        return (28,3)
    case "P 2 c m":
        return (28,4)
    case "P2cm":
        return (28,4)
    case "P c 2 m":
        return (28,5)
    case "Pc2m":
        return (28,5)
    case "P m 2 a":
        return (28,6)
    case "Pm2a":
        return (28,6)
    case "P c a 21":
        return (29,1)
    case "Pca21":
        return (29,1)
    case "P b c 21":
        return (29,2)
    case "Pbc21":
        return (29,2)
    case "P 21 a b":
        return (29,3)
    case "P21ab":
        return (29,3)
    case "P 21 c a":
        return (29,4)
    case "P21ca":
        return (29,4)
    case "P c 21 b":
        return (29,5)
    case "Pc21b":
        return (29,5)
    case "P b 21 a":
        return (29,6)
    case "Pb21a":
        return (29,6)
    case "P n c 2":
        return (30,1)
    case "Pnc2":
        return (30,1)
    case "P c n 2":
        return (30,2)
    case "Pcn2":
        return (30,2)
    case "P 2 n a":
        return (30,3)
    case "P2na":
        return (30,3)
    case "P 2 a n":
        return (30,4)
    case "P2an":
        return (30,4)
    case "P b 2 n":
        return (30,5)
    case "Pb2n":
        return (30,5)
    case "P n 2 b":
        return (30,6)
    case "Pn2b":
        return (30,6)
    case "P m n 21":
        return (31,1)
    case "Pmn21":
        return (31,1)
    case "P n m 21":
        return (31,2)
    case "Pnm21":
        return (31,2)
    case "P 21 m n":
        return (31,3)
    case "P21mn":
        return (31,3)
    case "P 21 n m":
        return (31,4)
    case "P21nm":
        return (31,4)
    case "P n 21 m":
        return (31,5)
    case "Pn21m":
        return (31,5)
    case "P m 21 n":
        return (31,6)
    case "Pm21n":
        return (31,6)
    case "P b a 2":
        return (32,1)
    case "Pba2":
        return (32,1)
    case "P 2 c b":
        return (32,3)
    case "P2cb":
        return (32,3)
    case "P c 2 a":
        return (32,5)
    case "Pc2a":
        return (32,5)
    case "P n a 21":
        return (33,1)
    case "Pna21":
        return (33,1)
    case "P b n 21":
        return (33,2)
    case "Pbn21":
        return (33,2)
    case "P 21 n b":
        return (33,3)
    case "P21nb":
        return (33,3)
    case "P 21 c n":
        return (33,4)
    case "P21cn":
        return (33,4)
    case "P c 21 n":
        return (33,5)
    case "Pc21n":
        return (33,5)
    case "P n 21 a":
        return (33,6)
    case "Pn21a":
        return (33,6)
    case "P n n 2":
        return (34,1)
    case "Pnn2":
        return (34,1)
    case "P 2 n n":
        return (34,3)
    case "P2nn":
        return (34,3)
    case "P n 2 n":
        return (34,5)
    case "Pn2n":
        return (34,5)
    case "C m m 2":
        return (35,1)
    case "Cmm2":
        return (35,1)
    case "A 2 m m":
        return (35,3)
    case "A2mm":
        return (35,3)
    case "B m 2 m":
        return (35,5)
    case "Bm2m":
        return (35,5)
    case "C m c 21":
        return (36,1)
    case "Cmc21":
        return (36,1)
    case "C c m 21":
        return (36,2)
    case "Ccm21":
        return (36,2)
    case "A 21 m a":
        return (36,3)
    case "A21ma":
        return (36,3)
    case "A 21 a m":
        return (36,4)
    case "A21am":
        return (36,4)
    case "B b 21 m":
        return (36,5)
    case "Bb21m":
        return (36,5)
    case "B m 21 b":
        return (36,6)
    case "Bm21b":
        return (36,6)
    case "C c c 2":
        return (37,1)
    case "Ccc2":
        return (37,1)
    case "A 2 a a":
        return (37,3)
    case "A2aa":
        return (37,3)
    case "B b 2 b":
        return (37,5)
    case "Bb2b":
        return (37,5)
    case "A m m 2":
        return (38,1)
    case "Amm2":
        return (38,1)
    case "B m m 2":
        return (38,2)
    case "Bmm2":
        return (38,2)
    case "B 2 m m":
        return (38,3)
    case "B2mm":
        return (38,3)
    case "C 2 m m":
        return (38,4)
    case "C2mm":
        return (38,4)
    case "C m 2 m":
        return (38,5)
    case "Cm2m":
        return (38,5)
    case "A m 2 m":
        return (38,6)
    case "Am2m":
        return (38,6)
    case "A b m 2":
        return (39,1)
    case "Abm2":
        return (39,1)
    case "B m a 2":
        return (39,2)
    case "Bma2":
        return (39,2)
    case "B 2 c m":
        return (39,3)
    case "B2cm":
        return (39,3)
    case "C 2 m b":
        return (39,4)
    case "C2mb":
        return (39,4)
    case "C m 2 a":
        return (39,5)
    case "Cm2a":
        return (39,5)
    case "A c 2 m":
        return (39,6)
    case "Ac2m":
        return (39,6)
    case "A m a 2":
        return (40,1)
    case "Ama2":
        return (40,1)
    case "B b m 2":
        return (40,2)
    case "Bbm2":
        return (40,2)
    case "B 2 m b":
        return (40,3)
    case "B2mb":
        return (40,3)
    case "C 2 c m":
        return (40,4)
    case "C2cm":
        return (40,4)
    case "C c 2 m":
        return (40,5)
    case "Cc2m":
        return (40,5)
    case "A m 2 a":
        return (40,6)
    case "Am2a":
        return (40,6)
    case "A b a 2":
        return (41,1)
    case "Aba2":
        return (41,1)
    case "B b a 2":
        return (41,2)
    case "Bba2":
        return (41,2)
    case "B 2 c b":
        return (41,3)
    case "B2cb":
        return (41,3)
    case "C 2 c b":
        return (41,4)
    case "C2cb":
        return (41,4)
    case "C c 2 a":
        return (41,5)
    case "Cc2a":
        return (41,5)
    case "A c 2 a":
        return (41,6)
    case "Ac2a":
        return (41,6)
    case "F m m 2":
        return (42,1)
    case "Fmm2":
        return (42,1)
    case "F 2 m m":
        return (42,3)
    case "F2mm":
        return (42,3)
    case "F m 2 m":
        return (42,5)
    case "Fm2m":
        return (42,5)
    case "F d d 2":
        return (43,1)
    case "Fdd2":
        return (43,1)
    case "F 2 d d":
        return (43,3)
    case "F2dd":
        return (43,3)
    case "F d 2 d":
        return (43,5)
    case "Fd2d":
        return (43,5)
    case "I m m 2":
        return (44,1)
    case "Imm2":
        return (44,1)
    case "I 2 m m":
        return (44,3)
    case "I2mm":
        return (44,3)
    case "I m 2 m":
        return (44,5)
    case "Im2m":
        return (44,5)
    case "I b a 2":
        return (45,1)
    case "Iba2":
        return (45,1)
    case "I 2 c b":
        return (45,3)
    case "I2cb":
        return (45,3)
    case "I c 2 a":
        return (45,5)
    case "Ic2a":
        return (45,5)
    case "I m a 2":
        return (46,1)
    case "Ima2":
        return (46,1)
    case "I b m 2":
        return (46,2)
    case "Ibm2":
        return (46,2)
    case "I 2 m b":
        return (46,3)
    case "I2mb":
        return (46,3)
    case "I 2 c m":
        return (46,4)
    case "I2cm":
        return (46,4)
    case "I c 2 m":
        return (46,5)
    case "Ic2m":
        return (46,5)
    case "I m 2 a":
        return (46,6)
    case "Im2a":
        return (46,6)
    case "P m m m":
        return (47,1)
    case "P 2/m 2/m 2/m":
        return (47,1)
    case "Pmmm":
        return (47,1)
    case "P2/m2/m2/m":
        return (47,1)
    case "P n n n":
        return (48,1)
    case "P 2/n 2/n 2/n":
        return (48,1)
    case "Pnnn":
        return (48,1)
    case "P2/n2/n2/n":
        return (48,1)
    case "P c c m":
        return (49,1)
    case "P 2/c 2/c 2/m":
        return (49,1)
    case "Pccm":
        return (49,1)
    case "P2/c2/c2/m":
        return (49,1)
    case "P m a a":
        return (49,3)
    case "P 2/m 2/a 2/a":
        return (49,3)
    case "Pmaa":
        return (49,3)
    case "P2/m2/a2/a":
        return (49,3)
    case "P b m b":
        return (49,5)
    case "P 2/b 2/m 2/b":
        return (49,5)
    case "Pbmb":
        return (49,5)
    case "P2/b2/m2/b":
        return (49,5)
    case "P b a n":
        return (50,1)
    case "P 2/b 2/a 2/n":
        return (50,1)
    case "Pban":
        return (50,1)
    case "P2/b2/a2/n":
        return (50,1)
    case "P n c b":
        return (50,5)
    case "P 2/n 2/c 2/b":
        return (50,5)
    case "Pncb":
        return (50,5)
    case "P2/n2/c2/b":
        return (50,5)
    case "P c n a":
        return (50,9)
    case "P 2/c 2/n 2/a":
        return (50,9)
    case "Pcna":
        return (50,9)
    case "P2/c2/n2/a":
        return (50,9)
    case "P m m a":
        return (51,1)
    case "P 21/m 2/m 2/a":
        return (51,1)
    case "Pmma":
        return (51,1)
    case "P21/m2/m2/a":
        return (51,1)
    case "P m m b":
        return (51,2)
    case "P 2/m 21/m 2/b":
        return (51,2)
    case "Pmmb":
        return (51,2)
    case "P2/m21/m2/b":
        return (51,2)
    case "P b m m":
        return (51,3)
    case "P 2/b 21/m 2/m":
        return (51,3)
    case "Pbmm":
        return (51,3)
    case "P2/b21/m2/m":
        return (51,3)
    case "P c m m":
        return (51,4)
    case "P 2/c 2/m 21/m":
        return (51,4)
    case "Pcmm":
        return (51,4)
    case "P2/c2/m21/m":
        return (51,4)
    case "P m c m":
        return (51,5)
    case "P 2/m 2/c 21/m":
        return (51,5)
    case "Pmcm":
        return (51,5)
    case "P2/m2/c21/m":
        return (51,5)
    case "P m a m":
        return (51,6)
    case "P 21/m 2/a 2/m":
        return (51,6)
    case "Pmam":
        return (51,6)
    case "P21/m2/a2/m":
        return (51,6)
    case "P n n a":
        return (52,1)
    case "P 2/n 21/n 2/a":
        return (52,1)
    case "Pnna":
        return (52,1)
    case "P2/n21/n2/a":
        return (52,1)
    case "P n n b":
        return (52,2)
    case "P 21/n 2/n 2/b":
        return (52,2)
    case "Pnnb":
        return (52,2)
    case "P21/n2/n2/b":
        return (52,2)
    case "P b n n":
        return (52,3)
    case "P 2/b 2/n 21/n":
        return (52,3)
    case "Pbnn":
        return (52,3)
    case "P2/b2/n21/n":
        return (52,3)
    case "P c n n":
        return (52,4)
    case "P 2/c 21/n 2/n":
        return (52,4)
    case "Pcnn":
        return (52,4)
    case "P2/c21/n2/n":
        return (52,4)
    case "P n c n":
        return (52,5)
    case "P 21/n 2/c 2/n":
        return (52,5)
    case "Pncn":
        return (52,5)
    case "P21/n2/c2/n":
        return (52,5)
    case "P n a n":
        return (52,6)
    case "P 2/n 2/a 21/n":
        return (52,6)
    case "Pnan":
        return (52,6)
    case "P2/n2/a21/n":
        return (52,6)
    case "P m n a":
        return (53,1)
    case "P 2/m 2/n 21/a":
        return (53,1)
    case "Pmna":
        return (53,1)
    case "P2/m2/n21/a":
        return (53,1)
    case "P n m b":
        return (53,2)
    case "P 2/n 2/m 21/b":
        return (53,2)
    case "Pnmb":
        return (53,2)
    case "P2/n2/m21/b":
        return (53,2)
    case "P b m n":
        return (53,3)
    case "P 21/b 2/m 2/n":
        return (53,3)
    case "Pbmn":
        return (53,3)
    case "P21/b2/m2/n":
        return (53,3)
    case "P c n m":
        return (53,4)
    case "P 21/c 2/n 2/m":
        return (53,4)
    case "Pcnm":
        return (53,4)
    case "P21/c2/n2/m":
        return (53,4)
    case "P n c m":
        return (53,5)
    case "P 2/n 21/c 2/m":
        return (53,5)
    case "Pncm":
        return (53,5)
    case "P2/n21/c2/m":
        return (53,5)
    case "P m a n":
        return (53,6)
    case "P 2/m 21/a 2/n":
        return (53,6)
    case "Pman":
        return (53,6)
    case "P2/m21/a2/n":
        return (53,6)
    case "P c c a":
        return (54,1)
    case "P 21/c 2/c 2/a":
        return (54,1)
    case "Pcca":
        return (54,1)
    case "P21/c2/c2/a":
        return (54,1)
    case "P c c b":
        return (54,2)
    case "P 2/c 21/c 2/b":
        return (54,2)
    case "Pccb":
        return (54,2)
    case "P2/c21/c2/b":
        return (54,2)
    case "P b a a":
        return (54,3)
    case "P 2/b 21/a 2/a":
        return (54,3)
    case "Pbaa":
        return (54,3)
    case "P2/b21/a2/a":
        return (54,3)
    case "P c a a":
        return (54,4)
    case "P 2/c 2/a 21/a":
        return (54,4)
    case "Pcaa":
        return (54,4)
    case "P2/c2/a21/a":
        return (54,4)
    case "P b c b":
        return (54,5)
    case "P 2/b 2/c 21/b":
        return (54,5)
    case "Pbcb":
        return (54,5)
    case "P2/b2/c21/b":
        return (54,5)
    case "P b a b":
        return (54,6)
    case "P 21/b 2/a 2/b":
        return (54,6)
    case "Pbab":
        return (54,6)
    case "P21/b2/a2/b":
        return (54,6)
    case "P b a m":
        return (55,1)
    case "P 21/b 21/a 2/m":
        return (55,1)
    case "Pbam":
        return (55,1)
    case "P21/b21/a2/m":
        return (55,1)
    case "P m c b":
        return (55,3)
    case "P 2/m 21/c 21/b":
        return (55,3)
    case "Pmcb":
        return (55,3)
    case "P2/m21/c21/b":
        return (55,3)
    case "P c m a":
        return (55,5)
    case "P 21/c 2/m 21/a":
        return (55,5)
    case "Pcma":
        return (55,5)
    case "P21/c2/m21/a":
        return (55,5)
    case "P c c n":
        return (56,1)
    case "P 21/c 21/c 2/n":
        return (56,1)
    case "Pccn":
        return (56,1)
    case "P21/c21/c2/n":
        return (56,1)
    case "P n a a":
        return (56,3)
    case "P 2/n 21/a 21/a":
        return (56,3)
    case "Pnaa":
        return (56,3)
    case "P2/n21/a21/a":
        return (56,3)
    case "P b n b":
        return (56,5)
    case "P 21/b 2/n 21/b":
        return (56,5)
    case "Pbnb":
        return (56,5)
    case "P21/b2/n21/b":
        return (56,5)
    case "P b c m":
        return (57,1)
    case "P 2/b 21/c 21/m":
        return (57,1)
    case "Pbcm":
        return (57,1)
    case "P2/b21/c21/m":
        return (57,1)
    case "P c a m":
        return (57,2)
    case "P 21/c 2/a 21/m":
        return (57,2)
    case "Pcam":
        return (57,2)
    case "P21/c2/a21/m":
        return (57,2)
    case "P m c a":
        return (57,3)
    case "P 21/m 2/c 21/a":
        return (57,3)
    case "Pmca":
        return (57,3)
    case "P21/m2/c21/a":
        return (57,3)
    case "P m a b":
        return (57,4)
    case "P 21/m 21/a 2/b":
        return (57,4)
    case "Pmab":
        return (57,4)
    case "P21/m21/a2/b":
        return (57,4)
    case "P b m a":
        return (57,5)
    case "P 21/b 21/m 2/a":
        return (57,5)
    case "Pbma":
        return (57,5)
    case "P21/b21/m2/a":
        return (57,5)
    case "P c m b":
        return (57,6)
    case "P 2/c 21/m 21/b":
        return (57,6)
    case "Pcmb":
        return (57,6)
    case "P2/c21/m21/b":
        return (57,6)
    case "P n n m":
        return (58,1)
    case "P 21/n 21/n 2/m":
        return (58,1)
    case "Pnnm":
        return (58,1)
    case "P21/n21/n2/m":
        return (58,1)
    case "P m n n":
        return (58,3)
    case "P 2/m 21/n 21/n":
        return (58,3)
    case "Pmnn":
        return (58,3)
    case "P2/m21/n21/n":
        return (58,3)
    case "P n m n":
        return (58,5)
    case "P 21/n 2/m 21/n":
        return (58,5)
    case "Pnmn":
        return (58,5)
    case "P21/n2/m21/n":
        return (58,5)
    case "P m m n":
        return (59,1)
    case "P 21/m 21/m 2/n":
        return (59,1)
    case "Pmmn":
        return (59,1)
    case "P21/m21/m2/n":
        return (59,1)
    case "P n m m":
        return (59,5)
    case "P 2/n 21/m 21/m":
        return (59,5)
    case "Pnmm":
        return (59,5)
    case "P2/n21/m21/m":
        return (59,5)
    case "P m n m":
        return (59,9)
    case "P 21/m 2/n 21/m":
        return (59,9)
    case "Pmnm":
        return (59,9)
    case "P21/m2/n21/m":
        return (59,9)
    case "P b c n":
        return (60,1)
    case "P 21/b 2/c 21/n":
        return (60,1)
    case "Pbcn":
        return (60,1)
    case "P21/b2/c21/n":
        return (60,1)
    case "P c a n":
        return (60,2)
    case "P 2/c 21/a 21/n":
        return (60,2)
    case "Pcan":
        return (60,2)
    case "P2/c21/a21/n":
        return (60,2)
    case "P n c a":
        return (60,3)
    case "P 21/n 21/c 2/a":
        return (60,3)
    case "Pnca":
        return (60,3)
    case "P21/n21/c2/a":
        return (60,3)
    case "P n a b":
        return (60,4)
    case "P 21/n 2/a 21/b":
        return (60,4)
    case "Pnab":
        return (60,4)
    case "P21/n2/a21/b":
        return (60,4)
    case "P b n a":
        return (60,5)
    case "P 2/b 21/n 21/a":
        return (60,5)
    case "Pbna":
        return (60,5)
    case "P2/b21/n21/a":
        return (60,5)
    case "P c n b":
        return (60,6)
    case "P 21/c 21/n 2/b":
        return (60,6)
    case "Pcnb":
        return (60,6)
    case "P21/c21/n2/b":
        return (60,6)
    case "P b c a":
        return (61,1)
    case "P 21/b 21/c 21/a":
        return (61,1)
    case "Pbca":
        return (61,1)
    case "P21/b21/c21/a":
        return (61,1)
    case "P c a b":
        return (61,2)
    case "P 21/c 21/a 21/b":
        return (61,2)
    case "Pcab":
        return (61,2)
    case "P21/c21/a21/b":
        return (61,2)
    case "P n m a":
        return (62,1)
    case "P 21/n 21/m 21/a":
        return (62,1)
    case "Pnma":
        return (62,1)
    case "P21/n21/m21/a":
        return (62,1)
    case "P m n b":
        return (62,2)
    case "P 21/m 21/n 21/b":
        return (62,2)
    case "Pmnb":
        return (62,2)
    case "P21/m21/n21/b":
        return (62,2)
    case "P b n m":
        return (62,3)
    case "P 21/b 21/n 21/m":
        return (62,3)
    case "Pbnm":
        return (62,3)
    case "P21/b21/n21/m":
        return (62,3)
    case "P c m n":
        return (62,4)
    case "P 21/c 21/m 21/n":
        return (62,4)
    case "Pcmn":
        return (62,4)
    case "P21/c21/m21/n":
        return (62,4)
    case "P m c n":
        return (62,5)
    case "P 21/m 21/c 21/n":
        return (62,5)
    case "Pmcn":
        return (62,5)
    case "P21/m21/c21/n":
        return (62,5)
    case "P n a m":
        return (62,6)
    case "P 21/n 21/a 21/m":
        return (62,6)
    case "Pnam":
        return (62,6)
    case "P21/n21/a21/m":
        return (62,6)
    case "C m c m":
        return (63,1)
    case "C 2/m 2/c 21/m":
        return (63,1)
    case "Cmcm":
        return (63,1)
    case "C2/m2/c21/m":
        return (63,1)
    case "C c m m":
        return (63,2)
    case "C 2/c 2/m 21/m":
        return (63,2)
    case "Ccmm":
        return (63,2)
    case "C2/c2/m21/m":
        return (63,2)
    case "A m m a":
        return (63,3)
    case "A 21/m 2/m 2/a":
        return (63,3)
    case "Amma":
        return (63,3)
    case "A21/m2/m2/a":
        return (63,3)
    case "A m a m":
        return (63,4)
    case "A 21/m 2/a 2/m":
        return (63,4)
    case "Amam":
        return (63,4)
    case "A21/m2/a2/m":
        return (63,4)
    case "B b m m":
        return (63,5)
    case "B 2/b 21/m 2/m":
        return (63,5)
    case "Bbmm":
        return (63,5)
    case "B2/b21/m2/m":
        return (63,5)
    case "B m m b":
        return (63,6)
    case "B 2/m 21/m 2/b":
        return (63,6)
    case "Bmmb":
        return (63,6)
    case "B2/m21/m2/b":
        return (63,6)
    case "C m c a":
        return (64,1)
    case "C 2/m 2/c 21/a":
        return (64,1)
    case "Cmca":
        return (64,1)
    case "C2/m2/c21/a":
        return (64,1)
    case "C c m b":
        return (64,2)
    case "C 2/c 2/m 21/b":
        return (64,2)
    case "Ccmb":
        return (64,2)
    case "C2/c2/m21/b":
        return (64,2)
    case "A b m a":
        return (64,3)
    case "A 21/b 2/m a":
        return (64,3)
    case "Abma":
        return (64,3)
    case "A21/b2/ma":
        return (64,3)
    case "A c a m":
        return (64,4)
    case "A 21/c 2/a 2/m":
        return (64,4)
    case "Acam":
        return (64,4)
    case "A21/c2/a2/m":
        return (64,4)
    case "B b c m":
        return (64,5)
    case "B 2/b 21/c 2/m":
        return (64,5)
    case "Bbcm":
        return (64,5)
    case "B2/b21/c2/m":
        return (64,5)
    case "B m a b":
        return (64,6)
    case "B 2/m 21/a 2/b":
        return (64,6)
    case "Bmab":
        return (64,6)
    case "B2/m21/a2/b":
        return (64,6)
    case "C m m m":
        return (65,1)
    case "C 2/m 2/m 2/m":
        return (65,1)
    case "Cmmm":
        return (65,1)
    case "C2/m2/m2/m":
        return (65,1)
    case "A m m m":
        return (65,3)
    case "A 2/m 2/m 2/m":
        return (65,3)
    case "Ammm":
        return (65,3)
    case "A2/m2/m2/m":
        return (65,3)
    case "B m m m":
        return (65,5)
    case "B 2/m 2/m 2/m":
        return (65,5)
    case "Bmmm":
        return (65,5)
    case "B2/m2/m2/m":
        return (65,5)
    case "C c c m":
        return (66,1)
    case "C 2/c 2/c 2/m":
        return (66,1)
    case "Cccm":
        return (66,1)
    case "C2/c2/c2/m":
        return (66,1)
    case "A m a a":
        return (66,3)
    case "A 2/m 2/a 2/a":
        return (66,3)
    case "Amaa":
        return (66,3)
    case "A2/m2/a2/a":
        return (66,3)
    case "B b m b":
        return (66,5)
    case "B 2/b 2/m 2/b":
        return (66,5)
    case "Bbmb":
        return (66,5)
    case "B2/b2/m2/b":
        return (66,5)
    case "C m m a":
        return (67,1)
    case "C 2/m 2/m 2/a":
        return (67,1)
    case "Cmma":
        return (67,1)
    case "C2/m2/m2/a":
        return (67,1)
    case "C m m b":
        return (67,2)
    case "C 2/m 2/m 2/b":
        return (67,2)
    case "Cmmb":
        return (67,2)
    case "C2/m2/m2/b":
        return (67,2)
    case "A b m m":
        return (67,3)
    case "A 2/b 2/m 2/m":
        return (67,3)
    case "Abmm":
        return (67,3)
    case "A2/b2/m2/m":
        return (67,3)
    case "A c m m":
        return (67,4)
    case "A 2/c 2/m 2/m":
        return (67,4)
    case "Acmm":
        return (67,4)
    case "A2/c2/m2/m":
        return (67,4)
    case "B m c m":
        return (67,5)
    case "B 2/m 2/c 2/m":
        return (67,5)
    case "Bmcm":
        return (67,5)
    case "B2/m2/c2/m":
        return (67,5)
    case "B m a m":
        return (67,6)
    case "B 2/m 2/a 2/m":
        return (67,6)
    case "Bmam":
        return (67,6)
    case "B2/m2/a2/m":
        return (67,6)
    case "C c c a":
        return (68,1)
    case "C 2/c 2/c 2/a":
        return (68,1)
    case "Ccca":
        return (68,1)
    case "C2/c2/c2/a":
        return (68,1)
    case "C c c b":
        return (68,3)
    case "C 2/c 2/c 2/b":
        return (68,3)
    case "Cccb":
        return (68,3)
    case "C2/c2/c2/b":
        return (68,3)
    case "A b a a":
        return (68,5)
    case "A 2/b 2/a 2/a":
        return (68,5)
    case "Abaa":
        return (68,5)
    case "A2/b2/a2/a":
        return (68,5)
    case "A c a a":
        return (68,7)
    case "A 2/c 2/a 2/a":
        return (68,7)
    case "Acaa":
        return (68,7)
    case "A2/c2/a2/a":
        return (68,7)
    case "B b c b":
        return (68,9)
    case "B 2/b 2/c 2/b":
        return (68,9)
    case "Bbcb":
        return (68,9)
    case "B2/b2/c2/b":
        return (68,9)
    case "B b a b":
        return (68,11)
    case "B 2/b 2/a 2/b":
        return (68,11)
    case "Bbab":
        return (68,11)
    case "B2/b2/a2/b":
        return (68,11)
    case "F m m m":
        return (69,1)
    case "F 2/m 2/m 2/m":
        return (69,1)
    case "Fmmm":
        return (69,1)
    case "F2/m2/m2/m":
        return (69,1)
    case "F d d d":
        return (70,1)
    case "F 2/d 2/d 2/d":
        return (70,1)
    case "Fddd":
        return (70,1)
    case "F2/d2/d2/d":
        return (70,1)
    case "I m m m":
        return (71,1)
    case "I 2/m 2/m 2/m":
        return (71,1)
    case "Immm":
        return (71,1)
    case "I2/m2/m2/m":
        return (71,1)
    case "I b a m":
        return (72,1)
    case "I 2/b 2/a 2/m":
        return (72,1)
    case "Ibam":
        return (72,1)
    case "I2/b2/a2/m":
        return (72,1)
    case "I m c b":
        return (72,3)
    case "I 2/m 2/c 2/b":
        return (72,3)
    case "Imcb":
        return (72,3)
    case "I2/m2/c2/b":
        return (72,3)
    case "I c m a":
        return (72,5)
    case "I 2/c 2/m 2/a":
        return (72,5)
    case "Icma":
        return (72,5)
    case "I2/c2/m2/a":
        return (72,5)
    case "I b c a":
        return (73,1)
    case "I 2/b 2/c 2/a":
        return (73,1)
    case "Ibca":
        return (73,1)
    case "I2/b2/c2/a":
        return (73,1)
    case "I c a b":
        return (73,2)
    case "I 2/c 2/a 2/b":
        return (73,2)
    case "Icab":
        return (73,2)
    case "I2/c2/a2/b":
        return (73,2)
    case "I m m a":
        return (74,1)
    case "I 2/m 2/m 2/a":
        return (74,1)
    case "Imma":
        return (74,1)
    case "I2/m2/m2/a":
        return (74,1)
    case "I m m b":
        return (74,2)
    case "I 2/m 2/m 2/b":
        return (74,2)
    case "Immb":
        return (74,2)
    case "I2/m2/m2/b":
        return (74,2)
    case "I b m m":
        return (74,3)
    case "I 2/b 2/m 2/m":
        return (74,3)
    case "Ibmm":
        return (74,3)
    case "I2/b2/m2/m":
        return (74,3)
    case "I c m m":
        return (74,4)
    case "I 2/c 2/m 2/m":
        return (74,4)
    case "Icmm":
        return (74,4)
    case "I2/c2/m2/m":
        return (74,4)
    case "I m c m":
        return (74,5)
    case "I 2/m 2/c 2/m":
        return (74,5)
    case "Imcm":
        return (74,5)
    case "I2/m2/c2/m":
        return (74,5)
    case "I m a m":
        return (74,6)
    case "I 2/m 2/a 2/m":
        return (74,6)
    case "Imam":
        return (74,6)
    case "I2/m2/a2/m":
        return (74,6)
    case "P 4":
        return (75,1)
    case "P4":
        return (75,1)
    case "P 41":
        return (76,1)
    case "P41":
        return (76,1)
    case "P 42":
        return (77,1)
    case "P42":
        return (77,1)
    case "P 43":
        return (78,1)
    case "P43":
        return (78,1)
    case "I 4":
        return (79,1)
    case "I4":
        return (79,1)
    case "I 41":
        return (80,1)
    case "I41":
        return (80,1)
    case "P -4":
        return (81,1)
    case "P-4":
        return (81,1)
    case "I -4":
        return (82,1)
    case "I-4":
        return (82,1)
    case "P 4/m":
        return (83,1)
    case "P4/m":
        return (83,1)
    case "P 42/m":
        return (84,1)
    case "P42/m":
        return (84,1)
    case "P 4/n":
        return (85,1)
    case "P4/n":
        return (85,1)
    case "P 42/n":
        return (86,1)
    case "P42/n":
        return (86,1)
    case "I 4/m":
        return (87,1)
    case "I4/m":
        return (87,1)
    case "I 41/a":
        return (88,1)
    case "I41/a":
        return (88,1)
    case "P 4 2 2":
        return (89,1)
    case "P422":
        return (89,1)
    case "P 4 21 2":
        return (90,1)
    case "P4212":
        return (90,1)
    case "P 41 2 2":
        return (91,1)
    case "P4122":
        return (91,1)
    case "P 41 21 2":
        return (92,1)
    case "P41212":
        return (92,1)
    case "P 42 2 2":
        return (93,1)
    case "P4222":
        return (93,1)
    case "P 42 21 2":
        return (94,1)
    case "P42212":
        return (94,1)
    case "P 43 2 2":
        return (95,1)
    case "P4322":
        return (95,1)
    case "P 43 21 2":
        return (96,1)
    case "P43212":
        return (96,1)
    case "I 4 2 2":
        return (97,1)
    case "I422":
        return (97,1)
    case "I 41 2 2":
        return (98,1)
    case "I4122":
        return (98,1)
    case "P 4 m m":
        return (99,1)
    case "P4mm":
        return (99,1)
    case "P 4 b m":
        return (100,1)
    case "P4bm":
        return (100,1)
    case "P 42 c m":
        return (101,1)
    case "P42cm":
        return (101,1)
    case "P 42 n m":
        return (102,1)
    case "P42nm":
        return (102,1)
    case "P 4 c c":
        return (103,1)
    case "P4cc":
        return (103,1)
    case "P 4 n c":
        return (104,1)
    case "P4nc":
        return (104,1)
    case "P 42 m c":
        return (105,1)
    case "P42mc":
        return (105,1)
    case "P 42 b c":
        return (106,1)
    case "P42bc":
        return (106,1)
    case "I 4 m m":
        return (107,1)
    case "I4mm":
        return (107,1)
    case "I 4 c m":
        return (108,1)
    case "I4cm":
        return (108,1)
    case "I 41 m d":
        return (109,1)
    case "I41md":
        return (109,1)
    case "I 41 c d":
        return (110,1)
    case "I41cd":
        return (110,1)
    case "P -4 2 m":
        return (111,1)
    case "P-42m":
        return (111,1)
    case "P -4 2 c":
        return (112,1)
    case "P-42c":
        return (112,1)
    case "P -4 21 m":
        return (113,1)
    case "P-421m":
        return (113,1)
    case "P -4 21 c":
        return (114,1)
    case "P-421c":
        return (114,1)
    case "P -4 m 2":
        return (115,1)
    case "P-4m2":
        return (115,1)
    case "P -4 c 2":
        return (116,1)
    case "P-4c2":
        return (116,1)
    case "P -4 b 2":
        return (117,1)
    case "P-4b2":
        return (117,1)
    case "P -4 n 2":
        return (118,1)
    case "P-4n2":
        return (118,1)
    case "I -4 m 2":
        return (119,1)
    case "I-4m2":
        return (119,1)
    case "I -4 c 2":
        return (120,1)
    case "I-4c2":
        return (120,1)
    case "I -4 2 m":
        return (121,1)
    case "I-42m":
        return (121,1)
    case "I -4 2 d":
        return (122,1)
    case "I-42d":
        return (122,1)
    case "P 4/m m m":
        return (123,1)
    case "P 4/m 2/m 2/m":
        return (123,1)
    case "P4/mmm":
        return (123,1)
    case "P4/m2/m2/m":
        return (123,1)
    case "P 4/m c c":
        return (124,1)
    case "P 4/m 2/c 2/c":
        return (124,1)
    case "P4/mcc":
        return (124,1)
    case "P4/m2/c2/c":
        return (124,1)
    case "P 4/n b m":
        return (125,1)
    case "P 4/n 2/b 2/m":
        return (125,1)
    case "P4/nbm":
        return (125,1)
    case "P4/n2/b2/m":
        return (125,1)
    case "P 4/n n c":
        return (126,1)
    case "P 4/n 2/n 2/c":
        return (126,1)
    case "P4/nnc":
        return (126,1)
    case "P4/n2/n2/c":
        return (126,1)
    case "P 4/m b m":
        return (127,1)
    case "P 4/m 21/b m":
        return (127,1)
    case "P4/mbm":
        return (127,1)
    case "P4/m21/bm":
        return (127,1)
    case "P 4/m n c":
        return (128,1)
    case "P 4/m 21/n c":
        return (128,1)
    case "P4/mnc":
        return (128,1)
    case "P4/m21/nc":
        return (128,1)
    case "P 4/n m m":
        return (129,1)
    case "P 4/n 21/m m":
        return (129,1)
    case "P4/nmm":
        return (129,1)
    case "P4/n21/mm":
        return (129,1)
    case "P 4/n c c":
        return (130,1)
    case "P 4/n 21/c c":
        return (130,1)
    case "P4/ncc":
        return (130,1)
    case "P4/n21/cc":
        return (130,1)
    case "P 42/m m c":
        return (131,1)
    case "P 42/m 2/m 2/c":
        return (131,1)
    case "P42/mmc":
        return (131,1)
    case "P42/m2/m2/c":
        return (131,1)
    case "P 42/m c m":
        return (132,1)
    case "P 42/m 2/c 2/m":
        return (132,1)
    case "P42/mcm":
        return (132,1)
    case "P42/m2/c2/m":
        return (132,1)
    case "P 42/n b c":
        return (133,1)
    case "P 42/n 2/b 2/c":
        return (133,1)
    case "P42/nbc":
        return (133,1)
    case "P42/n2/b2/c":
        return (133,1)
    case "P 42/n n m":
        return (134,1)
    case "P 42/n 2/n 2/m":
        return (134,1)
    case "P42/nnm":
        return (134,1)
    case "P42/n2/n2/m":
        return (134,1)
    case "P 42/m b c":
        return (135,1)
    case "P 42/m 21/b 2/c":
        return (135,1)
    case "P42/mbc":
        return (135,1)
    case "P42/m21/b2/c":
        return (135,1)
    case "P 42/m n m":
        return (136,1)
    case "P 42/m 21/n 2/m":
        return (136,1)
    case "P42/mnm":
        return (136,1)
    case "P42/m21/n2/m":
        return (136,1)
    case "P 42/n m c":
        return (137,1)
    case "P 42/n 21/m 2/c":
        return (137,1)
    case "P42/nmc":
        return (137,1)
    case "P42/n21/m2/c":
        return (137,1)
    case "P 42/n c m":
        return (138,1)
    case "P 42/n 21/c 2/m":
        return (138,1)
    case "P42/ncm":
        return (138,1)
    case "P42/n21/c2/m":
        return (138,1)
    case "I 4/m m m":
        return (139,1)
    case "I 4/m 2/m 2/m":
        return (139,1)
    case "I4/mmm":
        return (139,1)
    case "I4/m2/m2/m":
        return (139,1)
    case "I 4/m c m":
        return (140,1)
    case "I 4/m 2/c 2/m":
        return (140,1)
    case "I4/mcm":
        return (140,1)
    case "I4/m2/c2/m":
        return (140,1)
    case "I 41/a m d":
        return (141,1)
    case "I 41/a 2/m 2/d":
        return (141,1)
    case "I41/amd":
        return (141,1)
    case "I41/a2/m2/d":
        return (141,1)
    case "I 41/a c d":
        return (142,1)
    case "I 41/a 2/c 2/d":
        return (142,1)
    case "I41/acd":
        return (142,1)
    case "I41/a2/c2/d":
        return (142,1)
    case "P 3":
        return (143,1)
    case "P3":
        return (143,1)
    case "P 31":
        return (144,1)
    case "P31":
        return (144,1)
    case "P 32":
        return (145,1)
    case "P32":
        return (145,1)
    case "R 3":
        return (146,1)
    case "R3":
        return (146,1)
    case "P -3":
        return (147,1)
    case "P-3":
        return (147,1)
    case "R -3":
        return (148,1)
    case "R-3":
        return (148,1)
    case "P 3 1 2":
        return (149,1)
    case "P312":
        return (149,1)
    case "P 3 2 1":
        return (150,1)
    case "P321":
        return (150,1)
    case "P 31 1 2":
        return (151,1)
    case "P3112":
        return (151,1)
    case "P 31 2 1":
        return (152,1)
    case "P3121":
        return (152,1)
    case "P 32 1 2":
        return (153,1)
    case "P3212":
        return (153,1)
    case "P 32 2 1":
        return (154,1)
    case "P3221":
        return (154,1)
    case "R 3 2":
        return (155,1)
    case "R32":
        return (155,1)
    case "P 3 m 1":
        return (156,1)
    case "P3m1":
        return (156,1)
    case "P 3 1 m":
        return (157,1)
    case "P31m":
        return (157,1)
    case "P 3 c 1":
        return (158,1)
    case "P3c1":
        return (158,1)
    case "P 3 1 c":
        return (159,1)
    case "P31c":
        return (159,1)
    case "R 3 m":
        return (160,1)
    case "R3m":
        return (160,1)
    case "R 3 c":
        return (161,1)
    case "R3c":
        return (161,1)
    case "P -3 1 m":
        return (162,1)
    case "P -3 1 2/m":
        return (162,1)
    case "P-31m":
        return (162,1)
    case "P-312/m":
        return (162,1)
    case "P -3 1 c":
        return (163,1)
    case "P -3 1 2/c":
        return (163,1)
    case "P-31c":
        return (163,1)
    case "P-312/c":
        return (163,1)
    case "P -3 m 1":
        return (164,1)
    case "P -3 2/m 1":
        return (164,1)
    case "P-3m1":
        return (164,1)
    case "P-32/m1":
        return (164,1)
    case "P -3 c 1":
        return (165,1)
    case "P -3 2/c 1":
        return (165,1)
    case "P-3c1":
        return (165,1)
    case "P-32/c1":
        return (165,1)
    case "R -3 m":
        return (166,1)
    case "R -3 2/m":
        return (166,1)
    case "R-3m":
        return (166,1)
    case "R-32/m":
        return (166,1)
    case "R -3 c":
        return (167,1)
    case "R -3 2/c":
        return (167,1)
    case "R-3c":
        return (167,1)
    case "R-32/c":
        return (167,1)
    case "P 6":
        return (168,1)
    case "P6":
        return (168,1)
    case "P 61":
        return (169,1)
    case "P61":
        return (169,1)
    case "P 65":
        return (170,1)
    case "P65":
        return (170,1)
    case "P 62":
        return (171,1)
    case "P62":
        return (171,1)
    case "P 64":
        return (172,1)
    case "P64":
        return (172,1)
    case "P 63":
        return (173,1)
    case "P63":
        return (173,1)
    case "P -6":
        return (174,1)
    case "P-6":
        return (174,1)
    case "P 6/m":
        return (175,1)
    case "P6/m":
        return (175,1)
    case "P 63/m":
        return (176,1)
    case "P63/m":
        return (176,1)
    case "P 6 2 2":
        return (177,1)
    case "P622":
        return (177,1)
    case "P 61 2 2":
        return (178,1)
    case "P6122":
        return (178,1)
    case "P 65 2 2":
        return (179,1)
    case "P6522":
        return (179,1)
    case "P 62 2 2":
        return (180,1)
    case "P6222":
        return (180,1)
    case "P 64 2 2":
        return (181,1)
    case "P6422":
        return (181,1)
    case "P 63 2 2":
        return (182,1)
    case "P6322":
        return (182,1)
    case "P 6 m m":
        return (183,1)
    case "P6mm":
        return (183,1)
    case "P 6 c c":
        return (184,1)
    case "P6cc":
        return (184,1)
    case "P 63 c m":
        return (185,1)
    case "P63cm":
        return (185,1)
    case "P 63 m c":
        return (186,1)
    case "P63mc":
        return (186,1)
    case "P -6 m 2":
        return (187,1)
    case "P-6m2":
        return (187,1)
    case "P -6 c 2":
        return (188,1)
    case "P-6c2":
        return (188,1)
    case "P -6 2 m":
        return (189,1)
    case "P-62m":
        return (189,1)
    case "P -6 2 c":
        return (190,1)
    case "P-62c":
        return (190,1)
    case "P 6/m m m":
        return (191,1)
    case "P 6/m 2/m 2/m":
        return (191,1)
    case "P6/mmm":
        return (191,1)
    case "P6/m2/m2/m":
        return (191,1)
    case "P 6/m c c":
        return (192,1)
    case "P 6/m 2/c 2/c":
        return (192,1)
    case "P6/mcc":
        return (192,1)
    case "P6/m2/c2/c":
        return (192,1)
    case "P 63/m c m":
        return (193,1)
    case "P 63/m 2/c 2/m":
        return (193,1)
    case "P63/mcm":
        return (193,1)
    case "P63/m2/c2/m":
        return (193,1)
    case "P 63/m m c":
        return (194,1)
    case "P 63/m 2/m 2/c":
        return (194,1)
    case "P63/mmc":
        return (194,1)
    case "P63/m2/m2/c":
        return (194,1)
    case "P 2 3":
        return (195,1)
    case "P23":
        return (195,1)
    case "F 2 3":
        return (196,1)
    case "F23":
        return (196,1)
    case "I 2 3":
        return (197,1)
    case "I23":
        return (197,1)
    case "P 21 3":
        return (198,1)
    case "P213":
        return (198,1)
    case "I 21 3":
        return (199,1)
    case "I213":
        return (199,1)
    case "P m -3":
        return (200,1)
    case "P 2/m -3":
        return (200,1)
    case "Pm-3":
        return (200,1)
    case "P2/m-3":
        return (200,1)
    case "P n -3":
        return (201,1)
    case "P 2/n -3":
        return (201,1)
    case "Pn-3":
        return (201,1)
    case "P2/n-3":
        return (201,1)
    case "F m -3":
        return (202,1)
    case "F 2/m -3":
        return (202,1)
    case "Fm-3":
        return (202,1)
    case "F2/m-3":
        return (202,1)
    case "F d -3":
        return (203,1)
    case "F 2/d -3":
        return (203,1)
    case "Fd-3":
        return (203,1)
    case "F2/d-3":
        return (203,1)
    case "I m -3":
        return (204,1)
    case "I 2/m -3":
        return (204,1)
    case "Im-3":
        return (204,1)
    case "I2/m-3":
        return (204,1)
    case "P a -3":
        return (205,1)
    case "P 21/a -3":
        return (205,1)
    case "Pa-3":
        return (205,1)
    case "P21/a-3":
        return (205,1)
    case "I a -3":
        return (206,1)
    case "I 21/a -3":
        return (206,1)
    case "Ia-3":
        return (206,1)
    case "I21/a-3":
        return (206,1)
    case "P 4 3 2":
        return (207,1)
    case "P432":
        return (207,1)
    case "P 42 3 2":
        return (208,1)
    case "P4232":
        return (208,1)
    case "F 4 3 2":
        return (209,1)
    case "F432":
        return (209,1)
    case "F 41 3 2":
        return (210,1)
    case "F4132":
        return (210,1)
    case "I 4 3 2":
        return (211,1)
    case "I432":
        return (211,1)
    case "P 43 3 2":
        return (212,1)
    case "P4332":
        return (212,1)
    case "P 41 3 2":
        return (213,1)
    case "P4132":
        return (213,1)
    case "I 41 3 2":
        return (214,1)
    case "I4132":
        return (214,1)
    case "P -4 3 m":
        return (215,1)
    case "P-43m":
        return (215,1)
    case "F -4 3 m":
        return (216,1)
    case "F-43m":
        return (216,1)
    case "I -4 3 m":
        return (217,1)
    case "I-43m":
        return (217,1)
    case "P -4 3 n":
        return (218,1)
    case "P-43n":
        return (218,1)
    case "F -4 3 c":
        return (219,1)
    case "F-43c":
        return (219,1)
    case "I -4 3 d":
        return (220,1)
    case "I-43d":
        return (220,1)
    case "P m -3 m":
        return (221,1)
    case "P 4/m -3 2/m":
        return (221,1)
    case "Pm-3m":
        return (221,1)
    case "P4/m-32/m":
        return (221,1)
    case "P n -3 n":
        return (222,1)
    case "P 4/n -3 2/n":
        return (222,1)
    case "Pn-3n":
        return (222,1)
    case "P4/n-32/n":
        return (222,1)
    case "P m -3 n":
        return (223,1)
    case "P 42/m -3 2/n":
        return (223,1)
    case "Pm-3n":
        return (223,1)
    case "P42/m-32/n":
        return (223,1)
    case "P n -3 m":
        return (224,1)
    case "P 42/n -3 2/m":
        return (224,1)
    case "Pn-3m":
        return (224,1)
    case "P42/n-32/m":
        return (224,1)
    case "F m -3 m":
        return (225,1)
    case "F 4/m -3 2/m":
        return (225,1)
    case "Fm-3m":
        return (225,1)
    case "F4/m-32/m":
        return (225,1)
    case "F m -3 c":
        return (226,1)
    case "F 4/m -3 2/c":
        return (226,1)
    case "Fm-3c":
        return (226,1)
    case "F4/m-32/c":
        return (226,1)
    case "F d -3 m":
        return (227,1)
    case "F 41/d -3 2/m":
        return (227,1)
    case "Fd-3m":
        return (227,1)
    case "F41/d-32/m":
        return (227,1)
    case "F d -3 c":
        return (228,1)
    case "F 41/d -3 2/c":
        return (228,1)
    case "Fd-3c":
        return (228,1)
    case "F41/d-32/c":
        return (228,1)
    case "I m -3 m":
        return (229,1)
    case "I 4/m -3 2/m":
        return (229,1)
    case "Im-3m":
        return (229,1)
    case "I4/m-32/m":
        return (229,1)
    case "I a -3 d":
        return (230,1)
    case "I 41/a -3 2/d":
        return (230,1)
    case "Ia-3d":
        return (230,1)
    case "I41/a-32/d":
        return (230,1)
    default:
        return nil
    }
}
