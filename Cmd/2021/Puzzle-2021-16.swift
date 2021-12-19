//
//  Puzzle-2021-16.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-17.
//

import Foundation

func puzzle2021_16() {
    one()
}

fileprivate enum State {
    case version
    case type
    case numberGroup
    case operatorLengthType
    case number
    case skip(count: Int)
    case operator15
    case operator11

    var bits: Int {
        switch self {
        case .version: return 3
        case .type: return 3
        case .numberGroup: return 1
        case .operatorLengthType: return 1
        case .number: return 4
        case .skip(let count): return count
        case .operator15: return 15
        case .operator11: return 11

        }
    }
}

fileprivate indirect enum Packet {
    case number(version: Int, type: Int, value: Int)
    case `operator`(version: Int, type: Int, packets: [Packet])

    var versionSum: Int {
        switch self {
        case .number(let version, _, _):
            return version
        case .operator(let version, _, let packets):
            return version + packets.map(\.versionSum).reduce(0, +)
        }
    }

    var value: Int {
        switch self {
        case .number(_, _, let value): return value
        case .operator(_, let type, let packets):
            switch type {
            case 0: return packets.map(\.value).reduce(0, +)
            case 1: return packets.map(\.value).reduce(1, *)
            case 2: return packets.map(\.value).min()!
            case 3: return packets.map(\.value).max()!
            case 5:
                if packets[0].value > packets[1].value {
                    return 1
                }
                return 0
            case 6:
                if packets[0].value < packets[1].value {
                    return 1
                }
                return 0
            case 7:
                if packets[0].value == packets[1].value {
                    return 1
                }
                return 0
            default: fatalError()
            }
        }
    }
}

fileprivate class ReadData {
    var version: Int = 0
    var type: Int = 0
    var isLastNumberGroup: Bool = false
    var number: Int = 0
    var operatorLengthType: Int = 0
    var subpacketsBit: Int = 0
    var subpacketsCount: Int = 0

    private(set) var readBits: Int = 0
    private var _totalBits: Int = 0

    weak var parentData: ReadData?

    init(parentData: ReadData?) {
        self.parentData = parentData
    }

    var totalBits: Int {
        _totalBits + subDatas.map(\.totalBits).reduce(0, +)
    }

    var shouldReadNextPackage: Bool {
        if subpacketsCount > 0 && subDatas.count < subpacketsCount {
            return true
        }
        if subpacketsBit > 0 && subDatas.map(\.totalBits).reduce(0, +) < subpacketsBit {
            return true
        }
        return false
    }

    func readBit() {
        readBits += 1
        _totalBits += 1
    }

    func newState() {
        readBits = 0
    }

    var subDatas: [ReadData] = []

    var packet: Packet {
        switch type {
        case 4:
            return .number(
                version: version,
                type: type,
                value: number
            )
        default:
            return .operator(
                version: version,
                type: type,
                packets: subDatas.map(\.packet)
            )
        }
    }
}

