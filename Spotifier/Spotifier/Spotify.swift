//
//  Spotify.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation
import SwiftyOAuth


typealias JSON = [String: Any]

//Client ID: badf9c13b4604dd3b6f3335df4542100
//Client Secret: a889c1f8e98f4e07a93fbb56ce5d19a5

final class Spotify {
    
    //init() {}
    
    typealias Callback = (Data?, SpotifyError?) -> Void
    
    func call(endpoint: Endpoint, callback: @escaping Callback) {
        let apiRequest = (endpoint, callback)

        // apply Authorization
        
        oAuth(request: apiRequest)
        
    }
    
    private let oAuthProvider = Provider.spotify(clientID: "badf9c13b4604dd3b6f3335df4542100", clientSecret: "a889c1f8e98f4e07a93fbb56ce5d19a5")
    private typealias APIRequest = (endpoint: Endpoint, callback: Callback)
    private var queuedRequests: [APIRequest] = []
    private var isFetchingToken = false {
        didSet{
            if isFetchingToken { return }
            processQueuedRequests()
        }
    }
}

private extension Spotify {
    private func oAuth(request: APIRequest) {
        if isFetchingToken {
            queuedRequests.append(request)
            return
        }
        
        // is token available
        guard let token = oAuthProvider.token else {
            queuedRequests.append(request)
            
            fetchToken()
            return
        }
        
        // is token valid
        if token.isExpired {
            queuedRequests.append(request)
            
            refreshToken()
            return
        }
        
        //execute
        execute(request: request)
        
    }
    
    private func execute(request: APIRequest) {
        var urlReq = request.endpoint.urlRequest
        let callback = request.callback
        
        urlReq.addValue("Bearer \(oAuthProvider.token!.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            
            if let error = error {
                callback(nil, SpotifyError.urlError(error as! URLError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                callback(nil, SpotifyError.invalidResponse)
                return
            }
            
            if !(200..<300).contains(httpResponse.statusCode) {
                callback(nil, SpotifyError.invalidResponse)
                return
            }
            
            guard let data = data else {
                callback(nil, SpotifyError.noData)
                return
            }
            
//            // process
//            guard let obj = try? JSONSerialization.jsonObject(with: data, options: []),
//                let json = obj as? [String: Any]
//                else {
//                    callback(nil, SpotifyError.invalidResponse)
//                    return
//            }
//
            callback(data, nil)
        }
        task.resume()
    }
    
    private func fetchToken() {
        if isFetchingToken { return }
        
        isFetchingToken = true
        oAuthProvider.authorize {
            [unowned self] result in
            
            self.isFetchingToken = false
            
            switch result {
            case .success(let token):
                print(token)
                break
                
            case.failure:
                // TODO:
                break
            }
        }
    }
    
    private func refreshToken() {
        fetchToken()
    }
    
    func processQueuedRequests() {
        for apiReq in queuedRequests {
            oAuth(request: apiReq)
        }
        
        queuedRequests.removeAll()
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
        
        init?(index: Int) {
            switch index {
            case 0:
                self = .artist
            case 1:
                self = .album
            case 2:
                self = .track
            case 3:
                self = .playlist
            default:
                return nil
            }
        }
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











