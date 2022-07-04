//
//  NetworkConfiguration.swift
//  Wires
//
//  Created by Emel Topaloglu on 2/8/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Foundation

public struct Endpoint {
    public var name: String
    public var urlAddress: String
    public var url: URL? {
        return URL(string: urlAddress)
    }
    
    public init(name: String, urlAddress: String) {
        self.name = name
        self.urlAddress = urlAddress
    }
}

extension Endpoint: Equatable {}

public func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
    let areEqual = lhs.name == rhs.name &&
        lhs.urlAddress == rhs.urlAddress
    return areEqual
}

open class NetworkConfiguration {
    public var headers: [String: String] = [:]
    public var endpoint: Endpoint!
    
    public init() {
        
    }
    
    public func url(with path: String) -> String {
        return "\(endpoint.urlAddress)\(path)"
    }
}
