import Foundation

public enum RequestTask {
    case empty
    case withParamteres(
        body: Parameters? = nil,
        query: Parameters? = nil,
        bodyEncoder: any RequestParameterEncodable = .json(),
        urlqueryEncoder: any RequestParameterEncodable = .query()
    )
    case withObject(
        body: any Encodable,
        query: Parameters? = nil,
        urlqueryEncoder: any RequestParameterEncodable = .query()
    )
}

extension RequestTask {
    func configureRequest(request: inout URLRequest) throws {
        switch self {
        case .empty:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        case let .withParamteres(body, query, bodyEncoder, urlqueryEncoder):
            try configureParam(request: &request, body: body, query: query, bodyEncoder: bodyEncoder, urlqueryEncoder: urlqueryEncoder)
        
        case let .withObject(body, query, urlqueryEncoder):
            try configureObject(request: &request, body: body, query: query, urlqueryEncoder: urlqueryEncoder)
        }
    }
    
    func configureParam(
        request: inout URLRequest,
        body: Parameters?,
        query: Parameters?,
        bodyEncoder: any RequestParameterEncodable,
        urlqueryEncoder: any RequestParameterEncodable
    ) throws {
        if let body {
            try bodyEncoder.encode(request: &request, with: body)
        }
        
        if let query {
            try urlqueryEncoder.encode(request: &request, with: query)
        }
    }
        
    func configureObject(
        request: inout URLRequest,
        body: any Encodable,
        query: Parameters?,
        urlqueryEncoder: any RequestParameterEncodable
    ) throws {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        if let query {
            try urlqueryEncoder.encode(request: &request, with: query)
        }
    }
}
