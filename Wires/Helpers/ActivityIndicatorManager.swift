//
//  ActivityIndicatorManager.swift
//  Wires
//
//  Created by Emel Topaloglu on 6/30/17.
//  Copyright © 2017 Swenson He. All rights reserved.
//

import Foundation

public class ActivityIndicatorManager: NSObject {
    public static var shared = ActivityIndicatorManager()
    private var counter: Int = 0
    
    func increment() {
        if counter == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        counter += 1
    }
    
    func decrement() {
        if counter > 0 {
            counter -= 1
        }
        
        if counter == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
