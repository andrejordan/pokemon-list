//
//  NetworkService.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation

protocol NetworkService {
    func fetch<Response: Codable>(endpoint: String, completion: @escaping (Response?, Error?) -> ())
}

final class NetworkServiceURLSession: NetworkService {
    
    func fetch<Response: Codable>(endpoint: String, completion: @escaping (Response?, Error?) -> ()) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: endpoint) else { return }
        print("Network Service: Fetching for URL: \(url.absoluteString)")
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network Service: Get Request Failed: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                } else if let data = data, let response = response as? HTTPURLResponse {
                    do {
                        let decoder = JSONDecoder()
                        let responseObject: Response = try decoder.decode(Response.self, from: data)
                        print("Network Service: Fetch Succeeded: HTTP \(response.statusCode)")
                        completion(responseObject, nil)
                    } catch let error {
                        print("Network Service: Error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
        }.resume()
    }
}
