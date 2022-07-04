//
//  NetworkManager.swift
//  Wires
//
//  Created by Emel Topaloglu on 1/25/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Alamofire

public typealias NetworkResponse = (_ data: Data?, _ error: NetworkError?) -> Void
public typealias ResponseModel<T: Mappable> = (_ model: T?, _ error: NetworkError?) -> Void

open class NetworkManager: Alamofire.SessionManager {
    //Override if you want to use your own classes
    public static var networkErrorHandler = NetworkErrorHandler()
    
    @discardableResult
    public static func send(request: NetworkRequest,
                            completion: @escaping NetworkResponse) -> DataRequest? {
        ActivityIndicatorManager.shared.increment()
        
        var bodyParameters: [String: AnyHashable]?
        if let parameterizedRequest = request.model,
            (request.method == .post || request.method == .put || request.method == .patch || request.method == .delete) {
            if let parameters = parameterizedRequest.serializeToDictionary() as? [String: AnyHashable] {
                bodyParameters = parameters
            }
        } else if let parameterizedRequest = request.snakeModel,
            (request.method == .post || request.method == .put || request.method == .patch || request.method == .delete) {
            if let parameters = parameterizedRequest.serializeToDictionary() as? [String: AnyHashable] {
                bodyParameters = parameters
            }
        }
        
        let dataRequest = Alamofire.request(request.fullUrl, method: request.method, parameters: bodyParameters, encoding: request.encoding, headers: request.headers)
            .validate()
            .responseJSON { (response) -> Void in
                ActivityIndicatorManager.shared.decrement()
                let (data, error) = networkErrorHandler.handle(response: response)
                completion(data, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public static func send<T: Mappable>(request: NetworkRequest, clazz: T.Type, completion: @escaping ResponseModel<T>) -> DataRequest? {
        return send(request: request, completion: { (data, error) in
            if error == nil {
                if let data = data, let model = T(data: data) {
                    completion(model, nil)
                } else {
                    var error = NetworkError()
                    error.data = data
                    error.networkingError = NSError(domain: "Error parsing object", code: -1, userInfo: nil)
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        })
    }
    
    @discardableResult
    public static func uploadData(data: Data,
                                  url: String,
                                  showLoadingIndicator: Bool,
                                  handleError: Bool,
                                  completion: @escaping ((_ error: NetworkError?) -> Void)) -> DataRequest? {
        ActivityIndicatorManager.shared.increment()
        let dataRequest = Alamofire.upload(data, to: url, method: .put, headers: nil).response { (response) in
            ActivityIndicatorManager.shared.decrement()
            let error = networkErrorHandler.handle(response: response)
            completion(error)
        }
        
        return dataRequest
    }
}
