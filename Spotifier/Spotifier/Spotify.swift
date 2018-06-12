//
//  Spotify.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

final class Spotify {
    
    //init() {}
    typealias Callback = (JSON?, SpotifyError?) -> Void
    
    func call(endpoint: Endpoint, callback: @escaping Callback) {
        let req = endpoint.urlRequest
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            print(error?.localizedDescription ?? "")
            
        }
        task.resume()
    }
}

private extension Spotify {
    static let basePath: String = "https://api.spotify.com/v1/"
    
    static let commonHeaders: [String: String] = {
        return [
            "User-Agent": "Spotifier v1.0",
            "Accept-Charset": "utf-8",
            "Accept-Encoding": "gzip, deflate"
        ]
    }()
}

extension Spotify {
    
    enum SearchType: String {
        case album, artist, playlist, track
    }
    
    enum Endpoint {
        case search(term: String, type: SearchType, market: String?, limit: Int?, offset: Int?)
        case albums(albumId: String?)
        
        fileprivate var urlRequest: URLRequest {
            
            
            guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                fatalError("Invalid path-based URL")
            }
            comps.queryItems = queryItems
            
            guard let finalURL = comps.url else {
                fatalError("Invalid query items...")
            }
            var req = URLRequest(url: finalURL)
            req.httpMethod = method
            req.allHTTPHeaderFields = headers
            
            return req
        }
        
        private var headers: [String: String] {
            let h = Spotify.commonHeaders
            
            switch self {
            case .search, .albums:
                break
            }
            
            return h
        }
        
        private var method: String {
            switch self {
            case .search, .albums:
                return "GET"
            }
        }
        
        private var url: URL {
            guard var fullURL = URL(string: Spotify.basePath) else {
                fatalError()
            }
            switch self {
            case .search:
                return fullURL.appendingPathComponent("search")
                
            case .albums(let albumId):
                fullURL = fullURL.appendingPathComponent("albums")
                if let albumId = albumId {
                    return fullURL.appendingPathComponent(albumId)
                }
                return fullURL
                
            }
            //fatalError("Failed to create proepr URL")
        }
        
        private var params: [String: Any] {
            var p: [String: Any] = [:]
            
            switch self {
            case .search(let term, let type, let market, let limit, let offset):
                p["q"] = term
                p["type"] = type.rawValue
                if let market = market {
                    p["market"] = market
                }
                if let limit = limit {
                    p["limit"] = limit
                }
                if let offset = offset {
                    p["offset"] = offset
                }
                
            case .albums:
                break
            }
            return p
        }
        
        private var queryItems: [URLQueryItem] {
            var arr: [URLQueryItem] = []
            
            for (key, value) in params {
                let qi = URLQueryItem(name: key, value: "\(value)")
                arr.append(qi)
            }
            
            return arr
        }
    }
}











