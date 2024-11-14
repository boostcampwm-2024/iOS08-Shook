import Foundation

public struct ParamterJSONEncoder: RequestParameterEncodable {
    
    public func encode(request: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            #warning("인코딩 에러")
        }
    }
    
}

public extension RequestParameterEncodable where Self == ParamterJSONEncoder {
    static var json: ParamterJSONEncoder {
        ParamterJSONEncoder()
    }
}
