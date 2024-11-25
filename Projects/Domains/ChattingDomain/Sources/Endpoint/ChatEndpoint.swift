import CommonCrypto
import Foundation

import BaseDomain
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
    
    public var scheme: String {
        "http"
    }
    
    public var host: String {
        config(key: .host)
    }
    
    public var port: Int? {
        Int(config(key: .port)) ?? 0
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
