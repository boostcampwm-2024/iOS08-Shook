import Foundation

import BaseDomain
import FastNetwork

// MARK: - BroadcastEndpoint

public enum BroadcastEndpoint {
    case make(id: String, title: String, owner: String, description: String)
    case fetchAll
    case delete(id: String)
}

// MARK: Endpoint

extension BroadcastEndpoint: Endpoint {
    public var method: FastNetwork.HTTPMethod {
        switch self {
        case .make: .post
        case .fetchAll: .get
        case .delete: .delete
        }
    }

    public var header: [String: String]? {
        [
            "Content-Type": "application/json",
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
        case .make: "/broadcast"
        case .fetchAll: "/broadcast/all"
        case let .delete(id): "/broadcast/delete/\(id)"
        }
    }

    public var requestTask: FastNetwork.RequestTask {
        switch self {
        case let .make(id, title, owner, description): .withObject(
                body: BroadcastDTO(
                    id: id,
                    title: title,
                    owner: owner,
                    description: description
                )
            )
        case .fetchAll: .empty
        case .delete: .empty
        }
    }
}
