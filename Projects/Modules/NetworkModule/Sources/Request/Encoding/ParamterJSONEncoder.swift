import Foundation

public struct ParamterJSONEncoder: RequestParameterEncodable {
    
    func encode(request: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw RequestError.jsonEncodingFailed(error)
        }
    }
    
}
