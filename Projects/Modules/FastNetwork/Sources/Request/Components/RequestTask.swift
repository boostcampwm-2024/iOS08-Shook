import Foundation

// MARK: - RequestTask

public enum RequestTask {
    case empty
    case withParameters(
        body: Parameters? = nil,
        query: Parameters? = nil,
        bodyEncoder: any RequestParameterEncodable = .json,
        urlQueryEncoder: any RequestParameterEncodable = .query
    )
    case withObject(
        body: any Encodable,
        query: Parameters? = nil,
        urlQueryEncoder: any RequestParameterEncodable = .query
    )
}

extension RequestTask {
    func configureRequest(request: inout URLRequest) throws {
        switch self {
        case .empty:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        case let .withParameters(body, query, bodyEncoder, urlQueryEncoder):
            try configureParam(
                request: &request,
                body: body,
                query: query,
                bodyEncoder: bodyEncoder,
                urlQueryEncoder: urlQueryEncoder
            )

        case let .withObject(body, query, urlQueryEncoder):
            try configureObject(
                request: &request,
                body: body,
                query: query,
                urlQueryEncoder: urlQueryEncoder
            )
        }
    }

    func configureParam(
        request: inout URLRequest,
        body: Parameters?,
        query: Parameters?,
        bodyEncoder: any RequestParameterEncodable,
        urlQueryEncoder: any RequestParameterEncodable
    ) throws {
        if let body {
            try bodyEncoder.encode(request: &request, with: body)
        }

        if let query {
            try urlQueryEncoder.encode(request: &request, with: query)
        }
    }

    func configureObject(
        request: inout URLRequest,
        body: any Encodable,
        query: Parameters?,
        urlQueryEncoder: any RequestParameterEncodable
    ) throws {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        if let query {
            try urlQueryEncoder.encode(request: &request, with: query)
        }
    }
}
