//
//  ApiWrapper.swift
//  Commons
//
//  Created by Chandan on 26/11/18.
//  Copyright © 2018 Opentalk. All rights reserved.
//

import Foundation

public class NetworkRequest {
    public static var shared = NetworkRequest()
    
    public func call<T: Codable>(url: String, params: [String: Any], files:[URL], requestHeaders: [String: String], returnCache: Bool, requestInterceptor: ((inout URLRequest, [String: Any], [URL]) -> Void)? = nil, callback: @escaping HttpResultHandler<T>) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async { [weak self] in
            guard let `self` = self else { return }
            self.mainCall(urlString: url, params: params, files: files, requestHeaders: requestHeaders, returnCache: returnCache, requestInterceptor: requestInterceptor, handler: callback)
        }
    }
    
    private func mainCall<T: Codable>(urlString: String, params: [String: Any], files:[URL], requestHeaders: [String: String], returnCache: Bool, requestInterceptor: ((inout URLRequest, [String: Any], [URL]) -> Void)? = nil, handler: @escaping HttpResultHandler<T>) {
        var urlComps = urlString.split(separator: "|")
        guard let first = urlComps.first, let last = urlComps.popLast(), let method = HttpMethods(rawValue: String(last)) else {
            print("invalid url structure \(urlString)")
            return
        }
        let f = String(first)
        guard let url = URL(string: f) else {
            print("cannot create URL \(f)")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        var urlRequestForCache = URLRequest(url: url)
        
        if method == .POST || method == .PUT || method == .DELETE {
            
        } else if method == .GET {
            guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                print("cannot create URLComponents")
                return
            }
            comps.queryItems = params.compactMap({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
            if let newUrl = comps.url {
                urlRequest = URLRequest(url: newUrl)
                urlRequestForCache = URLRequest(url: newUrl)
            } else {
                print("cannot create url from query items")
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        requestHeaders.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })
        
        if method == .POST || method == .PUT || method == .DELETE {
            if let requestInterceptor = requestInterceptor {
                requestInterceptor(&urlRequest, params, files)
            }
        }
        
        let task = getSession().dataTask(with: urlRequest) { [weak self] data, res, error in
            self?.logging(url: urlString, requestHeaders: requestHeaders, params: params, data: data)
            guard let `self` = self else { return }
            if returnCache, res == nil, let found = URLCache.shared.cachedResponse(for: urlRequestForCache) {
                self.callCompletion(data: found.data, res: nil, error: nil, handler: handler)
            } else {
                self.callCompletion(data: data, res: res, error: error, handler: handler)
                if returnCache, let data = data, let res = res {
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: res, data: data), for: urlRequestForCache)
                }
            }
        }
        task.resume()
    }
    
    private func callCompletion<T: Codable>(data: Data?, res: URLResponse?, error: Error?, handler: @escaping HttpResultHandler<T>) {
        let result = HttpResult<T>(response: res as? HTTPURLResponse, error: error)
        if error != nil {
            print(error!)
        } else {
            if let responseData = data {
                result.string = String(data: responseData, encoding: String.Encoding.utf8)
                if let json = try? JSONDecoder().decode(T.self, from: responseData) {
                    result.json = json
                } else {
                    print("object mapping failed")
                }
            } else {
                print("did not receive data")
            }
        }
        handler(result)
    }
    
    private func logging(url: String, requestHeaders: [String: String], params: [String: Any], data: Data?) {
        let string = data == nil ? "nil" : String(data: data!, encoding: String.Encoding.utf8)
        print("\nINPUT: \(url), \nHEADERS: \(requestHeaders), \nPARAMS: \(Utils.toJsonString(params) ?? "nil")\nOUTPUT: \(string ?? "nil")")
    }
    
    var session: URLSession?
    func getSession() -> URLSession {
        if let session = self.session {
            return session
        } else {
            let config = URLSessionConfiguration.default
            config.httpShouldUsePipelining = true
            config.shouldUseExtendedBackgroundIdleMode = true
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 300
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.session = URLSession(configuration: config)
            return self.session!
        }
    }
    
    var sessionUpload: URLSession?
    func getSessionUpload() -> URLSession {
        if let sessionUpload = self.sessionUpload {
            return sessionUpload
        } else {
            let config = URLSessionConfiguration.default
            config.httpShouldUsePipelining = true
            config.shouldUseExtendedBackgroundIdleMode = true
            config.timeoutIntervalForRequest = 120
            config.timeoutIntervalForResource = 300
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.sessionUpload = URLSession(configuration: config)
            return self.sessionUpload!
        }
    }
}

public enum HttpMethods: String {
    case GET, POST, PUT, DELETE
}

public typealias HttpResultHandler<T: Codable> = ((_ result: HttpResult<T>) -> Void)

public class HttpResult<T: Codable> {
    public var response: HTTPURLResponse?
    public var error: Error?
    public var string: String?
    public var json: T?
    public var notReached = true
    
    var succ: Bool = false
    
    public init() {}
    
    public init(response: HTTPURLResponse?, error: Error?) {
        self.response = response
        self.error = error
        
        self.succ = (self.response?.statusCode ?? 0) == 200
        self.notReached = (self.response?.statusCode ?? 0) == 0
    }
}
