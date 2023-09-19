//
//  Endpoint.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//
//


import Foundation
import Alamofire

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    func request() -> DataRequest
}

extension EndpointProtocol {
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters? {
        return nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Endpoint {
    case getAllNews(query: String = "", category: String = "")
}

extension Endpoint: EndpointProtocol {
    
    var baseURL: String {
        return getKeys(key: "baseUrl")
    }
    
    var apiKey: String {
        return getKeys(key: "apiKey")
    }
    
    var path: String {
        switch self {
        case .getAllNews:
            return "/top-headlines"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        let language = UserDefaults.standard.string(forKey: "AppSelectedLanguage") ?? "US"
        switch self {
        case .getAllNews(let query, let category):
            return [
                "q": query,
                "country": language == "en" ? "us" : language,
                "apiKey": apiKey,
                "category": category
            ]
        }
    }
    
    func request() -> DataRequest {
        let url = baseURL + path
        return AF.request(url, method: method, parameters: parameters, headers: headers)
    }
    
    func getKeys(key: String) -> String {
        if let path = Bundle.main.path(forResource: "EnvironmentVariables", ofType: "plist") {
            let key = NSDictionary(contentsOfFile: path)?[key] as? String ?? ""
            return key
        }
        return ""
    }
}

