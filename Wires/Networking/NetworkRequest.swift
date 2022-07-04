//
//  NetworkRequest.swift
//  Wires
//
//  Created by Emel Topaloglu on 1/25/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Alamofire

open class NetworkRequest: NSObject {
    public var url: String
    public var encoding: ParameterEncoding
    public var headers: HTTPHeaders?
    public var method: HTTPMethod = HTTPMethod.get
    public var queryParameters: [String: String] = [:]
    public var model: Mappable?
    public var snakeModel: SnakeCaseMappable?
    
    public var fullUrl: String {
        var queryItems: [URLQueryItem] = []
        for (queryKey, queryValue) in queryParameters {
            queryItems.append(URLQueryItem(name: queryKey, value: queryValue))
        }
        
        if let urlComps = NSURLComponents(string: url) {
            urlComps.queryItems = queryItems
            if let fullString = urlComps.url?.absoluteString {
                return fullString
            }
        }
        
        return url
    }
    
    public init(url: String,
                method: HTTPMethod = HTTPMethod.get,
                encoding: ParameterEncoding = JSONEncoding.default,
                headers: HTTPHeaders?) {
        
        self.url = url
        self.method = method
        self.encoding = encoding
        self.headers = headers
    }
}
