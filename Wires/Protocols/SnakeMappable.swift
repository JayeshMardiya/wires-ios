//
//  SnakeCaseMappable.swift
//  Wires
//
//  Created by Sinem Alak on 2/21/19.
//  Copyright © 2019 Swenson He. All rights reserved.
//

import Foundation

public protocol SnakeCaseMappable: Mappable {

}

public extension SnakeCaseMappable {
    public init?(dictionary: [String: AnyObject]) {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            if let theJSONText = String(data: theJSONData,
                                        encoding: .utf8) {
                guard let data = theJSONText.data(using: .utf8) else {
                    return nil
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self = try decoder.decode(Self.self, from: data)
                    return
                } catch {
                    debugPrint(error)
                    return nil
                }
            }
        }
        return nil
    }
    
    public init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self = try decoder.decode(Self.self, from: data)
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    public init?(data: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self = try decoder.decode(Self.self, from: data)
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    public func serialize() -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try! encoder.encode(self)
    }
    
    public func serializeToDictionary() -> [String: AnyObject] {
        guard let JSON = (try? JSONSerialization.jsonObject(with: self.serialize(), options: [])) as? [String: AnyObject] else {
            return [:]
        }
        return JSON
    }
}
