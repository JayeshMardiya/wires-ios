//
//  Mappable.swift
//  Wires
//
//  Created by Emel Topaloglu on 7/31/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Foundation

public protocol Mappable: Codable {
    init?(dictionary: [String: AnyObject])
    init?(jsonString: String)
    func serialize() -> Data
    func serializeToDictionary() -> [String: AnyObject]
}
public extension Mappable {
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
                    self = try JSONDecoder().decode(Self.self, from: data)
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
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    public init?(data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    public func serialize() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    public func serializeToDictionary() -> [String: AnyObject] {
        guard let JSON = (try? JSONSerialization.jsonObject(with: self.serialize(), options: [])) as? [String: AnyObject] else {
            return [:]
        }
        return JSON
    }
}
