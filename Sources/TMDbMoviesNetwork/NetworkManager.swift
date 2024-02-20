//
//  NetworkManager.swift
//
//
//  Created by Parthiv on 20/02/24.
//

import Foundation

public class NetworkManager {
    
    public static let shared = NetworkManager()
    
    func makerequest(url: URL, method: String, params: [String:Any] = [:], headers: [String:String], completionHandler: ((Data?,URLResponse?,Error?)->())?) {
        func makeJSON(_ obj: Any)-> Data {
            if let data = try? JSONSerialization.data(withJSONObject: obj) {
                return data
            }
            return Data()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        switch method {
        case "POST":
            request.httpBody = params.percentEncoded()
            break
            
        case "GET":
            var urlComponents = URLComponents(string: url.absoluteString)
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            urlComponents?.queryItems = queryItems
            request.url = urlComponents?.url
            
        default:
            break
        }
        
        headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key)})
        let session = URLSession.shared
        print(request.url as Any)
        let task = session.dataTask(with: request) {
            completionHandler?($0,$1,$2)
            print("Response: ",String(data: $0 ?? Data(), encoding: .utf8) as Any)
        }
        task.resume()
    }
    
    
    
    
}
