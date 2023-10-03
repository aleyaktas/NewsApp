//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//
//


import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }
    
    func getAllNews(query: String, category: String, completion: @escaping (Result<NewsResponse, Error>) -> ()) {
           request(.getAllNews(query: query, category: category), responseType: NewsResponse.self, completion: completion)
       }

}

extension NetworkManager {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let dataRequest = endpoint.request()

        dataRequest.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(T.self, from: data)
                    completion(.success(responseObject))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
