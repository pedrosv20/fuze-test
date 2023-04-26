import Combine
import Foundation

public struct HTTPClient {
    private init() {}
    
    public static let shared: HTTPClient = .init()
}


public extension HTTPClient {
    func request<T: Decodable>(
        from endpoint: Endpoint,
        responseModel: T.Type
    ) -> AnyPublisher<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = [
            .init(name: "sort", value: ""),
            .init(name: "page", value: "1"),
            .init(name: "per_page", value: "10"),
            
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element throws -> T in
                guard let response = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                switch response.statusCode {
                case 200...299:
                    do {
                        let decodedResponse = try JSONDecoder().decode(responseModel, from: element.data)
                        
                        return decodedResponse
                    } catch {
                        print(error)
                        throw RequestError.decode(String(describing: responseModel.self))
                    }
                    
                    
                case 401:
                    throw RequestError.unauthorized
                default:
                    throw RequestError.unknown
                }
            }
            .mapError { error in
                guard let requestError = error as? RequestError else {
                    return .unknown
                }
                return requestError
            }
            .eraseToAnyPublisher()
    }
}
