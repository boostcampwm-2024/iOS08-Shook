import CommonCrypto
import Foundation

import NetworkModule

public enum ChatEndpoint {
    case makeRoom(String)
    case deleteRoom(String)
}

extension ChatEndpoint: Endpoint {
    public var method: NetworkModule.HTTPMethod {
        switch self {
        case .makeRoom:
            return .post
            
        case .deleteRoom:
            return .delete
        }
    }
    
    public var header: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    #warning("추후 변경")
    public var scheme: String {
        "http"
    }
    
    public var host: String {
        "127.0.0.1"
    }
    
    public var path: String {
        switch self {
        case .makeRoom:
            return "/chat"
            
        case let .deleteRoom(id):
            return "/chat/delete/\(id)"
        }
    }
    
    public var requestTask: NetworkModule.RequestTask {
        switch self {
        case let .makeRoom(id):
            return .withObject(body: MakeRoomRequestDTO(id: id))
            
        case .deleteRoom:
            return .empty
        }
    }
    
}
