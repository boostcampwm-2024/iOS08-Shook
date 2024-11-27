import Foundation

import BaseDomain
import NetworkModule

public enum BroadcastEndpoint {
    case broadcast(id: String, title: String, owner: String, description: String)
    case all
    case delete(id: String)
}

extension BroadcastEndpoint: Endpoint {
    public var method: NetworkModule.HTTPMethod {
        switch self {
        case .broadcast: .post
        case .all: .get
        case .delete: .delete
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
        case .broadcast: "/broadcast"
        case .all: "/broadcast/all"
        case let .delete(id): "/broadcast/delete/\(id)"
        }
    }
    
    public var requestTask: NetworkModule.RequestTask {
        switch self {
        case let .broadcast(id, title, owner, description): .withObject(
                body: BroadcastDTO(
                    id: id,
                    title: title,
                    owner: owner,
                    description: description
                )
            )
        case .all: .empty
        case .delete: .empty
        }
    }
    
}