fileprivate func one() {
    print("One")

    let input = "005532447836402684AC7AB3801A800021F0961146B1007A1147C89440294D005C12D2A7BC992D3F4E50C72CDF29EECFD0ACD5CC016962099194002CE31C5D3005F401296CAF4B656A46B2DE5588015C913D8653A3A001B9C3C93D7AC672F4FF78C136532E6E0007FCDFA975A3004B002E69EC4FD2D32CDF3FFDDAF01C91FCA7B41700263818025A00B48DEF3DFB89D26C3281A200F4C5AF57582527BC1890042DE00B4B324DBA4FAFCE473EF7CC0802B59DA28580212B3BD99A78C8004EC300761DC128EE40086C4F8E50F0C01882D0FE29900A01C01C2C96F38FCBB3E18C96F38FCBB3E1BCC57E2AA0154EDEC45096712A64A2520C6401A9E80213D98562653D98562612A06C0143CB03C529B5D9FD87CBA64F88CA439EC5BB299718023800D3CE7A935F9EA884F5EFAE9E10079125AF39E80212330F93EC7DAD7A9D5C4002A24A806A0062019B6600730173640575A0147C60070011FCA005000F7080385800CBEE006800A30C023520077A401840004BAC00D7A001FB31AAD10CC016923DA00686769E019DA780D0022394854167C2A56FB75200D33801F696D5B922F98B68B64E02460054CAE900949401BB80021D0562344E00042A16C6B8253000600B78020200E44386B068401E8391661C4E14B804D3B6B27CFE98E73BCF55B65762C402768803F09620419100661EC2A8CE0008741A83917CC024970D9E718DD341640259D80200008444D8F713C401D88310E2EC9F20F3330E059009118019A8803F12A0FC6E1006E3744183D27312200D4AC01693F5A131C93F5A131C970D6008867379CD3221289B13D402492EE377917CACEDB3695AD61C939C7C10082597E3740E857396499EA31980293F4FD206B40123CEE27CFB64D5E57B9ACC7F993D9495444001C998E66B50896B0B90050D34DF3295289128E73070E00A4E7A389224323005E801049351952694C000"

    var state = State.version

    let rootReadData = ReadData(parentData: nil)
    var currentReadData = rootReadData

    func nextState(_ newState: State) {
        switch newState {
        case .skip(let count) where count <= 0:
            if let parent = currentReadData.parentData {
                if parent.shouldReadNextPackage {
                    let subPacketData = ReadData(parentData: parent)
                    parent.subDatas.append(subPacketData)
                    currentReadData = subPacketData
                    nextState(.version)
                    return
                } else {
                    currentReadData = parent
                    nextState(.skip(count: 0))
                    return
                }
            } else {
                nextState(.skip(count: Int.max))
                return
            }
        default: break

        }
        state = newState
        currentReadData.newState()
    }

    print(input)
    for character in input {
        let binary = String(format: "%04d", Int(String(Int(String(character), radix: 16)!, radix: 2))!)

        for bit in binary {
            print(bit, terminator: "")
            let bit = Int(String(bit))!
            currentReadData.readBit()
            switch state {
            case .version:
                currentReadData.version = (currentReadData.version << 1) | bit
                if currentReadData.readBits >= state.bits {
                    nextState(.type)
                }
            case .type:
                currentReadData.type = (currentReadData.type << 1) | bit
                if currentReadData.readBits >= state.bits {
                    switch currentReadData.type {
                    case 4: nextState(.numberGroup)
                    default: nextState(.operatorLengthType)
                    }
                }
            case .numberGroup:
                currentReadData.isLastNumberGroup = bit == 0
                nextState(.number)
            case .number:
                currentReadData.number = (currentReadData.number << 1) | bit
                if currentReadData.readBits >= state.bits {
                    if currentReadData.isLastNumberGroup {
                        nextState(.skip(count: 4 - currentReadData.readBits))
                    } else {
                        nextState(.numberGroup)
                    }
                }
            case .operatorLengthType:
                currentReadData.operatorLengthType = bit
                if currentReadData.operatorLengthType == 0 {
                    nextState(.operator15)
                } else {
                    nextState(.operator11)
                }
            case .operator15:
                currentReadData.subpacketsBit = (currentReadData.subpacketsBit << 1) | bit
                if currentReadData.readBits >= state.bits {
                    let subPacketData = ReadData(parentData: currentReadData)
                    currentReadData.subDatas.append(subPacketData)
                    currentReadData = subPacketData
                    nextState(.version)
                }
            case .operator11:
                currentReadData.subpacketsCount = (currentReadData.subpacketsCount << 1) | bit
                if currentReadData.readBits >= state.bits {
                    let subPacketData = ReadData(parentData: currentReadData)
                    currentReadData.subDatas.append(subPacketData)
                    currentReadData = subPacketData
                    nextState(.version)
                }
            case .skip(let count):
                nextState(.skip(count: count-1))
            }
        }
    }
    print("")
    let packet = rootReadData.packet
    print(packet)
    print(packet.versionSum)
    print(packet.value)
    
}
