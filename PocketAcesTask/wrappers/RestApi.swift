//
//  ApiNew.swift
//  Opentalk
//
//  Created by Chandan on 26/11/18.
//  Copyright © 2018 OpenTalk. All rights reserved.
//

import Foundation
import MobileCoreServices

typealias ResponseHandler<T: Codable> = ((_ result: HttpResult<T>, _ data: T?) -> Void)

class RestApi {
    static let requestInterceptorGlobal: ((inout URLRequest, [String: Any], [URL]) -> Void) = { urlRequest, params, files in
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = json
        } catch let error {
            print(error)
        }
    }
    
    static let requestInterceptorGlobalUpload: ((inout URLRequest, [String: Any], [URL]) -> Void) = { urlRequest, params, files in
        do {
            let newParams = ["data": params]
            let json = try JSONSerialization.data(withJSONObject: newParams, options: [])
            if let jsonStr = String(data: json, encoding: .utf8) {
                let boundary = generateBoundaryString()
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try createBody(with: ["post_data": jsonStr], filePathKey: "file", paths: files, boundary: boundary)
            }
        } catch let error {
            print(error)
        }
    }
    
    static func call<T: Codable>(url: String,
                                  params: [String: Any],
                                  files: [URL] = [],
                                  handler: @escaping ResponseHandler<T>,
                                  returnCache: Bool = false,
                                  requestInterceptor: ((inout URLRequest, [String: Any], [URL]) -> Void)? = requestInterceptorGlobal) {
        
        
            NetworkRequest.shared.call(url: url,
                                       params: params,
                                       files: files,
                                       requestHeaders: header(),
                                       returnCache: returnCache,
                                       requestInterceptor: requestInterceptor) { (_ result: HttpResult<T>) in
                                        convertToObj(result: result, url: url, params: params, handler: handler)
            }
    }
    
    private static func convertToObj<T: Codable>(result: HttpResult<T>?, url: String, params: [String: Any], handler: @escaping ResponseHandler<T>) {
        let newResult = result ?? HttpResult<T>()
        DispatchQueue.main.async {
            handler(newResult, newResult.json)
        }
    }
    
    static func header() -> [String: String] {
        var header = ["Content-Type": "application/json"]
        header["os-type"] = "ios"
        //header["app-version"] = String(App.appVersionInt)
        
        return header
    }
    
    // MARK: for uploading files
    private static func createBody(with parameters: [String: String]?, filePathKey: String, paths: [URL], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for path in paths {
            if let data = try? Data(contentsOf: path) {
                let filename = path.lastPathComponent
                
                let mimetype = mimeType(for: path.absoluteString)
                
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            }
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private static func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
}

fileprivate extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
