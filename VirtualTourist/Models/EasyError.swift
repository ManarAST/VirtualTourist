//
//  EasyError.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 14/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation

struct EasyError {
    let error: Error?
    var customError: String?
    
    var message: String {
        if let customError = customError {
            return customError
        } else if let error = error {
            return error.localizedDescription
        }
        fatalError("\n This should not happeed: there should be ether error or customError for easyError ")
    }
}
