//
//  input_template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

let testInput16 = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""

let input16 = """
Valve MO has flow rate=0; tunnels lead to valves QM, ED
Valve JB has flow rate=0; tunnels lead to valves MH, ZU
Valve BA has flow rate=0; tunnels lead to valves XY, FF
Valve UW has flow rate=0; tunnels lead to valves EU, SX
Valve VS has flow rate=0; tunnels lead to valves MH, QW
Valve IK has flow rate=0; tunnels lead to valves KF, SK
Valve EU has flow rate=10; tunnels lead to valves DX, UW, RY, NC
Valve OA has flow rate=0; tunnels lead to valves SX, FF
Valve NC has flow rate=0; tunnels lead to valves ZZ, EU
Valve YB has flow rate=0; tunnels lead to valves EO, KF
Valve VI has flow rate=0; tunnels lead to valves FF, KF
Valve KQ has flow rate=0; tunnels lead to valves TZ, QL
Valve WU has flow rate=0; tunnels lead to valves NT, NW
Valve IE has flow rate=0; tunnels lead to valves UQ, ZU
Valve UQ has flow rate=0; tunnels lead to valves IE, VC
Valve KF has flow rate=7; tunnels lead to valves YB, RZ, IK, PG, VI
Valve XY has flow rate=18; tunnels lead to valves WZ, DG, BA, ZZ, PN
Valve MJ has flow rate=0; tunnels lead to valves SX, PN
Valve KJ has flow rate=0; tunnels lead to valves QW, ZU
Valve VC has flow rate=16; tunnels lead to valves UQ, HN
Valve SO has flow rate=0; tunnels lead to valves NW, PW
Valve NW has flow rate=3; tunnels lead to valves TY, WI, ED, SO, WU
Valve SZ has flow rate=0; tunnels lead to valves YQ, FF
Valve KU has flow rate=0; tunnels lead to valves WI, MH
Valve QL has flow rate=9; tunnels lead to valves KQ, DW, DX
Valve JF has flow rate=0; tunnels lead to valves NK, NT
Valve KD has flow rate=0; tunnels lead to valves JK, NQ
Valve ED has flow rate=0; tunnels lead to valves NW, MO
Valve SX has flow rate=21; tunnels lead to valves JK, MJ, OA, UW
Valve GD has flow rate=0; tunnels lead to valves ZT, NT
Valve ZU has flow rate=19; tunnels lead to valves KJ, JB, DN, IE
Valve HN has flow rate=0; tunnels lead to valves QW, VC
Valve DN has flow rate=0; tunnels lead to valves UX, ZU
Valve TZ has flow rate=17; tunnel leads to valve KQ
Valve RY has flow rate=0; tunnels lead to valves EU, UL
Valve MH has flow rate=15; tunnels lead to valves KU, JB, VS, NK, GA
Valve FF has flow rate=12; tunnels lead to valves UL, SZ, OA, VI, BA
Valve NK has flow rate=0; tunnels lead to valves MH, JF
Valve HR has flow rate=0; tunnels lead to valves AA, SA
Valve PG has flow rate=0; tunnels lead to valves KF, TY
Valve PN has flow rate=0; tunnels lead to valves XY, MJ
Valve UX has flow rate=0; tunnels lead to valves DN, NT
Valve WZ has flow rate=0; tunnels lead to valves NQ, XY
Valve DG has flow rate=0; tunnels lead to valves SL, XY
Valve XM has flow rate=0; tunnels lead to valves AA, GA
Valve UL has flow rate=0; tunnels lead to valves FF, RY
Valve AA has flow rate=0; tunnels lead to valves PW, ZT, XM, SK, HR
Valve GA has flow rate=0; tunnels lead to valves MH, XM
Valve PW has flow rate=0; tunnels lead to valves SO, AA
Valve NQ has flow rate=25; tunnels lead to valves YQ, WZ, KD
Valve SA has flow rate=0; tunnels lead to valves HR, QM
Valve QW has flow rate=23; tunnels lead to valves KJ, HN, VS
Valve SK has flow rate=0; tunnels lead to valves IK, AA
Valve YQ has flow rate=0; tunnels lead to valves SZ, NQ
Valve ZT has flow rate=0; tunnels lead to valves GD, AA
Valve QM has flow rate=8; tunnels lead to valves SL, SA, EO, DW, MO
Valve NT has flow rate=13; tunnels lead to valves WU, UX, RZ, JF, GD
Valve JK has flow rate=0; tunnels lead to valves SX, KD
Valve SL has flow rate=0; tunnels lead to valves DG, QM
Valve WI has flow rate=0; tunnels lead to valves KU, NW
Valve EO has flow rate=0; tunnels lead to valves QM, YB
Valve DW has flow rate=0; tunnels lead to valves QM, QL
Valve DX has flow rate=0; tunnels lead to valves EU, QL
Valve RZ has flow rate=0; tunnels lead to valves NT, KF
Valve TY has flow rate=0; tunnels lead to valves NW, PG
Valve ZZ has flow rate=0; tunnels lead to valves XY, NC
"""
