import CommonCrypto
import Foundation

import NetworkModule

enum ChatEndpoint {
    case makeRoom(String)
    case deleteRoom(String)
}

extension ChatEndpoint: Endpoint {
    var method: NetworkModule.HTTPMethod {
        switch self {
        case .makeRoom:
            return .post
            
        case .deleteRoom:
            return .delete
        }
    }
    
    var header: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var host: String {
        "http://127.0.0.1"
    }
    
    var path: String {
        switch self {
        case .makeRoom:
            return "/chat"
            
        case let .deleteRoom(id):
            return "/chat/\(id)"
        }
    }
    
    var requestTask: NetworkModule.RequestTask {
        switch self {
        case let .makeRoom(id):
            return .withObject(body: MakeRoomRequestDTO(id: id))
            
        case .deleteRoom:
            return .empty
        }
    }
    
}
