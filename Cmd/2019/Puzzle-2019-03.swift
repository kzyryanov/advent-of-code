//
//  Puzzle-2019-03.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-11-27.
//

import Foundation

func puzzle2019_03() {

}

fileprivate struct Wire {
    enum Step {
        case left(Int)
        case right(Int)
        case up(Int)
        case down(Int)
    }

    let steps: [Step]
}

fileprivate func solve(wire1: Wire, wire2: Wire) {

}

fileprivate func input() -> (Wire, Wire) {
    (
        Wire(steps: [
            .right(995),.up(982),.right(941),.up(681),.left(40),.down(390),.right(223),.up(84),.left(549),.up(568),.right(693),.down(410),.right(779),.up(33),.left(54),.down(18),.left(201),.up(616),.right(583),.down(502),.right(307),.up(46),.left(726),.down(355),.left(62),.down(973),.right(134),.up(619),.left(952),.up(669),.left(28),.up(729),.left(622),.down(821),.right(814),.down(149),.left(713),.up(380),.right(720),.up(438),.left(112),.up(587),.right(161),.up(789),.right(959),.up(254),.right(51),.up(648),.right(259),.up(555),.right(863),.up(610),.left(33),.down(97),.left(825),.down(489),.right(836),.down(626),.left(849),.down(262),.left(380),.up(831),.right(650),.up(832),.right(339),.down(538),.left(49),.down(808),.left(873),.down(33),.left(405),.down(655),.right(884),.down(630),.right(589),.down(291),.left(675),.down(210),.left(211),.down(325),.left(934),.down(515),.right(896),.up(97),.left(639),.up(654),.left(301),.up(507),.left(642),.down(416),.left(325),.up(696),.left(3),.up(999),.right(88),.down(376),.left(187),.up(107),.right(394),.up(273),.right(117),.down(872),.right(162),.down(496),.left(599),.down(855),.left(961),.up(830),.left(156),.up(999),.left(896),.down(380),.left(476),.up(100),.right(848),.up(547),.left(266),.down(490),.left(87),.down(376),.left(428),.up(265),.right(645),.up(584),.left(623),.down(658),.left(103),.up(946),.right(162),.up(678),.right(532),.down(761),.left(141),.down(48),.left(487),.down(246),.left(85),.down(680),.right(859),.down(345),.left(499),.down(194),.left(815),.down(742),.right(700),.down(141),.left(482),.down(442),.left(943),.down(110),.left(892),.down(486),.left(581),.up(733),.left(109),.down(807),.left(474),.up(866),.right(537),.up(217),.right(237),.up(915),.right(523),.down(394),.left(509),.up(333),.right(734),.up(511),.right(482),.down(921),.right(658),.up(860),.right(112),.up(527),.left(175),.down(619),.right(140),.down(402),.left(254),.down(956),.left(556),.up(447),.left(518),.up(60),.left(306),.up(88),.right(311),.up(654),.left(551),.down(38),.right(750),.up(835),.left(784),.up(648),.left(374),.up(211),.left(635),.up(429),.right(129),.up(849),.right(411),.down(135),.left(980),.up(40),.right(480),.down(91),.right(881),.down(292),.right(474),.down(956),.left(89),.down(640),.left(997),.down(397),.left(145),.down(126),.right(936),.up(135),.left(167),.up(289),.right(560),.down(745),.left(699),.up(978),.left(459),.down(947),.left(782),.up(427),.left(784),.down(561),.right(985),.down(395),.left(358),.down(928),.right(697),.up(561),.left(432),.up(790),.right(112),.down(474),.right(852),.up(862),.right(721),.down(337),.left(355),.up(598),.left(94),.down(951),.left(903),.down(175),.right(981),.down(444),.left(690),.down(729),.left(537),.down(458),.right(883),.up(152),.right(125),.down(363),.left(90),.up(260),.right(410),.down(858),.left(825),.up(185),.right(502),.down(648),.right(793),.down(600),.left(589),.up(931),.left(772),.down(498),.left(871),.up(326),.left(587),.down(789),.left(934),.down(889),.right(621),.up(689),.right(454),.up(475),.left(166),.up(85),.right(749),.down(253),.right(234),.down(96),.right(367),.down(33),.right(831),.down(783),.right(577),.up(402),.right(482),.down(741),.right(737),.down(474),.left(666)
        ]),
        Wire(steps: [
            .left(996),.down(167),.right(633),.down(49),.left(319),.down(985),.left(504),.up(273),.left(330),.up(904),.right(741),.up(886),.left(719),.down(73),.left(570),.up(982),.right(121),.up(878),.right(36),.up(1),.right(459),.down(368),.right(229),.down(219),.right(191),.up(731),.right(493),.up(529),.right(53),.down(613),.right(690),.up(856),.left(470),.down(722),.right(464),.down(378),.left(187),.up(540),.right(990),.up(942),.right(574),.down(991),.right(29),.down(973),.right(905),.down(63),.right(745),.down(444),.left(546),.up(939),.left(848),.up(860),.right(877),.down(181),.left(392),.down(798),.right(564),.down(189),.right(14),.up(120),.right(118),.down(350),.right(798),.up(462),.right(335),.down(497),.right(916),.down(722),.right(398),.up(91),.left(284),.up(660),.right(759),.up(676),.left(270),.up(69),.left(774),.down(850),.right(440),.down(669),.left(994),.up(187),.right(698),.up(864),.right(362),.up(523),.left(128),.up(89),.right(272),.down(40),.left(134),.up(571),.left(594),.down(737),.left(830),.down(956),.left(213),.down(97),.right(833),.up(454),.right(319),.up(809),.left(506),.down(792),.right(746),.up(283),.right(858),.down(743),.right(107),.up(499),.right(102),.down(71),.right(822),.up(9),.left(547),.down(915),.left(717),.down(783),.left(53),.up(871),.right(920),.up(284),.right(378),.up(312),.right(970),.down(316),.right(243),.down(512),.right(439),.up(530),.right(246),.down(824),.right(294),.down(726),.right(541),.down(250),.right(859),.down(134),.right(893),.up(631),.left(288),.down(151),.left(796),.down(759),.right(17),.down(656),.left(562),.up(136),.right(861),.up(42),.left(66),.up(552),.right(240),.down(121),.left(966),.up(288),.left(810),.down(104),.right(332),.up(667),.left(63),.down(463),.right(527),.down(27),.right(238),.down(401),.left(397),.down(888),.right(168),.up(808),.left(976),.down(462),.right(299),.up(385),.left(183),.up(303),.left(121),.up(385),.right(260),.up(80),.right(420),.down(532),.right(725),.up(500),.left(376),.up(852),.right(98),.down(597),.left(10),.down(441),.left(510),.down(592),.left(652),.down(230),.left(290),.up(41),.right(521),.up(726),.right(444),.up(440),.left(192),.down(255),.right(690),.up(141),.right(21),.up(942),.left(31),.up(894),.left(994),.up(472),.left(460),.down(357),.right(150),.down(721),.right(125),.down(929),.right(473),.up(707),.right(670),.down(118),.right(255),.up(287),.right(290),.down(374),.right(223),.up(489),.right(533),.up(49),.left(833),.down(805),.left(549),.down(291),.right(288),.down(664),.right(639),.up(866),.right(205),.down(746),.left(832),.up(864),.left(774),.up(610),.right(186),.down(56),.right(517),.up(294),.left(935),.down(304),.left(581),.up(899),.right(749),.up(741),.right(569),.up(282),.right(460),.down(925),.left(431),.down(168),.right(506),.down(949),.left(39),.down(472),.right(379),.down(125),.right(243),.up(335),.left(310),.down(762),.right(412),.up(426),.left(584),.down(981),.left(971),.up(575),.left(129),.up(885),.left(946),.down(221),.left(779),.up(902),.right(251),.up(75),.left(729),.down(956),.left(211),.down(130),.right(7),.up(664),.left(915),.down(928),.left(613),.up(740),.right(572),.up(733),.right(277),.up(7),.right(953),.down(962),.left(635),.up(641),.left(199)
        ])
    )
}
