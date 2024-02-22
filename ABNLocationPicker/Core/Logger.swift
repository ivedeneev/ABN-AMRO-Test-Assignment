//
//  Logger.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import Foundation

final class Logger {
    
    private init() {}
    
    static func logDebug(_ msg: String) {
        #if DEBUG
        print(msg)
        #endif
    }
}
