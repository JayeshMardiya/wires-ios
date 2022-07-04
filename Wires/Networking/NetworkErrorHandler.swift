//
//  NetworkErrorHandler.swift
//  Wires
//
//  Created by Emel Topaloglu on 2/16/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Alamofire
import Foundation

public struct NetworkError {
    public var networkingError: Error?
    public var data: Data?
    
    public init() {
        
    }
}

public protocol GlobalErrorReceiver: class {
    func handle(error: NetworkError)
}

open class NetworkErrorHandler: NSObject {
    public var globalReceiver: GlobalErrorReceiver?
    
    open func handle(response: DataResponse<Any>) -> (Data?, NetworkError?) {
        switch response.result {
        case .success:
            return(response.data, nil)
        case .failure:
            var error = NetworkError()
            error.data = response.data
            error.networkingError = response.error
            globalReceiver?.handle(error: error)
            return (nil, error)
        }
    }
    
    open func handle(response: DefaultDataResponse) -> (NetworkError?) {
        if response.error == nil {
            return nil
        }
        else {
            let networkError = NetworkError()
            globalReceiver?.handle(error: networkError)
            return (networkError)
        }
    }
}
