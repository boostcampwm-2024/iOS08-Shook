import Foundation

import LiveStationDomainInterface

public struct ChannelListResponseDTO: Decodable {
    let content: [ChannelResponseDTO]
}
